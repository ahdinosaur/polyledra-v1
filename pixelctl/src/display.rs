extern crate kiss3d;
extern crate nalgebra as na;

use std::thread;
use std::sync::mpsc::{channel, Sender};
use na::{Translation3};
use kiss3d::scene::SceneNode;
use kiss3d::window::Window;
use kiss3d::light::Light;

use shape;
use color;

pub enum DisplayMessage {
    Shape(shape::Shape),
    Colors(color::Colors)
}

pub fn create_display_tx() -> Sender<DisplayMessage> {
    let (display_tx, display_rx) = channel::<DisplayMessage>();

    thread::spawn(move|| {
        let mut window = Window::new("pixelctl");

        window.set_light(Light::StickToCamera);

        let mut pixels: Vec<SceneNode> = Vec::new();

        for display_message in display_rx {
            match display_message {
                DisplayMessage::Shape(value) => {
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
                }
                DisplayMessage::Colors(value) => {
                    // update colors of existing pixels
                    let colors = value;
                    for (index, color) in colors.iter().enumerate() {
                        let rgb = color.to_rgb();
                        let mut pixel = pixels.get_mut(index).unwrap();
                        pixel.set_color(rgb.red, rgb.green, rgb.blue);
                    }
                }
            }

            if !window.render() {
              panic!("window did not render!");
            }
        }
    });
    return display_tx;
}
