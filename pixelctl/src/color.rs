
#[derive(Clone)]
pub struct Rgb {
    pub red: f32,
    pub green: f32,
    pub blue: f32
}

#[derive(Clone)]
pub enum Color {
    Rgb(Rgb)
}

pub type Colors = Vec<Color>;

impl Color {
    pub fn to_rgb(&self) -> Rgb {
        match *self {
            Color::Rgb(ref value) => value.clone()
        }
    }
}
