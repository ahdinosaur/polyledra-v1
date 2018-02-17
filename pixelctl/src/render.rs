use std::thread;
use std::sync::mpsc::{channel, Sender};

use clock;
use display;
use scene;
use scene::Scene;
use shape;

pub enum RenderMessage {
    Time(clock::Time),
    Shape(shape::Shape)
}

pub fn create_render_tx() -> Sender<RenderMessage> {
    let display_tx = display::create_display_tx();

    let (render_tx, render_rx) = channel::<RenderMessage>();
    thread::spawn(move|| {
        let mut shape = shape::Shape::none();
        let scene = scene::Rgb::new();

        for render_message in render_rx {
            let display_message;

            match render_message {
                RenderMessage::Time(value) => {
                    let time = value;
                    let render_input = scene::RenderInput {
                        time,
                        shape: &shape
                    };
                    let render_output = scene.render(render_input);
                    display_message = display::DisplayMessage::Colors(render_output);
                },
                RenderMessage::Shape(value) => {
                    shape = value;

                    display_message = display::DisplayMessage::Shape(shape.clone());
                }
            }

            display_tx.send(display_message).unwrap();
        }
    });
    return render_tx;
}
