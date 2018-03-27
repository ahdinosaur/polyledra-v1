#[cfg(feature = "gl")]
extern crate kiss3d;
extern crate nalgebra as na;

#[cfg(feature = "gl")]
use glfw::{Action, WindowEvent, Key};
#[cfg(feature = "gl")]
use kiss3d::window::Window;
#[cfg(feature = "gl")]
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
        #[cfg(feature = "gl")]
        let mut gl_display = GlDisplay::new(control_tx.clone());

        for display_message in display_rx {
            #[cfg(feature = "gl")]
            gl_display.display(&display_message);
        }
    });

    return display_tx;
}


pub trait Display {
    fn new (control_tx: Sender<control::Control>) -> Self;
    fn display (&mut self, display_message: &DisplayMessage);
}

#[cfg(feature = "gl")]
pub struct GlDisplay {
    window: Window,
    shape: shape::Shape,
    control_tx: Sender<control::Control>
}

#[cfg(feature = "gl")]
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
