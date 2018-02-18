use rayon::prelude::*;

use std::f32::consts::PI;

use scene;
use color;

#[derive(Debug)]
pub struct Rgb;
impl scene::Scene for Rgb {
    fn new () -> Self where Self:Sized {
        return Rgb {}
    }
    fn scene (&self, input: scene::SceneInput) -> scene::SceneOutput {
        let time = input.time;
        let shape = input.shape;

        let ms_per_s = 1.0e9; // microseconds_per_second

        let amp_red = ((time / ms_per_s).sin() - 1.0).abs();
        let amp_green = ((((time / ms_per_s)) + ((1.0/3.0) * (2.0 * PI))).sin() - 1.0).abs();
        let amp_blue = ((((time / ms_per_s)) + ((2.0/3.0) * (2.0 * PI))).sin() - 1.0).abs();
        debug!("time: {} {} {} {}", time, amp_red, amp_green, amp_blue);

        let dots = &shape.dots;
        let colors = dots
            .par_iter()
            .map(|dot| {
                let position = dot.position;
                return color::Color::Rgb(color::Rgb {
                    red: position.x * amp_red,
                    green: position.y * amp_green,
                    blue: position.z * amp_blue
                });
            });

        return colors.collect();
    }
}
