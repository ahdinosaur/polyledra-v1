extern crate nalgebra as na;

use std::sync::mpsc::{channel, Sender};
use std::thread;

use color;
use control;
use shape;

#[cfg(feature = "gl")]
pub use self::gl::GlDisplay;
#[cfg(feature = "gl")]
mod gl;

#[cfg(feature = "hal")]
pub use self::hal::HalDisplay;
#[cfg(feature = "hal")]
mod hal;

pub enum DisplayMessage {
    Shape(shape::Shape),
    Pixels(color::Pixels)
}

pub fn create_display_tx(control_tx: Sender<control::Control>) -> Sender<DisplayMessage> {
    let (display_tx, display_rx) = channel::<DisplayMessage>();
    
    thread::spawn(move|| {
        #[cfg(feature = "gl")]
        let mut gl_display = GlDisplay::new(control_tx.clone());

        #[cfg(feature = "hal")]
        let mut hal_display = HalDisplay::new(control_tx.clone());

        for display_message in display_rx {
            #[cfg(feature = "gl")]
            gl_display.display(&display_message);

            #[cfg(feature = "hal")]
            hal_display.display(&display_message);
        }
    });

    return display_tx;
}


pub trait Display {
    fn new (control_tx: Sender<control::Control>) -> Self;
    fn display (&mut self, display_message: &DisplayMessage);
}
