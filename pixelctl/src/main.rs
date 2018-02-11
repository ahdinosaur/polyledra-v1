extern crate fps_clock;
extern crate kiss3d;
extern crate nalgebra as na;

use std::f32;
use std::thread;
use std::sync::mpsc::{channel, Sender, Receiver, Iter};
use na::{Translation3};
use kiss3d::window::Window;
use kiss3d::light::Light;

type Time = f32;

struct ClockMessage {
    pub time: Time
}

fn create_clock_rx(fps: u32) -> Receiver<ClockMessage> {
    let (clock_tx, clock_rx) = channel();
    thread::spawn(move|| {
        let mut fps = fps_clock::FpsClock::new(fps);
        let mut nanosecs_since_start = 0.0;
        let mut nanosecs_since_last_tick;
        loop {
            nanosecs_since_last_tick = fps.tick();
            nanosecs_since_start += nanosecs_since_last_tick;
            let clock_message = ClockMessage { time: nanosecs_since_start };
            clock_tx.send(clock_message).unwrap();
        }
    });
    return clock_rx;
}

struct RenderMessage {
    pub time: Time,
    pub point_shape: PointShape
}

fn create_render_tx() -> Sender<RenderMessage> {
    let display_tx = create_display_tx();

    let (render_tx, render_rx) = channel();
    thread::spawn(move|| {
        let render_iter: Iter<RenderMessage> = render_rx.iter();
        for render_message in render_iter {
            let point_shape = render_message.point_shape;
            let points = point_shape.points;
            let colors = points.iter().map(|_point| {
                return RGB { red: 0.0, green: 1.0, blue: 0.0 };
            }).collect();
            let pixel_shape = PixelShape {
                points: points,
                colors: colors
            };
            let display_message = DisplayMessage {
                pixel_shape: pixel_shape
            };
            display_tx.send(display_message).unwrap();
        }
    });
    return render_tx;
}

struct DisplayMessage {
    pub pixel_shape: PixelShape
}

fn create_display_tx() -> Sender<DisplayMessage> {
    let (display_tx, display_rx) = channel();
    thread::spawn(move|| {
        let mut window = Window::new("pixelctl");

        window.set_light(Light::StickToCamera);

        let display_iter: Iter<DisplayMessage> = display_rx.iter();
        for display_message in display_iter {
            let DisplayMessage { pixel_shape } = display_message;
            let PixelShape { points, colors } = pixel_shape;

            for (index, point) in points.iter().enumerate() {
                let position = &point.position;
                let color = colors.get(index).unwrap();

                let mut pixel = window.add_cube(0.01, 0.01, 0.01);
                pixel.set_color(color.red, color.green, color.blue);
                let translation = Translation3::new(position.x, position.y, position.z);
                pixel.set_local_translation(translation);
            }

            if !window.render() {
              panic!("window did not render!");
            }
        }
    });
    return display_tx;
}

// https://en.wikipedia.org/wiki/Tetrahedron#Formulas_for_a_regular_tetrahedron
fn create_tetrahedron (length: f32) -> AbstractShape {
    let a = length / (8_f32/3_f32).sqrt();

    return AbstractShape {
        vertices: vec![
            Position { x: 0_f32, y: 0_f32, z: a },
            Position { x: (8_f32/9_f32).sqrt() * a, y: 0_f32, z: -(1_f32/3_f32) * a },
            Position { x: -(2_f32/9_f32).sqrt() * a, y: (2_f32/3_f32).sqrt() * a, z: -(1_f32/3_f32) * a },
            Position { x: -(2_f32/9_f32).sqrt() * a, y: -(2_f32/3_f32).sqrt() * a, z: -(1_f32/3_f32) * a }
        ],
        edges: vec![
            (0, 1),
            (0, 2),
            (0, 3),
            (1, 2),
            (2, 3),
            (3, 1)
        ]
    };
}

fn main() {
    let clock_rx = create_clock_rx(60);
    let render_tx = create_render_tx();

    let abstract_shape = create_tetrahedron(1.0);
    let point_shape = create_point_shape(PointShapeOptions {
        abstract_shape,
        edge_length: 1.0,
        pixel_density: 10.0
    });

    let clock_iter: Iter<ClockMessage> = clock_rx.iter();
    for clock_message in clock_iter {
        let render_message = RenderMessage {
            time: clock_message.time,
            point_shape: point_shape.clone()
        };
        render_tx.send(render_message).unwrap();
    }
}

fn create_point_shape (options: PointShapeOptions) -> PointShape {
    let PointShapeOptions {
        abstract_shape,
        edge_length,
        pixel_density
    } = options;

    let AbstractShape {
        vertices,
        edges
    } = abstract_shape;

    let num_pixels_per_edge = (edge_length * pixel_density) as i32;
    let mut points = Vec::with_capacity(edges.len() * (num_pixels_per_edge as usize));

    for edge in edges.iter() {
        let &(a_index, b_index) = edge;
        let a = vertices.get(a_index).unwrap();
        let b = vertices.get(b_index).unwrap();

        let diff_x = b.x - a.x;
        let diff_y = b.y - a.y;
        let diff_z = b.z - a.z;

        let interval_x = diff_x / ((num_pixels_per_edge + 1) as f32);
        let interval_y = diff_y / ((num_pixels_per_edge + 1) as f32);
        let interval_z = diff_z / ((num_pixels_per_edge + 1) as f32);

        let half_interval_x = interval_x / 2_f32;
        let half_interval_y = interval_y / 2_f32;
        let half_interval_z = interval_z / 2_f32;

        for i in 0..num_pixels_per_edge {
            let x = half_interval_x + a.x + interval_x * (i as f32);
            let y = half_interval_y + a.y + interval_y * (i as f32);
            let z = half_interval_z + a.z + interval_z * (i as f32);
            let position = Position { x, y, z };
            let point = Point { position };
            points.push(point);
        }
    }

    let point_shape = PointShape { points };
    return point_shape
}

#[derive(Clone, Copy)]
struct RGB {
    pub red: f32,
    pub green: f32,
    pub blue: f32
}

#[derive(Clone, Copy)]
struct Position {
    pub x: f32,
    pub y: f32,
    pub z: f32
}

#[derive(Clone)]
struct AbstractShape {
    pub vertices: Vec<Position>,
    pub edges: Vec<(usize, usize)>
}

struct PointShapeOptions {
    pub abstract_shape: AbstractShape,
    pub edge_length: f32,
    pub pixel_density: f32
}

#[derive(Clone, Copy)]
struct Point {
    pub position: Position
}

#[derive(Clone)]
struct PointShape {
    pub points: Vec<Point>
}

#[derive(Clone)]
struct PixelShape {
    pub points: Vec<Point>,
    pub colors: Vec<RGB>
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
