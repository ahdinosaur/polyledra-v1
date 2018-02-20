use scene;
use color;

#[derive(Debug)]
pub struct Walk;
impl scene::Scene for Walk {
    fn new () -> Self where Self:Sized {
        return Walk {
            prev_dot
        }
    }
    fn scene<'a> (&self, input: scene::SceneInput<'a>) -> scene::SceneOutput<'a> {
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

        return Box::new(colors);
    }
}
