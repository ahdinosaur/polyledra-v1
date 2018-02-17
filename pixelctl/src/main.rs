#[macro_use] extern crate log;
extern crate env_logger;
extern crate modulo;
extern crate glfw;
extern crate kiss3d;
extern crate nalgebra as na;

use std::sync::mpsc::{TryRecvError};

mod clock;
mod color;
mod control;
mod display;
mod render;
mod scene;
mod shape;
use shape::AbstractShapeCreator;

fn main() {
    env_logger::init();

    let clock_rx = clock::create_clock_rx(60);

    let abstract_shape = shape::Tetrahedron::new(1.0);
    let shape = shape::Shape::new(shape::ShapeOptions {
        abstract_shape,
        edge_length: 1.0,
        pixel_density: 30.0
    });

    let render_shape = render::RenderMessage::Shape(shape);
    let (control_tx, control_rx) = control::create_control_channel();
    let display_tx = display::create_display_tx(control_tx.clone());
    let render_tx = render::create_render_tx(display_tx);

    render_tx.send(render_shape).unwrap();
    
    loop {
        let clock_message_result = clock_rx.try_recv();
        match clock_message_result {
            Ok(clock_message) => {
                let mut render_message;
                match clock_message {
                    clock::ClockMessage::Time(value) => {
                        render_message = render::RenderMessage::Time(value);
                    }
                }
                render_tx.send(render_message).unwrap();
            }
            Err(TryRecvError::Empty) => {}
            Err(TryRecvError::Disconnected) => {
                panic!(TryRecvError::Disconnected);
            }
        }

        let control_message_result = control_rx.try_recv();
        match control_message_result {
            Ok(control_message) => {
                let mut render_message;
                match control_message {
                    control::ControlMessage::ChangeMode(value) => {
                        render_message = render::RenderMessage::ChangeMode(value);
                    }
                }
                render_tx.send(render_message).unwrap();
            }
            Err(TryRecvError::Empty) => {}
            Err(TryRecvError::Disconnected) => {
                panic!("{:?}", TryRecvError::Disconnected);
            }
        }
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
