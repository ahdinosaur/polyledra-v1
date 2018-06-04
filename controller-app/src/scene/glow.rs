use noise::{NoiseFn, OpenSimplex, Fbm};
use ezing::{cubic_in};

use std::rc::Rc;

use color;
use control;
use scene;
use shape;

static NS_PER_S: f32 = 1.0e9; // nanoseconds_per_second

#[derive(Debug)]
pub struct Glow {
    shape: Rc<shape::Shape>,
    simplex: OpenSimplex,
    motion: Fbm
}
impl scene::Scene for Glow {
    fn new (shape: Rc<shape::Shape>) -> Self where Self:Sized {
        Glow {
            shape,
            simplex: OpenSimplex::new(),
            motion: Fbm::new(),
        }
    }

    fn scene<'a> (&'a mut self, time: control::Time) -> color::Colors<'a> {
        let shape = &self.shape;
        let simplex = &self.simplex;
        let motion = &self.motion;

        let dots = &shape.dots;
        let bounds = &shape.bounds;

        let speed = (1.5) / NS_PER_S;
        let glow_time = time * speed / 2_f32;
        let glow_cycle = (glow_time.sin() + 1_f32) / 2_f32;

        debug!("glow: {} {}", glow_time, glow_cycle);

        let colors = dots.iter()
            .map(move |dot| {
                let position = dot.position;
                let hue = simplex.get([
                    glow_time as f64 + position.x as f64,
                    position.y as f64,
                    position.z as f64,
                ]);

                let edge_id = dot.edge_id;
                let dot_index = dot.dot_index;
                let arm_index = dot.arm_index;
                let light_noise = (
                    motion.get([
                        edge_id as f64 + glow_time as f64,
                        0.01 * dot_index as f64 + glow_time as f64,
                    ]) as f32
                ) + 1. / 2.;
                // let lightness = (light_noise / 2.) + (glow_cycle / 4.) + 0.4;
                let lightness = light_noise;
                debug!("glow light noise: {} {}", light_noise, lightness);

                return color::Color::Hsl(color::Hsl {
                    hue: hue as f32,
                    saturation: 1_f32,
                    lightness: cubic_in(lightness as f32)
                })
            });

        return Box::new(colors);
    }
}

fn mapf (x: f32, in_min: f32, in_max: f32, out_min: f32, out_max: f32) -> f32 {
  (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
}

fn mapl (x: f32, in_min: f32, in_max: f32, out_min: f32, out_max: f32) -> f32 {
  let min = out_min.log(2.);
  let max = out_max.log(2.);

  let scale = (max - min) / (in_max - in_min);

  (min + scale * (x - in_min)).exp()
}
