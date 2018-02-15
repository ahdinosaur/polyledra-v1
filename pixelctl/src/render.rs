use std::thread;
use std::sync::mpsc::{channel, Sender};

use clock;
use display;
use shape;
use color;
use color::Color;

pub struct RenderMessage {
    pub time: clock::Time,
    pub dot_shape: shape::DotShape
}

pub fn create_render_tx() -> Sender<RenderMessage> {
    let display_tx = display::create_display_tx();

    let (render_tx, render_rx) = channel::<RenderMessage>();
    thread::spawn(move|| {
        for render_message in render_rx {
            let dot_shape = render_message.dot_shape;
            let dots = dot_shape.dots;
            let colors = dots
                .iter()
                .map(|_dot| {
                    return color::RGB { red: 0.0, green: 1.0, blue: 0.0 };
                })
                .map(|color| color.to_rgb())
                .collect();
            let pixel_shape = shape::PixelShape {
                dots: dots,
                colors: colors
            };
            let display_message = display::DisplayMessage {
                pixel_shape: pixel_shape
            };
            display_tx.send(display_message).unwrap();
        }
    });
    return render_tx;
}
