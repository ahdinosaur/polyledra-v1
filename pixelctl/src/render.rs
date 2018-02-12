use std::thread;
use std::sync::mpsc::{channel, Sender, Iter};

use clock;
use display;
use shape;
use color;

pub struct RenderMessage {
    pub time: clock::Time,
    pub point_shape: shape::PointShape
}

pub fn create_render_tx() -> Sender<RenderMessage> {
    let display_tx = display::create_display_tx();

    let (render_tx, render_rx) = channel();
    thread::spawn(move|| {
        let render_iter: Iter<RenderMessage> = render_rx.iter();
        for render_message in render_iter {
            let point_shape = render_message.point_shape;
            let points = point_shape.points;
            let colors = points.iter().map(|_point| {
                return color::RGB { red: 0.0, green: 1.0, blue: 0.0 };
            }).collect();
            let pixel_shape = shape::PixelShape {
                points: points,
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
