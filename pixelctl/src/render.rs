use std::f32;
use std::f32::consts::PI;
use std::thread;
use std::sync::mpsc::{channel, Sender};

use clock;
use display;
use shape;
use color;
use color::Color;

pub enum RenderMessage {
    Time(clock::Time),
    DotShape(shape::DotShape)
}

pub fn create_render_tx() -> Sender<RenderMessage> {
    let display_tx = display::create_display_tx();

    let (render_tx, render_rx) = channel::<RenderMessage>();
    thread::spawn(move|| {
        let mut time;
        let mut dot_shape = shape::DotShape::none();

        for render_message in render_rx {
            match render_message {
                RenderMessage::Time(value) => {
                    time = value;
                    render(&display_tx, time, &dot_shape);
                },
                RenderMessage::DotShape(value) => {
                    dot_shape = value;
                }
            }
        }
    });
    return render_tx;
}

fn render (display_tx : &Sender<display::DisplayMessage>, time: clock::Time, dot_shape: &shape::DotShape) {
    let ms_per_s = 1.0e9; // microseconds_per_second

    let amp_red = ((time / ms_per_s).sin() - 1.0).abs();
    let amp_green = ((((time / ms_per_s)) + ((1.0/3.0) * (2.0 * PI))).sin() - 1.0).abs();
    let amp_blue = ((((time / ms_per_s)) + ((2.0/3.0) * (2.0 * PI))).sin() - 1.0).abs();
    let dots = &dot_shape.dots;
    let colors = dots
        .iter()
        .map(|dot| {
            let position = dot.position;
            return color::RGB {
                red: position.x * amp_red,
                green: position.y * amp_green,
                blue: position.z * amp_blue
            };
        })
        .map(|color| color.to_rgb())
        .collect();
    let pixel_shape = shape::PixelShape {
        dots: dots.clone(),
        colors: colors
    };
    let display_message = display::DisplayMessage {
        pixel_shape: pixel_shape
    };
    display_tx.send(display_message).unwrap();
}
