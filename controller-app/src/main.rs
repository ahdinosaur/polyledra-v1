extern crate clap_log_flag;
extern crate clap_verbosity_flag;
extern crate ezing;
#[cfg(feature = "gl")] extern crate glfw;
#[cfg(feature = "gl")] extern crate kiss3d;
#[macro_use] extern crate lazy_static;
#[macro_use] extern crate log;
extern crate modulo;
extern crate nalgebra as na;
extern crate noise;
extern crate panic_monitor;
extern crate rand;
#[cfg(feature = "hal")] extern crate spidev;
#[macro_use] extern crate structopt;
#[cfg(feature = "hal")] extern crate sysfs_gpio;

use std::env;
use std::error;
use std::thread;
use structopt::StructOpt;
use panic_monitor::PanicMonitor;

mod color;
mod control;
mod display;
mod render;
mod scene;
mod shape;
use shape::AbstractShapeCreator;
mod util;

lazy_static! {
    static ref PANIC_MONITOR: PanicMonitor = PanicMonitor::new();
}

#[derive(Debug, StructOpt)]
struct CliOptions {
    #[structopt(flatten)]
    verbose: clap_verbosity_flag::Verbosity,
    #[structopt(flatten)]
    log: clap_log_flag::Log,
}

fn main() -> Result<(), Box<dyn error::Error>> {
    PANIC_MONITOR.init();

    let args = CliOptions::from_args();

    args.log.log_all(Some(args.verbose.log_level())).unwrap();

    let edge_length = env::var("EDGE_LENGTH").unwrap().parse::<f32>().unwrap();
    let pixel_density = env::var("PIXEL_DENSITY").unwrap().parse::<f32>().unwrap();
    let num_arms = env::var("NUM_ARMS").unwrap().parse::<usize>().unwrap();
    let fps = env::var("FPS").unwrap().parse::<u32>().unwrap();

    let abstract_shape = shape::Tetrahedron::new(edge_length);
    let shape = shape::Shape::new(shape::ShapeOptions {
        abstract_shape,
        pixel_density,
        num_arms
    });

    let (control_tx, control_rx) = control::create_control_channel();

    let clock_handle = control::connect_clock(fps, control_tx.clone());

    let (display_tx, display_handle) = display::create_display_tx(control_tx.clone());
    let (render_tx, render_handle) = render::create_render_tx(display_tx);

    let render_shape = render::RenderMessage::Shape(shape);
    render_tx.send(render_shape)?;
    
    let control_handle = thread::spawn(move || {
        for control_message in control_rx {
            let mut render_message;
            match control_message {
                control::Control::Time(value) => {
                    render_message = render::RenderMessage::Time(value);
                },
                control::Control::ChangeMode(value) => {
                    render_message = render::RenderMessage::ChangeMode(value);
                }
            }
            render_tx.send(render_message).unwrap();
        }
    });

    let panic_threads = PANIC_MONITOR.wait(&[
        clock_handle.thread().id(),
        display_handle.thread().id(),
        render_handle.thread().id(),
        control_handle.thread().id(),
    ]);

    let panic_thread_ids: Vec<thread::ThreadId> = panic_threads.iter()
        .map(|thread| thread.id())
        .collect();

    if panic_thread_ids.contains(&clock_handle.thread().id()) {
        let clock_thread_err = clock_handle.join().unwrap_err();
        error!("clock thread panic! {:?}", clock_thread_err)
    }
    if panic_thread_ids.contains(&display_handle.thread().id()) {
        let display_thread_err = display_handle.join().unwrap_err();
        error!("display thread panic! {:?}", display_thread_err)
    }
    if panic_thread_ids.contains(&render_handle.thread().id()) {
        let render_thread_err = render_handle.join().unwrap_err();
        error!("render thread panic! {:?}", render_thread_err)
    }
    if panic_thread_ids.contains(&control_handle.thread().id()) {
        let control_thread_err = control_handle.join().unwrap_err();
        error!("control thread panic! {:?}", control_thread_err)
    }

    Ok(())
}

/*
struct LedStrip {
    pub controller: LedController,
    pub leds: Vec<RGB>,
    pub brightness: f32,
    pub temperature: ColorTemperature,
    pub correction: ColorCorrection,
    pub dither: DitherMode,
    pub maxPowerInMilliWatts: i32
}
*/
