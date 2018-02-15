pub trait Color {
    fn to_rgb(&self) -> RGB;
}

#[derive(Clone)]
pub struct RGB {
    pub red: f32,
    pub green: f32,
    pub blue: f32
}

impl Color for RGB {
    fn to_rgb(&self) -> RGB {
        return self.clone();
    }
}
