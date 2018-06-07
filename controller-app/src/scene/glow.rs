use noise::{NoiseFn, Point4};

use std::rc::Rc;
use std::f32::consts::PI;

use color;
use control;
use scene;
use shape;

static NANOSEC_PER_SEC: f32 = 1.0e9; // nanoseconds_per_second
static SEC_PER_MIN: f32 = 60.;

static BEATS_PER_MINUTE: f32 = 120.;
static BEATS_PER_BAR: f32 = 4.;

#[derive(Debug)]
pub struct Glow<Noise: NoiseFn<Point4<f64>>> {
    shape: Rc<shape::Shape>,
    noise: Noise,
}
impl<Noise: Default + NoiseFn<Point4<f64>>> scene::Scene for Glow<Noise> {
    fn new (shape: Rc<shape::Shape>) -> Self where Self:Sized {
        Glow {
            shape,
            noise: Noise::default()
        }
    }

    fn scene<'a> (&'a mut self, time: control::Time) -> color::Colors<'a> {
        let shape = &self.shape;
        let noise = &self.noise;

        let dots = &shape.dots;
        let bounds = &shape.bounds;

        let frequency = BEATS_PER_MINUTE / SEC_PER_MIN / NANOSEC_PER_SEC;
        let glow_time = 0.5 * (time * frequency / BEATS_PER_BAR) + ((1./2.) * time * frequency * 2. * PI).sin();

        debug!("glow: {}", glow_time);

        // 4-dimensional noise, increase w

        let colors = dots.iter()
            .map(move |dot| {
                let scalar = 0.5;
                let position = dot.position;
                let hue = noise.get([
                    scalar * position.x as f64,
                    scalar * position.y as f64,
                    scalar * position.z as f64,
                    glow_time as f64
                ]);

                return color::Color::Hsl(color::Hsl {
                    hue: hue as f32,
                    saturation: 1.,
                    lightness: 0.5,
                })
            });

        return Box::new(colors);
    }
}
