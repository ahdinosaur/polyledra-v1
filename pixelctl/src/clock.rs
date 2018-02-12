extern crate fps_clock;

use std::thread;
use std::sync::mpsc::{channel, Receiver};

pub type Time = f32;

pub struct ClockMessage {
    pub time: Time
}

pub fn create_clock_rx(fps: u32) -> Receiver<ClockMessage> {
    let (clock_tx, clock_rx) = channel();
    thread::spawn(move|| {
        let mut fps_clock = fps_clock::FpsClock::new(fps);
        let mut nanosecs_since_start = 0.0;
        let mut nanosecs_since_last_tick;
        loop {
            nanosecs_since_last_tick = fps_clock.tick();
            nanosecs_since_start += nanosecs_since_last_tick;
            let clock_message = ClockMessage { time: nanosecs_since_start };
            clock_tx.send(clock_message).unwrap();
        }
    });
    return clock_rx;
}

