extern crate linux_embedded_hal as hal;
extern crate nalgebra as na;

use hal::spidev::{self, Spidev, SpidevOptions};
use std::io::Write;
use std::sync::mpsc::{Sender};
use std::thread;

use color;
use control;
use shape;
use display::{Display, DisplayMessage};

pub struct HalDisplay {
    spidev: Spidev,
    spidev_options: SpidevOptions,
    control_tx: Sender<control::Control>
}

impl Display for HalDisplay {
    fn new (control_tx: Sender<control::Control>) -> Self {
        let mut spidev = Spidev::open("/dev/spidev1.0").unwrap();
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

fn pixels_to_apa102_buffer(pixels: &color::Pixels) -> Vec<u8> {
    let num_edges = 1;
    let start_frame_length = 4;
    let num_led_frames = num_edges * pixels.len();
    let led_frame_length = 4;
    let led_frames_length = num_led_frames * led_frame_length;
    let num_end_frames = ((num_led_frames - 1) as f32 / 16_f32).ceil() as usize;
    let end_frames_length = num_end_frames;

    let buffer_length = start_frame_length + led_frames_length + end_frames_length;

    let mut buffer: Vec<u8> = vec![0; buffer_length];

    // start frame
    buffer[0] = 0;
    buffer[1] = 0;
    buffer[2] = 0;
    buffer[3] = 0;

    // led frames
    for (pixel_index, rgb) in pixels.iter().enumerate() {
        for edge_index in 0..num_edges {
            let led_frame_index = pixel_index * num_edges + edge_index;
            let buffer_index = start_frame_length + led_frame_length * led_frame_index;

            // let brightness = 31 // MAX
            let brightness = 10;

            // 0b11100000 = 0340 = 0xE0 = 224
            buffer[buffer_index] = brightness | 0xE0;
            buffer[buffer_index + 1] = (rgb.red * (0xff as f32)) as u8;
            buffer[buffer_index + 2] = (rgb.green * (0xff as f32)) as u8;
            buffer[buffer_index + 3] = (rgb.blue * (0xff as f32)) as u8;
        }
    }

    // end frames
    for end_index in 0..num_end_frames {
        let buffer_index = start_frame_length + led_frames_length + end_index;
        buffer[buffer_index] = 0;
    }

    buffer
}

#[cfg(test)]
mod test {
    use display::hal::{pixels_to_apa102_buffer};
    use color::{Color, Rgb};

    #[test]
    fn red_pixel() {
        let num_edges = 1;
        let red = Rgb { red: 1_f32, green: 0_f32, blue: 0_f32 };
        let pixels = vec![red];
        let buffer = pixels_to_apa102_buffer(&pixels);
        assert_eq!(buffer.len(), (1 + num_edges) * 4 + 1);
        assert_eq!(&buffer[..4], &[0, 0, 0, 0]);
        for edge_index in 0..num_edges {
            assert_eq!(&buffer[4+edge_index*4..8+edge_index*4], &[0xff, 0xff, 0, 0]);
        }
        assert_eq!(&buffer[num_edges*4+1..num_edges*4+2], &[0]);
    }
}
