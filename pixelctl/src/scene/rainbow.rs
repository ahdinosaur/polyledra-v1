use scene;
use color;

static MS_PER_S: f32 = 1.0e9; // microseconds_per_second

#[derive(Debug)]
pub struct Rainbow;
impl scene::Scene for Rainbow {
    fn new () -> Self where Self:Sized {
        return Rainbow {}
    }
    fn scene<'a> (&self, input: scene::SceneInput<'a>) -> scene::SceneOutput<'a> {
        let time = input.time;
        let shape = input.shape;

        let dots = &shape.dots;

        let length = dots.len();
        let speed = (0.25_f32) / MS_PER_S;
        let start = time * speed;
        let step = 1_f32 / length as f32;

        debug!("rainbow: {} {} {} {}", time, speed, start, step);

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
