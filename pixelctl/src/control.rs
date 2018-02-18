extern crate fps_clock;

use std::thread;
use std::sync::mpsc::{channel, Sender, Receiver};

pub type Time = f32;

pub enum ChangeMode {
    Prev,
    Next
}

pub enum Control {
    Time(Time),
    ChangeMode(ChangeMode)
}

pub fn create_control_channel() -> (Sender<Control>, Receiver<Control>) {
    return channel();
}

pub fn connect_clock(fps: u32, control_tx: Sender<Control>) {
    thread::spawn(move|| {
        let mut fps_clock = fps_clock::FpsClock::new(fps);
        let mut nanosecs_since_start = 0.0;
        let mut nanosecs_since_last_tick;
        loop {
            nanosecs_since_last_tick = fps_clock.tick();
            nanosecs_since_start += nanosecs_since_last_tick;
            let clock_time = Control::Time(nanosecs_since_start);
            control_tx.send(clock_time).unwrap();
        }
    });
}



