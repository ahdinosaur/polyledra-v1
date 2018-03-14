use na::{distance, normalize};
use rand::{thread_rng, seq};
use std::rc::Rc;
use std::f32;
use std::collections::{HashMap, HashSet, VecDeque};

use color;
use control;
use scene;
use shape;

static MS_PER_S: f32 = 1.0e9; // microseconds_per_second

#[derive(Debug)]
pub struct Walk {
    shape: Rc<shape::Shape>,
    vertex_adjacencies: HashMap<shape::VertexId, HashSet<shape::VertexId>>,
    current_position: shape::Position,
    next_vertex_id: shape::VertexId,
    prev_vertex_ids: VecDeque<shape::VertexId>
}

impl scene::Scene for Walk {
    fn new (shape: Rc<shape::Shape>) -> Self where Self:Sized {
        // create vertex adjacency mapping
        let vertex_adjacencies = {
            let mut value = HashMap::new();
            shape.edges.iter()
                .for_each(|edge| {
                    let a_id = edge.source_id;
                    let b_id = edge.target_id;
                    if !value.contains_key(&a_id) {
                        value.insert(a_id, HashSet::new());
                    }
                    value.get_mut(&a_id).unwrap().insert(b_id);
                    if !value.contains_key(&b_id) {
                        value.insert(b_id, HashSet::new());
                    }
                    value.get_mut(&b_id).unwrap().insert(a_id);
                });
            value
        };
        debug!("vertex adjacencies {:?}", vertex_adjacencies);

        let default_edge = shape::Edge::new(0, 0);
        let edges_clone = &shape.clone().edges;
        let initial_edge = edges_clone.get(0).unwrap_or(&default_edge);
        let last_vertex_id = initial_edge.source_id.clone();
        let next_vertex_id = initial_edge.target_id.clone();
        let default_position = shape::Position::new(0_f32, 0_f32, 0_f32);
        let current_position = shape.vertices.get(last_vertex_id).unwrap_or(&default_position).clone();

        let mut prev_vertex_ids = VecDeque::new();
        prev_vertex_ids.push_back(last_vertex_id);

        Walk {
            shape,
            vertex_adjacencies,
            current_position,
            next_vertex_id,
            prev_vertex_ids
        }
    }

    fn scene<'a> (&'a mut self, time: control::Time) -> color::Colors<'a> {
        let shape = &self.shape;
        let dots = &shape.dots;
        let vertices = &shape.vertices;
        let edges = &shape.edges;

        let current_position = self.current_position;
        let next_vertex_id = self.next_vertex_id;
        let next_vertex = vertices.get(next_vertex_id).unwrap();
        let prev_vertex_ids = &mut self.prev_vertex_ids;
        let prev_vertices: Vec<shape::Vertex> = prev_vertex_ids.iter()
            .map(|id| *vertices.get(*id).unwrap())
            .collect();
        let last_vertex = prev_vertices.last().unwrap();

        debug!("prev_vertices {:?} {:?}", prev_vertex_ids, prev_vertices);
        debug!("next_vertex {:?} {:?}", next_vertex_id, next_vertex);
        debug!("current_position {:?}", current_position);

        let speed = 0.05_f32;
        let tail_length = 2_f32;

        let hue_speed = (0.25_f32) / MS_PER_S;
        let hue_start = time * hue_speed;

        // clone for moving to closure (TODO no clone?)
        let prev_vertex_ids_clone = prev_vertex_ids.clone();

        let colors = dots.iter()
            .map(move |dot| {
                let position = &dot.position;
                let edge_id = dot.edge_id;

                let edge = edges.get(edge_id).unwrap();
                let source_id = edge.source_id;
                let target_id = edge.target_id;

                // calculate distance from dot position to current position
                // by going through previous edges
                let distance_from_current = {
                    let mut distance_sofar = 0_f32;
                    let mut has_seen_dot = false;
                    let mut index = 0;

                    // start with edge endpoint at current position
                    let mut vertex_b_id = next_vertex_id;

                    // for each previous edge, add new distance
                    // (current position, vertex a, vertex b, ..., dot position)
                    let prev_vertices_length = prev_vertex_ids_clone.len();
                    while !has_seen_dot && index < prev_vertices_length {
                        let vertex_a_id = *prev_vertex_ids_clone.get(prev_vertices_length - index - 1).unwrap();

                        let vertex_a = vertices.get(vertex_a_id).unwrap();
                        let vertex_b = vertices.get(vertex_b_id).unwrap();

                        // if dot is on edge
                        if 
                            (source_id == vertex_a_id && target_id == vertex_b_id) ||
                            (source_id == vertex_b_id && target_id == vertex_a_id)
                        {
                            has_seen_dot = true;
                            if index == 0 {
                                // confirm that dot is on following side of edge
                                if distance(&current_position, vertex_b) < distance(position, vertex_b) {
                                    // add distance from current position to dot position
                                    distance_sofar += distance(&current_position, position);
                                } else {
                                    // add distance from current position to previous vertex
                                    distance_sofar += distance(&current_position, vertex_a);
                                    has_seen_dot = false;
                                }
                            } else {
                                // add distance from previous vertex to dot position
                                distance_sofar += distance(vertex_b, position);
                            }
                        } else {
                            if index == 0 {
                                // add distance from current position to previous vertex
                                distance_sofar += distance(&current_position, vertex_a);
                            } else {
                                // add distance between two vertices
                                distance_sofar += distance(vertex_b, vertex_a);
                            }
                        }
                        vertex_b_id = vertex_a_id;
                        index += 1;
                    }

                    if has_seen_dot { distance_sofar } else { f32::INFINITY }
                };

                debug!("distance from current {}", distance_from_current);

                color::Color::Hsl(color::Hsl {
                    hue: hue_start + (distance_from_current / tail_length),
                    saturation: 1_f32,
                    lightness: 0_f32.max(0.5_f32 - (distance_from_current / 4_f32)),
                })
            });

        let distance_to_next = distance(&current_position, next_vertex);
        debug!("distance to next {}", distance_to_next);

        // if we are about to hit the vertex
        if distance_to_next < speed {
            let current_vertex_id = next_vertex_id;
            let current_vertex = next_vertex;

            // set next vertex
            let possible_next_vertex_ids = &self.vertex_adjacencies.get(&current_vertex_id).unwrap();
            let mut rng = thread_rng();
            let next_vertex_id = **seq::sample_iter(&mut rng, possible_next_vertex_ids.iter(), 1).unwrap().first().unwrap();
            self.next_vertex_id = next_vertex_id;

            prev_vertex_ids.push_back(current_vertex_id);

            // set current position exactly at vertex (in case of float skew)
            self.current_position = current_vertex.clone();

            // remove previous vertices that go beyond the tail length
            {
                let mut index = 0;
                let prev_edge_lengths: Vec<f32> = (0..prev_vertices.len())
                    .into_iter()
                    .map(|index| {
                        let a = if index == 0 {
                            next_vertex
                        } else {
                            prev_vertices.get(index - 1).unwrap()
                        };
                        let b = prev_vertices.get(index).unwrap();

                        distance(b, a)
                    })
                    .collect();
                let mut prev_edge_length: f32 = prev_edge_lengths.iter().sum();
                while prev_edge_length > tail_length {
                    let _first_edge_id = prev_vertex_ids.pop_front();
                    let first_edge_length = prev_edge_lengths.get(index).unwrap();
                    index += 1;
                    prev_edge_length -= first_edge_length;
                }
            }
        } else { // step towards the next vertex
            let diff_vector = next_vertex - last_vertex;
            let step_vector = normalize(&diff_vector) * speed;
            debug!("step vector {:?}", step_vector);
            let next_position = current_position + step_vector;

            self.current_position = next_position;
        }

        return Box::new(colors);
    }
}
