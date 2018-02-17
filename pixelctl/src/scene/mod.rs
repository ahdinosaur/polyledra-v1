use clock;
use color;
use shape;

pub struct RenderInput<'a> {
    pub time: clock::Time,
    pub shape: &'a shape::Shape
}

pub type RenderOutput = color::Colors;

pub trait Scene {
    fn new () -> Self;
    fn render(&self, input: RenderInput) -> RenderOutput;
}

pub use self::rgb::Rgb;
mod rgb;
