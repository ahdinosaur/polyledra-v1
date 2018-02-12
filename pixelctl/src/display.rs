extern crate kiss3d;
extern crate nalgebra as na;

use std::thread;
use std::sync::mpsc::{channel, Sender, Iter};
use na::{Translation3};
use kiss3d::window::Window;
use kiss3d::scene::SceneNode;
use kiss3d::light::Light;

use shape;

pub struct DisplayMessage {
    pub pixel_shape: shape::PixelShape
}

pub fn create_display_tx() -> Sender<DisplayMessage> {
    let (display_tx, display_rx) = channel();
    thread::spawn(move|| {
        let mut window = Window::new("pixelctl");

        window.set_light(Light::StickToCamera);

        let display_iter: Iter<DisplayMessage> = display_rx.iter();
        for display_message in display_iter {
            let DisplayMessage { pixel_shape } = display_message;
            let shape::PixelShape { points, colors } = pixel_shape;

            let mut pixels: Vec<SceneNode> = Vec::with_capacity(points.len());

            for (index, point) in points.iter().enumerate() {
                let position = &point.position;
                let color = colors.get(index).unwrap();

                let mut pixel = window.add_cube(0.01, 0.01, 0.01);
                pixel.set_color(color.red, color.green, color.blue);
                let translation = Translation3::new(position.x, position.y, position.z);
                pixel.set_local_translation(translation);
            }

            if !window.render() {
              panic!("window did not render!");
            }

            for pixel in pixels.iter_mut() {
                window.remove(pixel);
            }
        }
    });
    return display_tx;
}
