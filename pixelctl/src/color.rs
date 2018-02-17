
#[derive(Clone)]
pub struct RGB {
    pub red: f32,
    pub green: f32,
    pub blue: f32
}

#[derive(Clone)]
pub enum Color {
    RGB(RGB)
}

pub type Colors = Vec<Color>;

impl Color {
    pub fn to_rgb(&self) -> RGB {
        match *self {
            Color::RGB(ref value) => value.clone()
        }
    }
}
