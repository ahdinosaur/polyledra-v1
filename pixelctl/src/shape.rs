extern crate nalgebra as na;

use na::{Point3};

use std::f32;

pub type Position = Point3<f32>;

#[derive(Clone)]
pub struct AbstractShape {
    pub vertices: Vec<Position>,
    pub edges: Vec<(usize, usize)>
}

pub trait AbstractShapeCreator {
    fn new(length: f32) -> AbstractShape;
}

// https://en.wikipedia.org/wiki/Tetrahedron#Formulas_for_a_regular_tetrahedron
pub struct Tetrahedron;
impl AbstractShapeCreator for Tetrahedron {
    fn new(length: f32) -> AbstractShape {
        let a = length / (8_f32/3_f32).sqrt();

        return AbstractShape {
            vertices: vec![
                Position::new(0_f32, 0_f32, a),
                Position::new((8_f32/9_f32).sqrt() * a, 0_f32, -(1_f32/3_f32) * a),
                Position::new(-(2_f32/9_f32).sqrt() * a, (2_f32/3_f32).sqrt() * a, -(1_f32/3_f32) * a),
                Position::new(-(2_f32/9_f32).sqrt() * a, -(2_f32/3_f32).sqrt() * a, -(1_f32/3_f32) * a)
            ],
            edges: vec![
                (3, 1),
                (1, 0),
                (0, 2),
                (2, 3),
                (3, 0),
                (1, 2)
            ]
        };
    }
}


#[derive(Clone, Debug)]
pub struct Dot {
    pub position: Position
}

#[derive(Clone, Debug)]
pub struct Bounds {
    pub min: Position,
    pub max: Position
}

#[derive(Clone, Debug)]
pub struct Shape {
    pub dots: Vec<Dot>,
    pub bounds: Bounds
}

pub struct ShapeOptions {
    pub abstract_shape: AbstractShape,
    pub edge_length: f32,
    pub pixel_density: f32
}

impl Shape {
    pub fn none() -> Self {
        Shape {
            dots: Vec::new(),
            bounds: Bounds {
                min: Point3::new(0_f32, 0_f32, 0_f32),
                max: Point3::new(0_f32, 0_f32, 0_f32)
            }
        }
    }

    pub fn new (options: ShapeOptions) -> Shape {
        let ShapeOptions {
            abstract_shape,
            edge_length,
            pixel_density
        } = options;

        let AbstractShape {
            vertices,
            edges
        } = abstract_shape;

        let num_pixels_per_edge = (edge_length * pixel_density) as i32;
        let mut dots = Vec::with_capacity(edges.len() * (num_pixels_per_edge as usize));

        let mut min_x = f32::INFINITY;
        let mut min_y = f32::INFINITY;
        let mut min_z = f32::INFINITY;

        let mut max_x = f32::NEG_INFINITY;
        let mut max_y = f32::NEG_INFINITY;
        let mut max_z = f32::NEG_INFINITY;

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

                if x < min_x { min_x = x; } else if x > max_x { max_x = x; }
                if y < min_y { min_y = y; } else if y > max_y { max_y = y; }
                if z < min_z { min_z = z; } else if z > max_z { max_z = z; }

                let position = Position::new(x, y, z);

                let dot = Dot { position };
                dots.push(dot);
            }
        }

        let bounds = Bounds {
            min: Point3::new(min_x, min_y, min_z),
            max: Point3::new(max_x, max_y, max_z)
        };

        println!("bounds: {:?}", bounds);

        let shape = Shape {
            dots,
            bounds
        };

        return shape
    }
}
