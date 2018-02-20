use color;
use control;
use scene;
use shape;

static MS_PER_S: f32 = 1.0e9; // microseconds_per_second

#[derive(Debug)]
pub struct RainbowLine {
    length: usize
}
impl<'a> scene::Scene<'a> for RainbowLine {
    fn new (shape: shape::Shape) -> Self where Self:Sized {
        return RainbowLine {
            length: shape.dots.len()
        }
    }

    fn scene (&self, time: control::Time) -> color::Colors<'a> {
        let length = self.length;
        let speed = (0.25_f32) / MS_PER_S;
        let start = time * speed;
        let step = 1_f32 / length as f32;
 
        debug!("rainbow line: {} {} {} {}", time, speed, start, step);
 
        let colors = (0..length)
            .map(move |index| {
                 return color::Color::Hsl(color::Hsl {
                    hue: start + (index as f32 / length as f32),
                    saturation: 1_f32,
                    lightness: 0.5_f32
                })
            });

        return Box::new(colors);
    }
}


#[derive(Debug)]
pub struct Rainbow {
    shape: shape::Shape
}
impl<'a> scene::Scene<'a> for Rainbow {
    fn new (shape: shape::Shape) -> Self where Self:Sized {
        Rainbow {
            shape
        }
    }

    fn scene (&self, time: control::Time) -> color::Colors<'a> {
        let shape = &self.shape;

        let dots = &shape.dots;
        let bounds = &shape.bounds;

        let length = bounds.max.z - bounds.min.z;
        let speed = (0.25_f32) / MS_PER_S;
        let start = time * speed;

        debug!("rainbow: {} {} {}", length, speed, start);

        let colors = dots.iter()
            .map(move |dot| {
                let position = dot.position;

                return color::Color::Hsl(color::Hsl {
                    hue: start + (position.z as f32 / length as f32),
                    saturation: 1_f32,
                    lightness: 0.5_f32
                })
            });

        return Box::new(colors);
    }
}
