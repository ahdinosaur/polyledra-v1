use std::thread;
use std::sync::mpsc::{channel, Sender};

use clock;
use control;
use display;
use scene;
use shape;

pub enum RenderMessage {
    Time(clock::Time),
    Shape(shape::Shape),
    ChangeMode(control::ChangeMode),
}

pub fn create_render_tx(display_tx: Sender<display::DisplayMessage>) -> Sender<RenderMessage> {
    let (render_tx, render_rx) = channel::<RenderMessage>();

    thread::spawn(move|| {
        let mut scene_manager = scene::SceneManager::new();

        let mut time = 0.0;
        let mut shape = shape::Shape::none();

        for render_message in render_rx {
            match render_message {
                RenderMessage::Time(value) => {
                    time = value;
                    render(&display_tx, &scene_manager, time, &shape);
                },
                RenderMessage::Shape(value) => {
                    shape = value;
                    let display_message = display::DisplayMessage::Shape(shape.clone());
                    display_tx.send(display_message).unwrap();
                },
                RenderMessage::ChangeMode(control::ChangeMode::Prev) => {
                    scene_manager.prev_mode();
                    render(&display_tx, &scene_manager, time, &shape);
                },
                RenderMessage::ChangeMode(control::ChangeMode::Next) => {
                    scene_manager.next_mode();
                    render(&display_tx, &scene_manager, time, &shape);
                }
            }
        }
    });
    return render_tx;
}

fn render (display_tx: &Sender<display::DisplayMessage>, scene_manager: &scene::SceneManager, time: clock::Time, shape: &shape::Shape) {
    let render_input = scene::RenderInput {
        time,
        shape: &shape
    };
    let render_output = scene_manager.render(render_input);
    let display_message = display::DisplayMessage::Colors(render_output);
    display_tx.send(display_message).unwrap();
}

