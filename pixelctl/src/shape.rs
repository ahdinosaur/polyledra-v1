extern crate nalgebra as na;

use na::{Point3};

use std::f32;

use color;

pub type Position = Point3<f32>;

#[derive(Clone)]
pub struct AbstractShape {
    pub vertices: Vec<Position>,
    pub edges: Vec<(usize, usize)>
}

pub struct DotShapeOptions {
    pub abstract_shape: AbstractShape,
    pub edge_length: f32,
    pub pixel_density: f32
}

#[derive(Clone)]
pub struct Dot {
    pub position: Position
}

#[derive(Clone)]
pub struct DotShape {
    pub dots: Vec<Dot>
}

#[derive(Clone)]
pub struct PixelShape {
    pub dots: Vec<Dot>,
    pub colors: Vec<color::RGB>
}

// https://en.wikipedia.org/wiki/Tetrahedron#Formulas_f32or_a_regular_tetrahedron
pub fn create_tetrahedron (length: f32) -> AbstractShape {
    let a = length / (8_f32/3_f32).sqrt();

    return AbstractShape {
        vertices: vec![
            Position::new(0_f32, 0_f32, a),
            Position::new((8_f32/9_f32).sqrt() * a, 0_f32, -(1_f32/3_f32) * a),
            Position::new(-(2_f32/9_f32).sqrt() * a, (2_f32/3_f32).sqrt() * a, -(1_f32/3_f32) * a),
            Position::new(-(2_f32/9_f32).sqrt() * a, -(2_f32/3_f32).sqrt() * a, -(1_f32/3_f32) * a)
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

pub fn create_dot_shape (options: DotShapeOptions) -> DotShape {
    let DotShapeOptions {
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
            let position = Position::new(x, y, z);
            let dot = Dot { position };
            dots.push(dot);
        }
    }

    let dot_shape = DotShape { dots };
    return dot_shape
}
