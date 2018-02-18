extern crate kiss3d;
extern crate nalgebra as na;

use glfw::{Action, WindowEvent, Key};
use kiss3d::scene::SceneNode;
use kiss3d::window::Window;
use kiss3d::light::Light;
use na::{Translation3};
use std::process;
use std::thread;
use std::iter;
use std::vec;
use std::sync::mpsc::{channel, Sender};
use std::sync::mpsc;

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

        let mut pixel_nodes: Vec<SceneNode> = Vec::new();

        loop {
            let mut next_shape = None;
            let mut next_pixels = None;

            // block on first message
            let first_display_message = display_rx.recv().unwrap();
            let first_display_messages = vec![first_display_message];
            // unblocking read of next messages
            // (to stay up-to-date and batch displays)
            let next_display_messages: iter::Chain<vec::IntoIter<DisplayMessage>, mpsc::TryIter<DisplayMessage>>  = first_display_messages
                .into_iter()
                .chain(
                    display_rx.try_iter()
                );

            for display_message in next_display_messages {
                match display_message {
                    DisplayMessage::Shape(value) => {
                        next_shape = Some(value);
                    },
                    DisplayMessage::Pixels(value) => {
                        next_pixels = Some(value);
                    }
                }
            }

            match next_shape {
                None => {},
                Some(shape) => {
                    // clear existing pixels
                    for pixel_node in pixel_nodes.iter_mut() {
                        window.remove(pixel_node);
                    }

                    // add new pixels
                    for dot in shape.dots {
                        let mut pixel_node = window.add_cube(0.01, 0.01, 0.01);
                        let position = dot.position;
                        let translation = Translation3::new(position.x, position.y, position.z);
                        pixel_node.set_local_translation(translation);
                        pixel_nodes.push(pixel_node);
                    }
                }
            }

            match next_pixels {
                None => {},
                Some(pixels) => {
                    // update colors of existing pixels
                    for (index, rgb) in pixels.iter().enumerate() {
                        let mut pixel_node = pixel_nodes.get_mut(index).unwrap();
                        pixel_node.set_color(rgb.red, rgb.green, rgb.blue);
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
