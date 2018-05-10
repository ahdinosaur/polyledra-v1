#[cfg(feature = "gl")]
extern crate kiss3d;
#[cfg(feature = "hal")]
extern crate linux_embedded_hal as hal;
extern crate nalgebra as na;

#[cfg(feature = "gl")]
use glfw::{Action, WindowEvent, Key};
#[cfg(feature = "gl")]
use kiss3d::window::Window;
#[cfg(feature = "gl")]
use kiss3d::light::Light;
#[cfg(feature = "hal")]
use hal::spidev::{self, Spidev, SpidevOptions};
#[cfg(feature = "hal")]
use std::io::Write;

#[cfg(feature = "gl")]
use na::{Point3};
#[cfg(feature = "gl")]
use std::process;
use std::sync::mpsc::{channel, Sender};
use std::thread;

use color;
use control;
use shape;

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

#[cfg(feature = "gl")]
pub struct GlDisplay {
    window: Window,
    shape: shape::Shape,
    control_tx: Sender<control::Control>
}

#[cfg(feature = "gl")]
impl Display for GlDisplay {
    fn new (control_tx: Sender<control::Control>) -> Self {
        let mut window = Window::new("pixelctl");
        let shape = shape::Shape::none();

        window.set_light(Light::StickToCamera);

        GlDisplay {
            window: window,
            shape: shape,
            control_tx: control_tx
        }
    }

    fn display (&mut self, display_message: &DisplayMessage) {
        let control_tx = &self.control_tx;
        let window = &mut self.window;

        match display_message {
            &DisplayMessage::Shape(ref shape) => {
                self.shape = shape.clone();
            },
            &DisplayMessage::Pixels(ref pixels) => {
                let shape = &self.shape;
                for (index, rgb) in pixels.iter().enumerate() {
                    let dot = shape.dots.get(index).unwrap();
                    let position = dot.position;
                    let color = Point3::new(rgb.red, rgb.green, rgb.blue);
                    window.draw_point(&position, &color);
                }
            }
        }

        if !window.render() {
            process::exit(1);
        }

        for mut event in window.events().iter() {
            match event.value {
                WindowEvent::Key(code, _, Action::Press, _) => {
                    println!("You pressed the key with code: {:?}", code);
                    event.inhibited = true; // override the default keyboard handler

                    match code {
                        Key::Left => control_tx.send(control::Control::ChangeMode(control::ChangeMode::Prev)).unwrap(),
                        Key::Right => control_tx.send(control::Control::ChangeMode(control::ChangeMode::Next)).unwrap(),
                        _ => {}
                    }
                },
                _ => {}
            }
        }
    }
}

#[cfg(feature = "hal")]
pub struct HalDisplay {
    spidev: Spidev,
    spidev_options: SpidevOptions,
    control_tx: Sender<control::Control>
}

#[cfg(feature = "hal")]
impl Display for HalDisplay {
    fn new (control_tx: Sender<control::Control>) -> Self {
        let mut spidev = Spidev::open("/dev/spidev0.0").unwrap();
        let spidev_options = SpidevOptions::new()
            .bits_per_word(8)
            .max_speed_hz(8_000_000)
            .mode(spidev::SPI_MODE_0)
            .build();
        spidev.configure(&spidev_options).unwrap();

        HalDisplay {
            spidev: spidev,
            spidev_options: spidev_options,
            control_tx: control_tx
        }
    }

    fn display (&mut self, display_message: &DisplayMessage) {
        let control_tx = &self.control_tx;
        let spidev = &mut self.spidev;

        match display_message {
            &DisplayMessage::Pixels(ref pixels) => {
                let mut buffer = pixels_to_apa102_buffer(pixels);
                spidev.write(&mut buffer);
            }
            &DisplayMessage::Shape(_) => {}
        }

        /*
        if something() {
            process::exit(1);
        }
        */

        // TODO get sensor inputs
    }
}


#[cfg(feature = "hal")]
fn pixels_to_apa102_buffer(pixels: &color::Pixels) -> Vec<u8> {
    let num_edges = 3;
    let start_frame_length = 4;
    let num_led_frames = num_edges * pixels.len();
    let led_frame_length = 4;
    let led_frames_length = num_led_frames * led_frame_length;
    let num_end_frames = ((num_led_frames - 1) as f32 / 16_f32).ceil() as usize;
    let end_frames_length = num_end_frames;

    let buffer_length = start_frame_length + led_frames_length + end_frames_length;

    let mut buffer: Vec<u8> = Vec::with_capacity(buffer_length);
    // let mut buffer: [u8; buffer_length];

    // start frame
    buffer[0] = 0;
    buffer[1] = 0;
    buffer[2] = 0;
    buffer[3] = 0;

    // led frames
    for (pixel_index, rgb) in pixels.iter().enumerate() {
        for edge_index in 0..num_edges {
            let led_frame_index = pixel_index * num_edges;
            let buffer_index = start_frame_length + led_frame_length * led_frame_index;

            buffer[buffer_index] = 0xff;
            buffer[buffer_index + 1] = (rgb.blue * (0xff as f32)) as u8;
            buffer[buffer_index + 2] = (rgb.green * (0xff as f32)) as u8;
            buffer[buffer_index + 3] = (rgb.red * (0xff as f32)) as u8;
        }
    }

    // end frames
    for end_index in 0..num_end_frames {
        let buffer_index = start_frame_length + led_frames_length + end_index;
        buffer[buffer_index] = 0;
    }

    buffer
}
