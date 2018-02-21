use modulo::Mod;

use color;
use control;
use shape;

pub trait Scene<'a> {
    fn new (shape: &'a shape::Shape) -> Self where Self: Sized;
    fn scene (&self, time: control::Time) -> color::Colors<'a>;
}

pub use self::test::Test;
mod test;

pub use self::rainbow::RainbowLine;
pub use self::rainbow::Rainbow;
mod rainbow;

pub struct SceneManager<'a> {
    shape: shape::Shape,
    scenes: Vec<Box<Scene<'a> + 'a>>,
    current_scene_index: usize
}

impl<'a> SceneManager<'a> {
    pub fn new(shape: shape::Shape) -> SceneManager<'a> {
        let scenes: Vec<Box<Scene>> = vec![
            Box::new(test::Test::new(&shape)),
            Box::new(rainbow::RainbowLine::new(&shape)),
            Box::new(rainbow::Rainbow::new(&shape)),
            // TODO twinkle
            // TODO ripple
            // TODO walk
            // TODO orbit (turn on closest shape point)
            // TODO flame
        ];
        let scene_manager = SceneManager {
            shape,
            scenes,
            current_scene_index: 0
        };
        return scene_manager;
    }

    pub fn scene(&self, time: control::Time) -> color::Colors<'a> { 
        self.get_current_scene()
            .scene(time)
    }

    pub fn render(&self, time: control::Time) -> color::Pixels {
        (*self.scene(time))
            .into_iter()
            .map(|color| color.to_rgb())
            .collect()
    }

    fn get_current_scene(&self) -> &Box<Scene<'a> + 'a> {
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
