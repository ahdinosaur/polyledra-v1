extern crate fps_clock;
extern crate kiss3d;
extern crate nalgebra as na;

use std::thread;
use std::sync::mpsc::{channel, Receiver};
use na::{Vector3, UnitQuaternion, Translation3};
use kiss3d::window::Window;
use kiss3d::light::Light;

struct ClockMessage {
    pub time: f32
}

fn create_clock(fps: u32) -> Receiver<ClockMessage> {
    let (clock_tx, clock_rx) = channel();
    thread::spawn(move|| {
        let mut fps = fps_clock::FpsClock::new(fps);
        let mut nanosecs_since_start = 0.0;
        let mut nanosecs_since_last_tick;
        loop {
            nanosecs_since_last_tick = fps.tick();
            nanosecs_since_start += nanosecs_since_last_tick;
            let clock_message = ClockMessage { time: nanosecs_since_start };
            clock_tx.send(clock_message).unwrap();
        }
    });
    return clock_rx;
}

fn main() {
    let clock = create_clock(60);

    let mut window = Window::new("Kiss3d: points");

    let mut a = window.add_cube(1.0, 1.0, 1.0);
    a.set_color(1.0, 0.0, 0.0);

    window.set_light(Light::StickToCamera);
    let rot = UnitQuaternion::from_axis_angle(&Vector3::y_axis(), 0.014);

    for clock in clock.iter() {
        println!("time: {}", clock.time);

        a.prepend_to_local_rotation(&rot);
        let translation = Translation3::new(clock.time / 1.0e9, 0.0, 0.0);
        a.set_local_translation(translation);

        if !window.render() {
          return;
        }
    }
}

struct RGB {
    pub red: f32,
    pub green: f32,
    pub blue: f32
}
enum Color {
    RGB
}

struct ScenePixel {
    pub position: Vector3<f32>,
    pub color: Color
}

struct PixelCtl {
    pub scenePixels: Vec<ScenePixel>,
    pub ledPixels: Vec<LedPixel>
}

struct LedPixel {
    pub color: Color
}
