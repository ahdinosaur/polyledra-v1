use clock;
use color;
use shape;

pub struct RenderInput<'a> {
    pub time: clock::Time,
    pub shape: &'a shape::Shape
}

pub type RenderOutput = color::Colors;

pub trait Scene {
    fn new () -> Self where Self: Sized;
    fn render(&self, input: RenderInput) -> RenderOutput;
}

pub use self::rgb::Rgb;
mod rgb;

pub enum SceneId {
    Rgb
}

pub struct SceneManager {
    current_scene_id: SceneId,
    rgb: rgb::Rgb
}

impl SceneManager {
    pub fn new() -> SceneManager {
        let current_scene_id = SceneId::Rgb;
        let rgb = rgb::Rgb::new();

        return SceneManager {
            current_scene_id,
            rgb
        }
    }
    pub fn render(&self, input: RenderInput) -> RenderOutput {
        let current_scene;
        match self.current_scene_id {
            SceneId::Rgb => {
                current_scene = &self.rgb;
            }
        }
        return current_scene.render(input);
    }
}
