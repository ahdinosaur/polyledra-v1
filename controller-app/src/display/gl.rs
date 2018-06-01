extern crate kiss3d;
extern crate nalgebra as na;

use glfw::{Action, WindowEvent, Key};
use kiss3d::window::Window;
use kiss3d::light::Light;
use std::sync::mpsc::{Sender};

use na::{Point3};
use std::process;

use color;
use control;
use shape;
use display::{Display, DisplayMessage};

pub struct GlDisplay {
    window: Window,
    shape: shape::Shape,
    control_tx: Sender<control::Control>
}

impl Display for GlDisplay {
    fn new (control_tx: Sender<control::Control>) -> Self {
        let mut window = Window::new("pixelctl");
        let shape = shape::Shape::none();

        window.set_light(Light::StickToCamera);

        GlDisplay {
            window: window,
            shape: shape,
            control_tx: control_tx
        }
    }

    fn display (&mut self, display_message: &DisplayMessage) {
        let control_tx = &self.control_tx;
        let window = &mut self.window;

        match display_message {
            &DisplayMessage::Shape(ref shape) => {
                self.shape = shape.clone();
            },
            &DisplayMessage::Pixels(ref pixels) => {
                let shape = &self.shape;
                for (index, rgb) in pixels.iter().enumerate() {
                    let dot = shape.dots.get(index).unwrap();
                    let position = dot.position;
                    let color = Point3::new(rgb.red, rgb.green, rgb.blue);
                    window.draw_point(&position, &color);
                }
            }
        }

        if !window.render() {
            process::exit(1);
        }

        for mut event in window.events().iter() {
            match event.value {
                WindowEvent::Key(code, _, Action::Press, _) => {
                    println!("You pressed the key with code: {:?}", code);
                    event.inhibited = true; // override the default keyboard handler

                    match code {
                        Key::Left => control_tx.send(control::Control::ChangeMode(control::ChangeMode::Prev)).unwrap(),
                        Key::Right => control_tx.send(control::Control::ChangeMode(control::ChangeMode::Next)).unwrap(),
                        _ => {}
                    }
                },
                _ => {}
            }
        }
    }
}
