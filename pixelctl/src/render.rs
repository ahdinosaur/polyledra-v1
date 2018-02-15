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

fn render (display_tx : &Sender<display::DisplayMessage>, _time: clock::Time, dot_shape: &shape::DotShape) {
    let dots = &dot_shape.dots;
    let colors = dots
        .iter()
        .map(|dot| {
            let position = dot.position;
            return color::RGB { red: position.x, green: position.y, blue: position.z };
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
