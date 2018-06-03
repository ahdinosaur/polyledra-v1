extern crate rand;
extern crate env_logger;
#[cfg(feature = "gl")]
extern crate glfw;
#[cfg(feature = "gl")]
extern crate kiss3d;
#[cfg(feature = "hal")]
extern crate linux_embedded_hal as hal;
#[macro_use] extern crate log;
extern crate modulo;
extern crate nalgebra as na;

mod color;
mod control;
mod display;
mod render;
mod scene;
mod shape;
use shape::AbstractShapeCreator;
mod util;

fn main() {
    env_logger::init();

    let abstract_shape = shape::Tetrahedron::new(1.0);
    let shape = shape::Shape::new(shape::ShapeOptions {
        abstract_shape,
        pixel_density: 30.0,
        num_arms: 3
    });

    let (control_tx, control_rx) = control::create_control_channel();

    control::connect_clock(30, control_tx.clone());

    let display_tx = display::create_display_tx(control_tx.clone());
    let render_tx = render::create_render_tx(display_tx);

    let render_shape = render::RenderMessage::Shape(shape);
    render_tx.send(render_shape).unwrap();
    
    for control_message in control_rx {
        let mut render_message;
        match control_message {
            control::Control::Time(value) => {
                render_message = render::RenderMessage::Time(value);
            },
            control::Control::ChangeMode(value) => {
                render_message = render::RenderMessage::ChangeMode(value);
            }
        }
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
