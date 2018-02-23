use modulo::Mod;

use color;
use control;
use shape;

pub trait Scene {
    fn new (shape: shape::Shape) -> Self where Self: Sized;
    fn scene<'a> (&'a self, time: control::Time) -> color::Colors<'a>;
}

pub use self::test::Test;
mod test;

pub use self::rainbow::RainbowLine;
pub use self::rainbow::Rainbow;
mod rainbow;

pub struct SceneManager {
    scenes: Vec<Box<Scene>>,
    current_scene_index: usize
}

impl SceneManager {
    pub fn new(shape: shape::Shape) -> SceneManager {
        let scenes: Vec<Box<Scene>> = vec![
            Box::new(test::Test::new(shape.clone())),
            Box::new(rainbow::RainbowLine::new(shape.clone())),
            Box::new(rainbow::Rainbow::new(shape.clone())),
            // TODO twinkle
            // TODO ripple
            // TODO walk
            // TODO orbit (turn on closest shape point)
            // TODO flame
        ];
        let scene_manager = SceneManager {
            scenes,
            current_scene_index: 0
        };
        return scene_manager;
    }

    pub fn scene<'a>(&'a self, time: control::Time) -> color::Colors<'a> { 
        self.get_current_scene()
            .scene(time)
    }

    pub fn render(&self, time: control::Time) -> color::Pixels {
        (*self.scene(time))
            .into_iter()
            .map(|color| color.to_rgb())
            .collect()
    }

    fn get_current_scene(&self) -> &Box<Scene> {
        return self.scenes.get(self.current_scene_index).unwrap();
    }

    pub fn prev_mode(&mut self) {
        self.current_scene_index = (self.current_scene_index as i8 - 1 as i8).modulo(self.scenes.len() as i8) as usize;
        info!("current scene index: {}", self.current_scene_index);
    }

    pub fn next_mode(&mut self) {
        self.current_scene_index = (self.current_scene_index as i8 + 1 as i8).modulo(self.scenes.len() as i8) as usize;
        info!("current scene index: {}", self.current_scene_index);
    }
}
