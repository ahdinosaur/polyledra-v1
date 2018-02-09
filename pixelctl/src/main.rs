extern crate fps_clock;
extern crate kiss3d;
extern crate nalgebra as na;

use std::thread;
use std::sync::mpsc::{channel, Sender, Receiver, Iter};
use na::{Vector3, UnitQuaternion, Translation3};
use kiss3d::window::Window;
use kiss3d::light::Light;

type Time = f32;

struct ClockMessage {
    pub time: Time
}

fn create_clock_rx(fps: u32) -> Receiver<ClockMessage> {
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

struct RenderMessage {
    pub time: Time
}

fn create_render_tx() -> Sender<RenderMessage> {
    let (render_tx, render_rx) = channel();
    thread::spawn(move|| {
        let mut window = Window::new("Kiss3d: points");

        let mut a = window.add_cube(1.0, 1.0, 1.0);
        a.set_color(1.0, 0.0, 0.0);

        window.set_light(Light::StickToCamera);
        let rot = UnitQuaternion::from_axis_angle(&Vector3::y_axis(), 0.014);

        let render_iter: Iter<RenderMessage> = render_rx.iter();
        for render_message in render_iter {
            println!("time: {}", render_message.time);

            a.prepend_to_local_rotation(&rot);
            let translation = Translation3::new(render_message.time / 1.0e9, 0.0, 0.0);
            a.set_local_translation(translation);

            if !window.render() {
              return;
            }
        }
    });
    return render_tx;
}

fn main() {
    let clock_rx = create_clock_rx(60);
    let render_tx = create_render_tx();

    let clock_iter: Iter<ClockMessage> = clock_rx.iter();
    for clock_message in clock_iter {
        let render_message = RenderMessage {
            time: clock_message.time
        };
        render_tx.send(render_message).unwrap();
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
    pub scene_pixels: Vec<ScenePixel>,
    pub led_pixels: Vec<LedPixel>
}

struct LedPixel {
    pub color: Color
}
