use modulo::Mod;

#[derive(Clone, Debug, PartialEq)]
pub struct Rgb {
    pub red: f32,
    pub green: f32,
    pub blue: f32
}

pub type Pixels = Vec<Rgb>;

#[derive(Clone, Debug)]
pub struct Hsl {
    pub hue: f32,
    pub saturation: f32,
    pub lightness: f32
}

#[derive(Clone)]
pub enum Color {
    Rgb(Rgb),
    Hsl(Hsl)
}

// pub type Colors = Iterator<Item=Color>;

impl Color {
    pub fn to_rgb(&self) -> Rgb {
        match *self {
            Color::Rgb(ref rgb) => rgb.clone(),
            Color::Hsl(ref hsl) => hsl_to_rgb(hsl)
        }
    }
}

// https://github.com/Ogeon/palette/blob/c5114e5864365b6dbeb458af5f990e70b7c5debb/src/rgb.rs#L221-L248
fn hsl_to_rgb (hsl: &Hsl) -> Rgb {
    let c = (1_f32 - (hsl.lightness * 2_f32 - 1_f32).abs()) * hsl.saturation;
    let h = hsl.hue.modulo(1_f32) / (1_f32 / 6_f32);
    let x = c * (1_f32 - (h % 2_f32 - 1_f32).abs());
    let m = hsl.lightness - c * 0.5_f32;

    let (red, green, blue) = if h >= 0_f32 && h < 1_f32 {
        (c, x, 0_f32)
    } else if h >= 1_f32 && h < 2_f32 {
        (x, c, 0_f32)
    } else if h >= 2_f32 && h < 3_f32 {
        (0_f32, c, x)
    } else if h >= 3_f32 && h < 4_f32 {
        (0_f32, x, c)
    } else if h >= 4_f32 && h < 5_f32 {
        (x, 0_f32, c)
    } else {
        (c, 0_f32, x)
    };

    Rgb {
        red: red + m,
        green: green + m,
        blue: blue + m
    }
}

#[cfg(test)]
mod test {
    use color::{Color, Rgb, Hsl};

    #[test]
    fn red() {
        let a = Rgb { red: 1_f32, green: 0_f32, blue: 0_f32 };
        let b = Color::Hsl(Hsl { hue: 0_f32, saturation: 1_f32, lightness: 0.5_f32 }).to_rgb();
        assert_eq!(a, b);
    }

    #[test]
    fn green() {
        let a = Rgb { red: 0_f32, green: 1_f32, blue: 0_f32 };
        let b = Color::Hsl(Hsl { hue: (1_f32/3_f32), saturation: 1_f32, lightness: 0.5_f32 }).to_rgb();
        assert_eq!(a, b);
    }

    #[test]
    fn blue() {
        let a = Rgb { red: 0_f32, green: 0_f32, blue: 1_f32 };
        let b = Color::Hsl(Hsl { hue: (2_f32/3_f32), saturation: 1_f32, lightness: 0.5_f32 }).to_rgb();
        assert_eq!(a, b);
    }

    #[test]
    fn orange() {
        let a = Rgb { red: 1_f32, green: 0.5_f32, blue: 0_f32 };
        let b = Color::Hsl(Hsl { hue: (1_f32/12_f32), saturation: 1_f32, lightness: 0.5_f32 }).to_rgb();
        assert_eq!(a, b);
    }

    #[test]
    fn yellow () {
        let a = Rgb { red: 1_f32, green: 1_f32, blue: 0_f32 };
        let b = Color::Hsl(Hsl { hue: (1_f32/6_f32), saturation: 1_f32, lightness: 0.5_f32 }).to_rgb();
        assert_eq!(a, b);
    }

    #[test]
    fn cyan() {
        let a = Rgb { red: 0.0_f32, green: 1_f32, blue: 1_f32 };
        let b = Color::Hsl(Hsl { hue: (1_f32/2_f32), saturation: 1_f32, lightness: 0.5_f32 }).to_rgb();
        assert_eq!(a, b);
    }

    /*
    #[test]
    fn purple() {
        let a = Rgb { red: 0.5_f32, green: 0_f32, blue: 0.5_f32 };
        let b = Color::Hsl(Hsl { hue: (5_f32/6_f32), saturation: 1_f32, lightness: 0.25_f32 }).to_rgb();
        assert_eq!(a, b);
    }
    */

    #[test]
    fn grey() {
        let a = Rgb { red: 0.5_f32, green: 0.5_f32, blue: 0.5_f32 };
        let b = Color::Hsl(Hsl { hue: 0_f32, saturation: 0_f32, lightness: 0.5_f32 }).to_rgb();
        assert_eq!(a, b);
    }
}
