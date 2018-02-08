extern crate fps_clock;

use std::thread;
use std::sync::mpsc::channel;

fn main() {
  let (clock_tx, clock_rx) = channel();
  thread::spawn(move|| {
    let mut fps = fps_clock::FpsClock::new(1);
    let mut nanosecs_since_start = 0.0;
    let mut nanosecs_since_last_tick;
    loop {
      nanosecs_since_last_tick = fps.tick();
      nanosecs_since_start += nanosecs_since_last_tick;
      clock_tx.send(nanosecs_since_start).unwrap();
    }
  });

  for time in clock_rx.iter() {
    println!("time: {}", time);
  }
}
