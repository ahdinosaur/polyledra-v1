extern crate kiss3d;
extern crate nalgebra as na;

use std::thread;
use std::sync::mpsc::{channel, Sender, Iter};
use na::{Point3};
use kiss3d::window::Window;
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

            for (index, point) in points.iter().enumerate() {
                let position = &point.position;
                let color = colors.get(index).unwrap();

                let pt = Point3::new(position.x, position.y, position.z);
                let c = Point3::new(color.red, color.green, color.blue);
                window.draw_point(&pt, &c);
            }

            if !window.render() {
              panic!("window did not render!");
            }
        }
    });
    return display_tx;
}
