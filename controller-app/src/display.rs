extern crate kiss3d;
extern crate nalgebra as na;

use glfw::{Action, WindowEvent, Key};
use kiss3d::window::Window;
use kiss3d::light::Light;
use na::{Point3};
use std::process;
use std::sync::mpsc::{channel, Sender};
use std::thread;

use color;
use control;
use shape;

pub enum DisplayMessage {
    Shape(shape::Shape),
    Pixels(color::Pixels)
}

pub fn create_display_tx(control_tx: Sender<control::Control>) -> Sender<DisplayMessage> {
    let (display_tx, display_rx) = channel::<DisplayMessage>();

    thread::spawn(move|| {
        let mut window = Window::new("pixelctl");

        window.set_light(Light::StickToCamera);

        let mut shape = shape::Shape::none();

        for display_message in display_rx {
            match display_message {
                DisplayMessage::Shape(value) => {
                    shape = value;
                },
                DisplayMessage::Pixels(pixels) => {
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
    });
    return display_tx;
}
