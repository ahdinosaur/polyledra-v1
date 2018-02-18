use std::thread;
use std::sync::mpsc::{channel, Sender};

use control;
use display;
use scene;
use shape;

pub enum RenderMessage {
    Time(control::Time),
    Shape(shape::Shape),
    ChangeMode(control::ChangeMode),
}

/*
pub struct RenderService {
    pub tx: Sender<RenderMessge>,
    rx: Receiver<RenderMessage>,
    display_tx: Sender<display::DisplayMessage>,
    scene_manager: scene::SceneManager,
    time: f32,
    shape: shape::Shape
}
*/

pub fn create_render_tx(display_tx: Sender<display::DisplayMessage>) -> Sender<RenderMessage> {
    let (render_tx, render_rx) = channel::<RenderMessage>();

    thread::spawn(move|| {
        let mut scene_manager = scene::SceneManager::new();
        let mut time = 0.0;
        let mut shape = shape::Shape::none();

        for render_message in render_rx {
            let mut should_render = false;

            match render_message {
                RenderMessage::Time(value) => {
                    time = value;
                    should_render = true;
                },
                RenderMessage::Shape(value) => {
                    shape = value;
                    let display_message = display::DisplayMessage::Shape(shape.clone());
                    display_tx.send(display_message).unwrap();
                },
                RenderMessage::ChangeMode(control::ChangeMode::Prev) => {
                    scene_manager.prev_mode();
                    should_render = true;
                },
                RenderMessage::ChangeMode(control::ChangeMode::Next) => {
                    scene_manager.next_mode();
                    should_render = true;
                }
            }

            if should_render {
                render(&display_tx, &scene_manager, time, &shape);
            }
        }
    });
    return render_tx;
}

fn render (display_tx: &Sender<display::DisplayMessage>, scene_manager: &scene::SceneManager, time: control::Time, shape: &shape::Shape) {
    let scene_input = scene::SceneInput {
        time,
        shape: &shape
    };
    let render_output = scene_manager.render(scene_input);
    let display_message = display::DisplayMessage::Pixels(render_output);
    display_tx.send(display_message).unwrap();
}

