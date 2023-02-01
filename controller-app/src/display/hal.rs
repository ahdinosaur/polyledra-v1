extern crate nalgebra as na;

use std::env;
use std::error;
use std::u64;
use std::io::Write;
use std::sync::mpsc::{Sender};
use std::thread;
use std::time::{Instant, Duration};

#[macro_use] use lazy_static;
use spidev::{self, Spidev, SpidevOptions};
use sysfs_gpio::{self, Pin, Direction};

use color;
use control;
use display::{Display, DisplayMessage};
use scene;
use shape;

lazy_static! {
    static ref MODE_PIN_1: u64 = env::var("MODE_PIN_1").unwrap().parse::<u64>().unwrap();
    static ref MODE_PIN_2: u64 = env::var("MODE_PIN_2").unwrap().parse::<u64>().unwrap();
    static ref MODE_PIN_4: u64 = env::var("MODE_PIN_4").unwrap().parse::<u64>().unwrap();
    static ref MODE_PIN_8: u64 = env::var("MODE_PIN_8").unwrap().parse::<u64>().unwrap();

    static ref BRIGHTNESS_PIN_1: u64 = env::var("BRIGHTNESS_PIN_1").unwrap().parse::<u64>().unwrap();
    static ref BRIGHTNESS_PIN_2: u64 = env::var("BRIGHTNESS_PIN_2").unwrap().parse::<u64>().unwrap();
    static ref BRIGHTNESS_PIN_4: u64 = env::var("BRIGHTNESS_PIN_4").unwrap().parse::<u64>().unwrap();
    static ref BRIGHTNESS_PIN_8: u64 = env::var("BRIGHTNESS_PIN_8").unwrap().parse::<u64>().unwrap();
}

static DEFAULT_BRIGHTNESS: u8 = 10;

pub struct HalDisplay {
    spidev: Spidev,
    spidev_options: SpidevOptions,
    mode_pin_1: Pin,
    mode_pin_2: Pin,
    mode_pin_4: Pin,
    mode_pin_8: Pin,
    brightness_pin_1: Pin,
    brightness_pin_2: Pin,
    brightness_pin_4: Pin,
    brightness_pin_8: Pin,
    brightness: u8,
    current_scene_index: usize,
    control_tx: Sender<control::Control>
}

impl Display for HalDisplay {
    fn new (control_tx: Sender<control::Control>) -> Result<Self, Box<dyn error::Error>> {
        let spidev_path = env::var("SPIDEV")?;
        let mut spidev = Spidev::open(spidev_path)?;
        let spidev_options = SpidevOptions::new()
            .bits_per_word(8)
            .max_speed_hz(8_000_000)
            .mode(spidev::SPI_MODE_0)
            .build();
        spidev.configure(&spidev_options)?;

        let mode_pin_1 = Pin::new(*MODE_PIN_1);
        let mode_pin_2 = Pin::new(*MODE_PIN_2);
        let mode_pin_4 = Pin::new(*MODE_PIN_4);
        let mode_pin_8 = Pin::new(*MODE_PIN_8);
        mode_pin_1.set_direction(Direction::In)?;
        mode_pin_2.set_direction(Direction::In)?;
        mode_pin_4.set_direction(Direction::In)?;
        mode_pin_8.set_direction(Direction::In)?;

        let brightness_pin_1 = Pin::new(*BRIGHTNESS_PIN_1);
        let brightness_pin_2 = Pin::new(*BRIGHTNESS_PIN_2);
        let brightness_pin_4 = Pin::new(*BRIGHTNESS_PIN_4);
        let brightness_pin_8 = Pin::new(*BRIGHTNESS_PIN_8);
        brightness_pin_1.set_direction(Direction::In)?;
        brightness_pin_2.set_direction(Direction::In)?;
        brightness_pin_4.set_direction(Direction::In)?;
        brightness_pin_8.set_direction(Direction::In)?;

        Ok(HalDisplay {
            spidev,
            spidev_options,
            mode_pin_1,
            mode_pin_2,
            mode_pin_4,
            mode_pin_8,
            brightness_pin_1,
            brightness_pin_2,
            brightness_pin_4,
            brightness_pin_8,
            brightness: DEFAULT_BRIGHTNESS,
            current_scene_index: scene::DEFAULT_SCENE_INDEX,
            control_tx
        })
    }

    fn display (&mut self, display_message: &DisplayMessage) -> Result<(), Box<dyn error::Error>> {
        let control_tx = &self.control_tx;
        let spidev = &mut self.spidev;
        let brightness = self.brightness;

        match display_message {
            &DisplayMessage::Pixels(ref pixels) => {
                let mut buffer = pixels_to_apa102_buffer(pixels, Some(brightness));
                spidev.write(&mut buffer)?;
            }
            &DisplayMessage::Shape(_) => {}
        }

        /*
        if something() {
            process::exit(1);
        }
        */

        // mode switch

        let mode_1_value = self.mode_pin_1.get_value().unwrap_or(0);
        let mode_2_value = self.mode_pin_2.get_value().unwrap_or(0);
        let mode_4_value = self.mode_pin_4.get_value().unwrap_or(0);
        let mode_8_value = self.mode_pin_8.get_value().unwrap_or(0);
        debug!("mode_1_value: {}", mode_1_value);
        debug!("mode_2_value: {}", mode_2_value);
        debug!("mode_4_value: {}", mode_4_value);
        debug!("mode_8_value: {}", mode_8_value);

        let next_scene_index = (scene::NUM_SCENES - 1).min((mode_1_value + 2 * mode_2_value + 4 * mode_4_value + 8 * mode_8_value) as usize);
        let current_scene_index = self.current_scene_index;

        if next_scene_index != current_scene_index {
            self.current_scene_index = next_scene_index;
            control_tx.send(control::Control::ChangeMode(control::ChangeMode::Set(next_scene_index)))?;
        }

        // brightness switch

        let brightness_1_value = self.brightness_pin_1.get_value().unwrap_or(0);
        let brightness_2_value = self.brightness_pin_2.get_value().unwrap_or(0);
        let brightness_4_value = self.brightness_pin_4.get_value().unwrap_or(0);
        let brightness_8_value = self.brightness_pin_8.get_value().unwrap_or(0);
        debug!("brightness_1_value: {}", brightness_1_value);
        debug!("brightness_2_value: {}", brightness_2_value);
        debug!("brightness_4_value: {}", brightness_4_value);
        debug!("brightness_8_value: {}", brightness_8_value);

        let next_brightness = 1 + ((brightness_1_value + 2 * brightness_2_value + 4 * brightness_4_value + 8 * brightness_8_value) * 2);
        self.brightness = next_brightness;

        Ok(())
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
