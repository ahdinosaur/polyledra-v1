use std::f32::consts::PI;
use std::thread;
use std::sync::mpsc::{channel, Sender};

use clock;
use display;
use shape;
use color;

pub enum RenderMessage {
    Time(clock::Time),
    Shape(shape::Shape)
}

pub fn create_render_tx() -> Sender<RenderMessage> {
    let display_tx = display::create_display_tx();

    let (render_tx, render_rx) = channel::<RenderMessage>();
    thread::spawn(move|| {
        let mut time;
        let mut shape = shape::Shape::none();

        for render_message in render_rx {
            match render_message {
                RenderMessage::Time(value) => {
                    time = value;
                    render(&display_tx, time, &shape);
                },
                RenderMessage::Shape(value) => {
                    shape = value;
                    let display_message = display::DisplayMessage::Shape(shape.clone());
                    display_tx.send(display_message).unwrap();
                }
            }
        }
    });
    return render_tx;
}

fn render (display_tx : &Sender<display::DisplayMessage>, time: clock::Time, shape: &shape::Shape) {
    let ms_per_s = 1.0e9; // microseconds_per_second

    let amp_red = ((time / ms_per_s).sin() - 1.0).abs();
    let amp_green = ((((time / ms_per_s)) + ((1.0/3.0) * (2.0 * PI))).sin() - 1.0).abs();
    let amp_blue = ((((time / ms_per_s)) + ((2.0/3.0) * (2.0 * PI))).sin() - 1.0).abs();
    debug!("time: {} {} {} {}", time, amp_red, amp_green, amp_blue);

    let dots = &shape.dots;
    let colors = dots
        .iter()
        .map(|dot| {
            let position = dot.position;
            return color::Color::RGB(color::RGB {
                red: position.x * amp_red,
                green: position.y * amp_green,
                blue: position.z * amp_blue
            });
        })
        .collect();
    let display_message = display::DisplayMessage::Colors(colors);
    display_tx.send(display_message).unwrap();
}
