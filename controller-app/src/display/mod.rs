extern crate nalgebra as na;

use std::error;
use std::marker;
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

pub fn create_display_tx(control_tx: Sender<control::Control>) -> (Sender<DisplayMessage>, thread::JoinHandle<()>) {
    let (display_tx, display_rx) = channel::<DisplayMessage>();
    
    let display_handle = thread::spawn(move || {
        #[cfg(feature = "gl")]
        let mut gl_display = GlDisplay::new(control_tx.clone()).unwrap();

        #[cfg(feature = "hal")]
        let mut hal_display = HalDisplay::new(control_tx.clone()).unwrap();

        for display_message in display_rx {
            #[cfg(feature = "gl")]
            gl_display.display(&display_message).unwrap();

            #[cfg(feature = "hal")]
            hal_display.display(&display_message).unwrap();
        }
    });

    return (display_tx, display_handle);
}


pub trait Display {
    fn new (control_tx: Sender<control::Control>) -> Result<Self, Box<dyn error::Error>> where Self: marker::Sized;
    fn display (&mut self, display_message: &DisplayMessage) -> Result<(), Box<dyn error::Error>>;
}
