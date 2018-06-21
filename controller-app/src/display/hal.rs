extern crate linux_embedded_hal as hal;
extern crate nalgebra as na;

use std::u64;
use std::io::Write;
use std::sync::mpsc::{Sender};
use std::thread;
use std::time::{Instant, Duration};

use hal::spidev::{self, Spidev, SpidevOptions};
use hal::sysfs_gpio::{self, Pin, Direction};

use color;
use control;
use shape;
use display::{Display, DisplayMessage};

static NEXT_BUTTON_PIN: u64 = 27;
static PREV_BUTTON_PIN: u64 = 65;

pub struct HalDisplay {
    spidev: Spidev,
    spidev_options: SpidevOptions,
    next_button_pin: Pin,
    prev_button_pin: Pin,
    next_button_press_instant: Option<Instant>,
    prev_button_press_instant: Option<Instant>,
    control_tx: Sender<control::Control>
}

impl Display for HalDisplay {
    fn new (control_tx: Sender<control::Control>) -> Self {
        let mut spidev = Spidev::open("/dev/spidev0.0").unwrap();
        let spidev_options = SpidevOptions::new()
            .bits_per_word(8)
            .max_speed_hz(8_000_000)
            .mode(spidev::SPI_MODE_0)
            .build();
        spidev.configure(&spidev_options).unwrap();

        let next_button_pin = Pin::new(NEXT_BUTTON_PIN);
        next_button_pin.set_direction(Direction::In);

        let prev_button_pin = Pin::new(PREV_BUTTON_PIN);
        prev_button_pin.set_direction(Direction::In);

        HalDisplay {
            spidev,
            spidev_options,
            next_button_pin,
            prev_button_pin,
            next_button_press_instant: None,
            prev_button_press_instant: None,
            control_tx
        }
    }

    fn display (&mut self, display_message: &DisplayMessage) {
        let control_tx = &self.control_tx;
        let spidev = &mut self.spidev;

        match display_message {
            &DisplayMessage::Pixels(ref pixels) => {
                let brightness = 10;
                let mut buffer = pixels_to_apa102_buffer(pixels, Some(brightness));
                spidev.write(&mut buffer).unwrap();
            }
            &DisplayMessage::Shape(_) => {}
        }

        /*
        if something() {
            process::exit(1);
        }
        */

        // TODO generalize
        // if next button is pushed, switch to next mode
        let next_button_value = self.next_button_pin.get_value().unwrap_or(0);
        let next_button_press_ns = self.next_button_press_instant.map_or(u64::MAX, |instant| duration_to_nanos(instant.elapsed()));
        if next_button_value == 1 && next_button_press_ns > 300_000_000 {
            control_tx.send(control::Control::ChangeMode(control::ChangeMode::Next)).unwrap();
            self.next_button_press_instant = Some(Instant::now());
        }

        // TODO generalize
        // if prev button is pushed, switch to next mode
        let prev_button_value = self.prev_button_pin.get_value().unwrap_or(0);
        let prev_button_press_ns = self.prev_button_press_instant.map_or(u64::MAX, |instant| duration_to_nanos(instant.elapsed()));
        if prev_button_value == 1 && prev_button_press_ns > 300_000_000 {
            control_tx.send(control::Control::ChangeMode(control::ChangeMode::Prev)).unwrap();
            self.prev_button_press_instant = Some(Instant::now());
        }

        // TODO get rotary encoder input as params
    }
}

fn pixels_to_apa102_buffer(pixels: &color::Pixels, brightness_option: Option<u8>) -> Vec<u8> {
    let brightness = brightness_option.unwrap_or(31); // 31 == MAX brightness
    let start_frame_length = 4;
    let num_led_frames = pixels.len();
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
        let buffer_index = start_frame_length + led_frame_length * pixel_index;

        // 0b11100000 = 0340 = 0xE0 = 224
        buffer[buffer_index] = brightness | 0xE0;
        buffer[buffer_index + 1] = (rgb.red * (0xff as f32)) as u8;
        buffer[buffer_index + 2] = (rgb.green * (0xff as f32)) as u8;
        buffer[buffer_index + 3] = (rgb.blue * (0xff as f32)) as u8;
    }

    // end frames
    for end_index in 0..num_end_frames {
        let buffer_index = start_frame_length + led_frames_length + end_index;
        buffer[buffer_index] = 0;
    }

    buffer
}

fn duration_to_nanos (duration: Duration) -> u64 {
    duration.as_secs() as u64 * 1_000_000_000 + duration.subsec_nanos() as u64
}

#[cfg(test)]
mod test {
    use display::hal::{pixels_to_apa102_buffer};
    use color::{Color, Rgb};

    #[test]
    fn red_pixel() {
        let red = Rgb { red: 1_f32, green: 0_f32, blue: 0_f32 };
        let pixels = vec![red];
        let buffer = pixels_to_apa102_buffer(&pixels, None);
        let expected = vec![
            0, 0, 0, 0, // start
            0xff, 0xff, 0, 0 // red
        ];
        assert_eq!(&buffer, &expected);
    }

    #[test]
    fn rgb_pixels() {
        let red = Rgb { red: 1_f32, green: 0_f32, blue: 0_f32 };
        let green = Rgb { red: 0_f32, green: 1_f32, blue: 0_f32 };
        let blue = Rgb { red: 0_f32, green: 0_f32, blue: 1_f32 };
        let pixels = vec![red, green, blue];
        let buffer = pixels_to_apa102_buffer(&pixels, None);
        let expected = vec![
            0, 0, 0, 0, // start
            0xff, 0xff, 0, 0, // red
            0xff, 0, 0xff, 0, // green
            0xff, 0, 0, 0xff, // blue
            0 // end
        ];
        assert_eq!(&buffer, &expected);
    }
}
