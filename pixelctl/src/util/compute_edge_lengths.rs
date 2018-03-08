use na::{distance};

use shape;

pub fn compute_edge_lengths (edges: &shape::Edges, vertices: &shape::Vertices) -> Vec<f32> {
    edges.iter()
        .map(|edge| {
            let source_id = edge.source_id;
            let target_id = edge.target_id;
            /*
            let shape::Edge {
                source_id,
                target_id
            } = edge;
            */
            let source_vertex = vertices.get(source_id).unwrap();
            let target_vertex = vertices.get(target_id).unwrap();
            distance(source_vertex, target_vertex)
        })
        .collect()
}

#[cfg(test)]
mod test {
    use util::compute_edge_lengths::*;

    #[test]
    fn one() {
        let vertices = vec![
            shape::Vertex::new(0_f32, 0_f32, 0_f32),
            shape::Vertex::new(0_f32, 0_f32, 1_f32)
        ];
        let edges = vec![
            shape::Edge::new(0, 1)
        ];
        let lengths = compute_edge_lengths(&edges, &vertices);
        assert_eq!(lengths.len(), 1);
        assert_eq!(lengths.get(0).unwrap(), &1_f32);
    }
}
