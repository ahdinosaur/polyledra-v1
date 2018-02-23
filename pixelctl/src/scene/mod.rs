use color;
use control;
use shape;

pub trait Scene {
    fn new<'a> (shape: &'a shape::Shape) -> Self where Self: Sized;
    fn reset<'a> (&mut self, shape: &'a shape::Shape);
    fn scene<'a> (&self, shape: &'a shape::Shape, time: control::Time) -> color::Colors<'a>;
}

pub use self::test::Test;
mod test;

/*
pub use self::rainbow::RainbowLine;
pub use self::rainbow::Rainbow;
mod rainbow;
*/

pub struct SceneManager {
    scenes: Vec<Box<Scene>>,
    current_scene_index: usize
}

impl SceneManager {
    pub fn new<'a>(shape: &'a shape::Shape) -> SceneManager {
        return SceneManager {
            scenes: vec![
                Box::new(test::Test::new(shape)),
                // Box::new(rainbow::RainbowLine::new()),
                // Box::new(rainbow::Rainbow::new()),
                // TODO twinkle
                // TODO ripple
                // TODO walk
                // TODO orbit (turn on closest shape point)
                // TODO flame
            ],
            current_scene_index: 0
        }
    }

    pub fn scene<'a>(&self, shape: &'a shape::Shape, time: control::Time) -> color::Colors<'a> {
        self.get_current_scene()
            .scene(shape, time)
    }

    pub fn render<'a>(&self, shape: &'a shape::Shape, time: control::Time) -> color::Pixels {
        (*self.scene(shape, time))
            .into_iter()
            .map(|color| color.to_rgb())
            .collect()
    }

    fn get_current_scene(&self) -> &Box<Scene> {
        return self.scenes.get(self.current_scene_index).unwrap();
    }

    pub fn reset (&self, shape: &shape::Shape) {
        self.scenes.iter()
            .for_each(|scene| {
                scene.reset(shape);
            });
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
