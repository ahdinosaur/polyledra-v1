include <polyhedra.scad>
include <helpers.scad>
include <edge.scad>
include <tetrahedron-vertex.scad>

SPACE = 30;
LENGTH = 500;
OFFSET = 20;
RADIUS = 20;

$main = 1;

main();

module main () {
  for (i=[0 : len(tetrahedron_vertices) - 1]) {
    orient_vertex(
      (LENGTH + SPACE) * tetrahedron_vertices[i],
      (LENGTH + SPACE)* tetrahedron_vertices[tetrahedron_adjacent_vertices[i][0]]
    )
    rotate(a = [0, (1/2) * ROT])
    union () {
      tetrahedron_vertex();
      
      for_each_radial(
        num_steps = EDGES_PER_VERTEX,
        radius = EDGES_RADIUS
      ) {
        rotate(a = [0, EDGE_ANGLE])
        translate([0, 0, EDGE_DEPTH / 2])
        edge();
      }
    }
  }
  
  for(i = [0 : len(tetrahedron_edges) - 1]) {
    orient_edge(
      (LENGTH + SPACE) * tetrahedron_vertices[tetrahedron_edges[i][0]],
      (LENGTH + SPACE) * tetrahedron_vertices[tetrahedron_edges[i][1]]
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
            r = CHANNEL_LENGTH_SIDE,
            $fa = MIN_ARC_FRAGMENT_ANGLE,
            $fs = MIN_ARC_FRAGMENT_SIZE
          );
        }
      }
    }
  }
}