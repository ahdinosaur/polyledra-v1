use modulo::Mod;
use na::{distance};

use std::rc::Rc;

use color;
use control;
use scene;
use shape;

static MS_PER_S: f32 = 1.0e9; // microseconds_per_second

#[derive(Debug)]
pub struct Spark {
    shape: Rc<shape::Shape>
}
impl scene::Scene for Spark {
    fn new (shape: Rc<shape::Shape>) -> Self where Self:Sized {
        Spark {
            shape
        }
    }

    fn scene<'a> (&'a mut self, time: control::Time) -> color::Colors<'a> {
        let shape = &self.shape;

        let dots = &shape.dots;

        let speed = (0.25_f32) / MS_PER_S;
        let frame = time * speed;

        debug!("spark: {} {}", speed, frame);

        let colors = dots.iter()
            .map(move |dot| {
                let position = dot.position;
                let edge_id = dot.edge_id;
                let edge_length = shape.abstract_shape.edge_length(edge_id);
                let edge_source = shape.abstract_shape.edge_source(edge_id);
                let index = distance(edge_source, &dot.position).modulo(edge_length) / edge_length;

                return color::Color::Hsl(color::Hsl {
                    hue: index,
                    saturation: 1_f32,
                    lightness: 0.5_f32
                })
            });

        return Box::new(colors);
    }
}
