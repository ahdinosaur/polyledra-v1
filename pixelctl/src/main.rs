extern crate kiss3d;
extern crate nalgebra as na;

use std::sync::mpsc::{Iter};

mod clock;
mod render;
mod display;
mod shape;
mod color;

fn main() {
    let clock_rx = clock::create_clock_rx(60);
    let render_tx = render::create_render_tx();

    let abstract_shape = shape::create_tetrahedron(1.0);
    let point_shape = shape::create_point_shape(shape::PointShapeOptions {
        abstract_shape,
        edge_length: 1.0,
        pixel_density: 10.0
    });

    let clock_iter: Iter<clock::ClockMessage> = clock_rx.iter();
    for clock_message in clock_iter {
        let render_message = render::RenderMessage {
            time: clock_message.time,
            point_shape: point_shape.clone()
        };
        render_tx.send(render_message).unwrap();
    }
}

/*
struct LedStrip {
    pub controller: LedController,
    pub leds: Vec<RGB>,
    pub brightness: f32,
    pub temperature: ColorTemperature,
    pub correction: ColorCorrection,
    pub dither: DitherMode,
    pub maxPowerInMilliWatts: i32
}
*/
