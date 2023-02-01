include <polyhedra.scad>
include <helpers.scad>
include <edge-lib.scad>
include <octahedron-vertex-lib.scad>

SPACE = 50;
LENGTH = 500;
OFFSET = 20;
RADIUS = 20;

main();

module main () {
  for (i=[0 : len(octahedron_vertices) - 1]) {
    orient_vertex(
      (LENGTH + SPACE) * octahedron_vertices[i],
      (LENGTH + SPACE)* octahedron_vertices[octahedron_adjacent_vertices[i][0]]
    )
    rotate(a = [0, (1/2) * ROT])
    union () {
      octahedron_vertex();
      
      for_each_radial(
        num_steps = EDGES_PER_OCTAHEDRON_VERTEX,
        radius = OCTAHEDRON_VERTEX_EDGES_RADIUS
      ) {
        rotate(a = [0, OCTAHEDRON_VERTEX_EDGE_ANGLE])
        translate([0, 0, EDGE_LENGTH_Z / 2])
        edge();
      }
    }
  }
  
  for(i = [0 : len(octahedron_edges) - 1]) {
    orient_edge(
      (LENGTH + SPACE) * octahedron_vertices[octahedron_edges[i][0]],
      (LENGTH + SPACE) * octahedron_vertices[octahedron_edges[i][1]]
    )
    translate([OFFSET, 0, 0])
    translate([0, 0, (-1/2) * LENGTH])
    for_each_radial(
      num_steps = 3,
      radius = CHANNELS_RADIUS
    ) {
      rotate((1/4) * ROT)
      linear_extrude(height = LENGTH)
      intersection () {
        square(INFINITY);
        
        union () {
          circle(
            r = CHANNEL_SIDE_LENGTH,
            $fa = MIN_ARC_FRAGMENT_ANGLE,
            $fs = MIN_ARC_FRAGMENT_SIZE
          );
        }
      }
    }
  }
}
