use rayon::prelude::*;

use std::f32::consts::PI;

use scene;
use color;

#[derive(Debug)]
pub struct Test;
impl scene::Scene for Test {
    fn new () -> Self where Self:Sized {
        return Test {}
    }
    fn scene (&self, input: scene::SceneInput) -> scene::SceneOutput {
        let time = input.time;
        let shape = input.shape;

        let dots = &shape.dots;
        let length = dots.len();
        let colors = (0..length)
            .map(|_index| {
                return color::Color::Rgb(color::Rgb {
                    red: 1_f32,
                    green: 1_f32,
                    blue: 1_f32
                });
            });

        return colors.collect();
    }
}
