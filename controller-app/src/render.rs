use std::thread;
use std::iter;
use std::vec;
use std::sync::mpsc::{channel, Sender};
use std::sync::mpsc;

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

pub fn create_render_tx(display_tx: Sender<display::DisplayMessage>) -> (Sender<RenderMessage>, thread::JoinHandle<()>) {
    let (render_tx, render_rx) = channel::<RenderMessage>();

    let render_handle = thread::spawn(move || {
        let mut time = 0.0;
        let shape = shape::Shape::none();
        let mut scene_manager = scene::SceneManager::new(shape);

        loop {
            let mut should_render = false;

            // block on first message
            let first_render_message = render_rx.recv().unwrap();
            let first_render_messages = vec![first_render_message];
            // unblocking read of next messages
            // (to stay up-to-date and batch renders)
            let next_render_messages: iter::Chain<vec::IntoIter<RenderMessage>, mpsc::TryIter<RenderMessage>>  = first_render_messages
                .into_iter()
                .chain(
                    render_rx.try_iter()
                );

            for render_message in next_render_messages {
                match render_message {
                    RenderMessage::Time(value) => {
                        time = value;
                        should_render = true;
                    },
                    RenderMessage::Shape(shape) => {
                        scene_manager = scene::SceneManager::new(shape.clone());
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
                    },
                    RenderMessage::ChangeMode(control::ChangeMode::Set(next_mode_index)) => {
                        scene_manager.set_mode(next_mode_index);
                        should_render = true;
                    }
                }
            }

            if should_render {
                render(&display_tx, &mut scene_manager, time);
            }
        }
    });

    (render_tx, render_handle)
}

fn render (display_tx: &Sender<display::DisplayMessage>, scene_manager: &mut scene::SceneManager, time: control::Time) {
    let pixels = scene_manager.render(time);
    let display_message = display::DisplayMessage::Pixels(pixels);
    display_tx.send(display_message).unwrap();
}

