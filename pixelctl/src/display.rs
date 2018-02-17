extern crate kiss3d;
extern crate nalgebra as na;

use glfw::{Action, WindowEvent, Key};
use kiss3d::scene::SceneNode;
use kiss3d::window::Window;
use kiss3d::light::Light;
use na::{Translation3};
use std::thread;
use std::sync::mpsc::{channel, Sender, TryRecvError};

use color;
use control;
use shape;

pub enum DisplayMessage {
    Shape(shape::Shape),
    Colors(color::Colors)
}

pub fn create_display_tx(control_tx: Sender<control::ControlMessage>) -> Sender<DisplayMessage> {
    let (display_tx, display_rx) = channel::<DisplayMessage>();

    thread::spawn(move|| {
        let mut window = Window::new("pixelctl");

        window.set_light(Light::StickToCamera);

        let mut pixels: Vec<SceneNode> = Vec::new();

        loop {
            let display_message_result = display_rx.try_recv();
            match display_message_result {
                Ok(DisplayMessage::Shape(value)) => {
                    // clear existing pixels
                    for pixel in pixels.iter_mut() {
                        window.remove(pixel);
                    }

                    // add new pixels
                    let shape = value;
                    for dot in shape.dots {
                        let mut pixel = window.add_cube(0.01, 0.01, 0.01);
                        let position = dot.position;
                        let translation = Translation3::new(position.x, position.y, position.z);
                        pixel.set_local_translation(translation);
                        pixels.push(pixel);
                    }
                },
                Ok(DisplayMessage::Colors(value)) => {
                    // update colors of existing pixels
                    let colors = value;
                    for (index, color) in colors.iter().enumerate() {
                        let rgb = color.to_rgb();
                        let mut pixel = pixels.get_mut(index).unwrap();
                        pixel.set_color(rgb.red, rgb.green, rgb.blue);
                    }
                },
                Err(TryRecvError::Empty) => {},
                Err(TryRecvError::Disconnected) => {
                    panic!("{:?}", TryRecvError::Disconnected);
                }
            }

            if !window.render() {
              panic!("window did not render!");
            }

            for mut event in window.events().iter() {
                match event.value {
                    WindowEvent::Key(code, _, Action::Press, _) => {
                        println!("You pressed the key with code: {:?}", code);
                        println!("Do not try to press escape: the event is inhibited!");
                        event.inhibited = true; // override the default keyboard handler

                        match code {
                            Key::Left => control_tx.send(control::ControlMessage::ChangeMode(control::ChangeMode::Prev)).unwrap(),
                            Key::Right => control_tx.send(control::ControlMessage::ChangeMode(control::ChangeMode::Next)).unwrap(),
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
