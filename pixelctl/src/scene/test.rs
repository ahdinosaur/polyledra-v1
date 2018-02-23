use color;
use control;
use scene;
use shape;

#[derive(Debug)]
pub struct Test {
    length: usize
}

impl scene::Scene for Test {
    fn new (shape: shape::Shape) -> Self where Self:Sized {
        Test {
            length: shape.dots.len()
        }
    }

    fn scene<'a> (&'a self, _time: control::Time) -> color::Colors<'a> {
        let colors = (0..self.length)
            .map(|_index| {
                return color::Color::Rgb(color::Rgb {
                    red: 1_f32,
                    green: 1_f32,
                    blue: 1_f32
                });
            });

        return Box::new(colors);
    }
}
