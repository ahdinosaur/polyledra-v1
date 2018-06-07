use std::rc::Rc;
use std::f32::consts::PI;
use na::{distance};
use ezing::{quad_out};

use color;
use control;
use scene;
use shape;

static NANOSEC_PER_SEC: f32 = 1.0e9; // nanoseconds_per_second
static SEC_PER_MIN: f32 = 60.;

static BEATS_PER_MINUTE: f32 = 60.;

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
        let bounds = &shape.bounds;

        let frequency = BEATS_PER_MINUTE / SEC_PER_MIN / NANOSEC_PER_SEC;
        let spark_time = time * frequency;

        let hue_start = spark_time / 2_f32;
        let spark_length = quad_out((spark_time * 2. * PI).sin() / 2. + 0.5);
        let half_spark_length = spark_length / 2_f32;

        debug!("spark: {} {}", spark_time, spark_length);

        let colors = dots.iter()
            .map(move |dot| {
                let position = dot.position;
                let edge_id = dot.edge_id;
                let edge_length = shape.abstract_shape.edge_length(edge_id);
                let edge_source = shape.abstract_shape.edge_source(edge_id);
                let spark_index = distance(edge_source, &dot.position) / edge_length;
                let hue = hue_start + spark_index;
                let is_dot_active = (spark_index < half_spark_length) || (spark_index > (edge_length - half_spark_length));
                let lightness = if is_dot_active { 0.5_f32 } else { 0_f32 };

                return color::Color::Hsl(color::Hsl {
                    hue,
                    saturation: 1_f32,
                    lightness
                })
            });

        return Box::new(colors);
    }
}
