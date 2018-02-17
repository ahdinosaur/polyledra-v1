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
        return self.current_scene().render(input);
    }

    fn current_scene(&self) -> &Box<Scene> {
        return self.scenes.get(self.current_scene_index).unwrap();
    }

    pub fn prev_mode(&mut self) {
        self.current_scene_index =
            if self.current_scene_index == 0
            { self.scenes.len() - 1 }
            else { self.current_scene_index - 1 };
        info!("current scene index: {}", self.current_scene_index);
    }

    pub fn next_mode(&mut self) {
        self.current_scene_index =
            if self.current_scene_index == self.scenes.len() - 1
            { 0 }
            else { self.current_scene_index + 1 };
        info!("current scene index: {}", self.current_scene_index);
    }
}
