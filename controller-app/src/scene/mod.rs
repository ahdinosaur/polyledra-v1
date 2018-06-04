use modulo::Mod;
use std::rc::Rc;

use color;
use control;
use shape;

pub trait Scene {
    fn new (shape: Rc<shape::Shape>) -> Self where Self: Sized;
    fn scene<'a> (&'a mut self, time: control::Time) -> color::Colors<'a>;
}

pub use self::test::Test;
mod test;

pub use self::rainbow::RainbowLine;
pub use self::rainbow::Rainbow;
mod rainbow;

pub use self::walk::Walk;
mod walk;

pub use self::spark::Spark;
mod spark;

pub use self::glow::Glow;
mod glow;

pub struct SceneManager {
    scenes: Vec<Box<Scene>>,
    current_scene_index: usize
}

impl SceneManager {
    pub fn new(shape: shape::Shape) -> SceneManager {
        let scene_shape = Rc::new(shape);
        let scenes: Vec<Box<Scene>> = vec![
            Box::new(test::Test::new(scene_shape.clone())),
            Box::new(rainbow::RainbowLine::new(scene_shape.clone())),
            Box::new(rainbow::Rainbow::new(scene_shape.clone())),
            Box::new(walk::Walk::new(scene_shape.clone())),
            Box::new(spark::Spark::new(scene_shape.clone())), // pulse?
            Box::new(glow::Glow::new(scene_shape.clone())),
            // TODO twinkle
            // TODO ripple
            // TODO orbit (turn on closest shape point)
            // TODO flame
        ];
        drop(scene_shape);
        let scene_manager = SceneManager {
            scenes,
            current_scene_index: 4 // spark
        };
        return scene_manager;
    }

    pub fn scene<'a>(&'a mut self, time: control::Time) -> color::Colors<'a> { 
        self.get_current_scene().scene(time)
    }

    pub fn render(&mut self, time: control::Time) -> color::Pixels {
        (*self.scene(time))
            .into_iter()
            .map(|color| color.to_rgb())
            .collect()
    }

    fn get_current_scene(&mut self) -> &mut Box<Scene> {
        self.scenes.get_mut(self.current_scene_index).unwrap()
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
