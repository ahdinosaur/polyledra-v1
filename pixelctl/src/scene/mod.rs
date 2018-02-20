use color;
use control;
use shape;

pub struct SceneInput<'a> {
    pub time: control::Time,
    pub shape: &'a shape::Shape
}

pub type SceneOutput<'a> = Box<Iterator<Item=color::Color> + 'a>;

pub type RenderOutput = Vec<color::Rgb>;

pub trait Scene {
    fn new () -> Self where Self: Sized;
    fn scene<'a> (&self, input: SceneInput<'a>) -> SceneOutput<'a>;
}

pub use self::test::Test;
mod test;

pub use self::rgb::Rgb;
mod rgb;

pub use self::rainbow::RainbowLine;
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
                Box::new(test::Test::new()),
                Box::new(rgb::Rgb::new()),
                Box::new(rainbow::RainbowLine::new()),
                Box::new(rainbow::Rainbow::new()),
                // TODO twinkle
                // TODO ripple
                // TODO walk
                // TODO orbit (turn on closest shape point)
                // TODO flame
            ],
            current_scene_index: 0
        }
    }

    pub fn scene<'a>(&self, input: SceneInput<'a>) -> SceneOutput<'a> { 
        self.get_current_scene()
            .scene(input)
    }

    pub fn render<'a>(&self, input: SceneInput<'a>) -> RenderOutput {
        (*self.scene(input))
            .into_iter()
            .map(|color| color.to_rgb())
            .collect()
    }

    fn get_current_scene(&self) -> &Box<Scene> {
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
