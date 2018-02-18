use rayon::prelude::*;

use color;
use control;
use shape;

pub struct SceneInput<'a> {
    pub time: control::Time,
    pub shape: &'a shape::Shape
}

pub type SceneOutput = Vec<color::Color>;

pub type RenderOutput = Vec<color::Rgb>;

pub trait Scene {
    fn new () -> Self where Self: Sized;
    fn scene(&self, input: SceneInput) -> SceneOutput;
}

pub use self::rgb::Rgb;
mod rgb;

pub use self::rainbow::Rainbow;
mod rainbow;

pub struct SceneManager {
    scenes: Vec<Box<Scene>>,
    current_scene_index: usize
}

impl SceneManager {
    pub fn new() -> SceneManager {
        return SceneManager {
            scenes: vec![
                Box::new(rgb::Rgb::new()),
                Box::new(rainbow::Rainbow::new())
            ],
            current_scene_index: 0
        }
    }

    pub fn scene(&self, input: SceneInput) -> SceneOutput { 
        self.current_scene()
            .scene(input)
    }

    pub fn render(&self, input: SceneInput) -> RenderOutput {
        self.scene(input)
            .par_iter()
            .map(|color| color.to_rgb())
            .collect()
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
