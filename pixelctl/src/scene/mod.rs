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

pub struct SceneManager {
    scenes: Vec<Box<Scene>>,
    current_scene_index: usize
}

impl SceneManager {
    pub fn new() -> SceneManager {
        return SceneManager {
            scenes: vec![
                Box::new(rgb::Rgb::new())
            ],
            current_scene_index: 0
        }
    }

    pub fn render(&self, input: RenderInput) -> RenderOutput {
        let current_scene = self.scenes.get(self.current_scene_index).unwrap();
        return current_scene.render(input);
    }
}
