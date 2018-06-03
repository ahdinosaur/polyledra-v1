extern crate nalgebra as na;

use na::{Point3, distance};
use std::f32;

use util::compute_edge_lengths::*;

pub type Position = Point3<f32>;

pub type Vertex = Position;
pub type VertexId = usize;
pub type Vertices = Vec<Vertex>;

#[derive(Clone, Debug)]
pub struct Edge {
    pub source_id: VertexId,
    pub target_id: VertexId
}

impl Edge {
    pub fn new(source_id: VertexId, target_id: VertexId) -> Edge {
        return Edge {
            source_id,
            target_id
        }
    }
    fn reverse(&self) -> Edge {
        return Edge {
            source_id: (&self.target_id).clone(),
            target_id: (&self.source_id).clone()
        }
    }
}

pub type EdgeId = usize;
pub type Edges = Vec<Edge>;

#[derive(Clone, Debug)]
pub struct AbstractShape {
    pub vertices: Vertices,
    pub edges: Edges
}

impl AbstractShape {
    fn none() -> AbstractShape {
        AbstractShape {
            vertices: Vec::new(),
            edges: Vec::new()
        }
    }

    pub fn edge_source(&self, edge_id: EdgeId) -> &Vertex {
        let edges = &self.edges;
        let vertices = &self.vertices;
        let edge = edges.get(edge_id).unwrap();
        vertices.get(edge.source_id).unwrap()
    }

    pub fn edge_target(&self, edge_id: EdgeId) -> &Vertex {
        let edges = &self.edges;
        let vertices = &self.vertices;
        let edge = edges.get(edge_id).unwrap();
        vertices.get(edge.target_id).unwrap()
    }

    pub fn edge_length(&self, edge_id: EdgeId) -> f32 {
        let edges = &self.edges;
        let vertices = &self.vertices;

        let edge = edges.get(edge_id).unwrap();
        let source = &self.edge_source(edge_id);
        let target = &self.edge_target(edge_id);

        distance(*source, *target)
    }
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
                Vertex::new(0_f32, 0_f32, a),
                Vertex::new((8_f32/9_f32).sqrt() * a, 0_f32, -(1_f32/3_f32) * a),
                Vertex::new(-(2_f32/9_f32).sqrt() * a, (2_f32/3_f32).sqrt() * a, -(1_f32/3_f32) * a),
                Vertex::new(-(2_f32/9_f32).sqrt() * a, -(2_f32/3_f32).sqrt() * a, -(1_f32/3_f32) * a)
            ],
            edges: vec![
                Edge::new(3, 1),
                Edge::new(1, 0),
                Edge::new(0, 2),
                Edge::new(2, 3),
                Edge::new(3, 0),
                Edge::new(1, 2)
            ]
        };
    }
}

pub type EdgeIndex = usize;
pub type ArmIndex = usize;

#[derive(Clone, Debug)]
pub struct Dot {
    pub position: Position,
    pub edge_id: EdgeId,
    pub edge_index: EdgeIndex,
    pub arm_index: ArmIndex
}

#[derive(Clone, Debug)]
pub struct Bounds {
    pub min: Position,
    pub max: Position
}

#[derive(Clone, Debug)]
pub struct Shape {
    pub abstract_shape: AbstractShape,
    pub dots: Vec<Dot>,
    pub num_arms: usize,
    pub bounds: Bounds
}

pub struct ShapeOptions {
    pub abstract_shape: AbstractShape,
    pub num_arms: usize,
    pub pixel_density: f32
}

impl Shape {
    pub fn none() -> Self {
        Shape {
            abstract_shape: AbstractShape::none(),
            dots: Vec::new(),
            num_arms: 0,
            bounds: Bounds {
                min: Point3::new(0_f32, 0_f32, 0_f32),
                max: Point3::new(0_f32, 0_f32, 0_f32)
            }
        }
    }

    pub fn new (options: ShapeOptions) -> Shape {
        let ShapeOptions {
            abstract_shape,
            pixel_density,
            num_arms
        } = options;

        let vertices = abstract_shape.vertices.clone();
        let edges = abstract_shape.edges.clone();

        let edge_lengths = compute_edge_lengths(&edges, &vertices);
        let total_edge_length: f32 = edge_lengths.iter().sum();
        let mut dots = Vec::with_capacity((total_edge_length * pixel_density) as usize);

        let mut min_x = f32::INFINITY;
        let mut min_y = f32::INFINITY;
        let mut min_z = f32::INFINITY;

        let mut max_x = f32::NEG_INFINITY;
        let mut max_y = f32::NEG_INFINITY;
        let mut max_z = f32::NEG_INFINITY;

        for (edge_id, edge) in edges.iter().enumerate() {
            let edge_length = edge_lengths.get(edge_id).unwrap();
            let num_pixels_per_edge = (edge_length * pixel_density) as i32;

            let a_id = edge.source_id;
            let b_id = edge.target_id;
            let a = vertices.get(a_id).unwrap();
            let b = vertices.get(b_id).unwrap();

            let diff_x = b.x - a.x;
            let diff_y = b.y - a.y;
            let diff_z = b.z - a.z;

            let interval_x = diff_x / ((num_pixels_per_edge + 1) as f32);
            let interval_y = diff_y / ((num_pixels_per_edge + 1) as f32);
            let interval_z = diff_z / ((num_pixels_per_edge + 1) as f32);

            let half_interval_x = interval_x / 2_f32;
            let half_interval_y = interval_y / 2_f32;
            let half_interval_z = interval_z / 2_f32;

            for arm_index in 0..num_arms {
                let is_even_arm = arm_index % 2 == 0;
                let edge_index_range = 0..(num_pixels_per_edge as usize);
                let edge_index_iter: Box<Iterator<Item=usize>> = if is_even_arm {
                    Box::new(edge_index_range)
                } else {
                    Box::new(edge_index_range.rev())
                };
                for edge_index in edge_index_iter {
                    let x = half_interval_x + a.x + interval_x * (edge_index as f32);
                    let y = half_interval_y + a.y + interval_y * (edge_index as f32);
                    let z = half_interval_z + a.z + interval_z * (edge_index as f32);

                    if x < min_x { min_x = x; } else if x > max_x { max_x = x; }
                    if y < min_y { min_y = y; } else if y > max_y { max_y = y; }
                    if z < min_z { min_z = z; } else if z > max_z { max_z = z; }

                    let position = Position::new(x, y, z);

                    let dot = Dot {
                        position,
                        edge_id,
                        edge_index: edge_index as usize,
                        arm_index
                    };
                    dots.push(dot);
                }
            }
        }

        let bounds = Bounds {
            min: Point3::new(min_x, min_y, min_z),
            max: Point3::new(max_x, max_y, max_z)
        };

        debug!("bounds: {:?}", bounds);

        let shape = Shape {
            abstract_shape,
            dots,
            num_arms,
            bounds
        };

        return shape
    }
}

