include <constants.scad>
include <helpers.scad>
include <nuts-and-bolts.scad>

EDGES_PER_OCTAHEDRON_VERTEX = 4;
OCTAHEDRON_VERTEX_EDGES_RADIUS = 24;
OCTAHEDRON_VERTEX_EDGE_ANGLE = 45;

OCTAHEDRON_VERTEX_EDGE_SIDES = 3;
OCTAHEDRON_VERTEX_EDGE_BOLT_SIZE = 4;
OCTAHEDRON_VERTEX_EDGE_BOLT_LENGTH = INFINITY;
OCTAHEDRON_VERTEX_EDGE_BOLT_TOLERANCE = (4/3) * TOLERANCE;
OCTAHEDRON_VERTEX_EDGE_BOLTS_RADIUS = 17.3205;
OCTAHEDRON_VERTEX_EDGE_OUTER_RADIUS = OCTAHEDRON_VERTEX_EDGE_BOLTS_RADIUS + 4;
OCTAHEDRON_VERTEX_EDGE_INNER_RADIUS = OCTAHEDRON_VERTEX_EDGE_OUTER_RADIUS - OCTAHEDRON_VERTEX_EDGE_BOLT_SIZE * 2 - 7;
OCTAHEDRON_VERTEX_EDGE_MARGIN = 2;
OCTAHEDRON_VERTEX_EDGE_OUTER_DEPTH = 5;
OCTAHEDRON_VERTEX_EDGE_BETWEEN_WIDTH = (OCTAHEDRON_VERTEX_EDGE_OUTER_RADIUS - 4) * 2;
OCTAHEDRON_VERTEX_EDGE_BETWEEN_HEIGHT = OCTAHEDRON_VERTEX_EDGE_BETWEEN_WIDTH / 1.5;
OCTAHEDRON_VERTEX_EDGE_BETWEEN_DEPTH = 2;
OCTAHEDRON_VERTEX_EDGE_BETWEEN_DEPTH_OFFSET = 4;
OCTAHEDRON_VERTEX_EDGE_CORNER_RADIUS = OCTAHEDRON_VERTEX_EDGE_BOLT_SIZE;

OCTAHEDRON_VERTEX_SIDES = EDGES_PER_OCTAHEDRON_VERTEX * 2;
OCTAHEDRON_VERTEX_BOLTS_RADIUS = 7;
OCTAHEDRON_VERTEX_BOLT_SIZE = 4;
OCTAHEDRON_VERTEX_BOLT_LENGTH = INFINITY;
OCTAHEDRON_VERTEX_BOLT_TOLERANCE = TOLERANCE;
OCTAHEDRON_VERTEX_NUM_BOLTS = 2;
OCTAHEDRON_VERTEX_OUTER_RADIUS = 20;
OCTAHEDRON_VERTEX_OUTER_DEPTH = 5;
OCTAHEDRON_VERTEX_OUTER_DEPTH_OFFSET = 6;
OCTAHEDRON_VERTEX_CORNER_RADIUS = OCTAHEDRON_VERTEX_BOLT_SIZE;

OCTAHEDRON_VERTEX_MAX_Z = OCTAHEDRON_VERTEX_OUTER_DEPTH_OFFSET + (OCTAHEDRON_VERTEX_OUTER_DEPTH / 2);

module octahedron_vertex_negative () {
  above_z(z = OCTAHEDRON_VERTEX_MAX_Z);
  
  vertex_bolts();
  //vertex_gap();

  for_each_radial(
    num_steps = EDGES_PER_OCTAHEDRON_VERTEX,
    radius = OCTAHEDRON_VERTEX_EDGES_RADIUS
  ) {
    rotate(a = [0, OCTAHEDRON_VERTEX_EDGE_ANGLE])
    edge_bolts();
    
    rotate(a = [0, OCTAHEDRON_VERTEX_EDGE_ANGLE])
    edge_gap();
  }
  
  edge_plate_negatives();
}
  
module octahedron_vertex () {
  difference () {
    union () {
      vertex_plate();
      
      for_each_radial(
        num_steps = EDGES_PER_OCTAHEDRON_VERTEX,
        radius = OCTAHEDRON_VERTEX_EDGES_RADIUS
      ) {
        rotate(a = [0, OCTAHEDRON_VERTEX_EDGE_ANGLE])
        edge_plate();
      }
            
     for_each_radial(
        num_steps = EDGES_PER_OCTAHEDRON_VERTEX,
        radius = OCTAHEDRON_VERTEX_EDGES_RADIUS,
        radial_offset = (1 / EDGES_PER_OCTAHEDRON_VERTEX / 2) * ROT,
        rotation_offset = (1 / EDGES_PER_OCTAHEDRON_VERTEX / 2) * ROT
      ) {
        rotate(a = [0, OCTAHEDRON_VERTEX_EDGE_ANGLE])
        edge_between();
      }
    }
    
    octahedron_vertex_negative();
  }
}

module vertex_plate () {
  // polygon
  // rotate((1 / 4) * EDGES_PER_OCTAHEDRON_VERTEX * ROT)
  translate([0, 0, OCTAHEDRON_VERTEX_OUTER_DEPTH_OFFSET])
  difference () {
    rounded_polygon(
      num_sides = OCTAHEDRON_VERTEX_SIDES,
      depth = OCTAHEDRON_VERTEX_OUTER_DEPTH,
      radius = OCTAHEDRON_VERTEX_OUTER_RADIUS,
      corner_radius = OCTAHEDRON_VERTEX_CORNER_RADIUS
    );
  }
}

module vertex_bolts () {
  // minus bolts
  rotate((1 / 3) * EDGES_PER_OCTAHEDRON_VERTEX * ROT)
  for_each_radial(
    num_steps = 3,
    end_step = OCTAHEDRON_VERTEX_NUM_BOLTS,
    radius = OCTAHEDRON_VERTEX_BOLTS_RADIUS
  ) {
    translate([0, 0, - (1/2) * OCTAHEDRON_VERTEX_BOLT_LENGTH])
    bolt_hole(
      size = OCTAHEDRON_VERTEX_BOLT_SIZE,
      length = OCTAHEDRON_VERTEX_BOLT_LENGTH,
      tolerance = OCTAHEDRON_VERTEX_BOLT_TOLERANCE
    );
  }
}

module vertex_gap () {
  // rotate((1 / 2) * EDGES_PER_OCTAHEDRON_VERTEX * ROT)
  translate([0, 0, OCTAHEDRON_VERTEX_OUTER_DEPTH_OFFSET])
  // minus inner polygon
  translate([0, 0, INFINITESIMAL])
  rounded_polygon(
    num_sides = OCTAHEDRON_VERTEX_SIDES,
    depth = OCTAHEDRON_VERTEX_OUTER_DEPTH + 3 * INFINITESIMAL,
    radius = OCTAHEDRON_VERTEX_INNER_RADIUS,
    corner_radius = OCTAHEDRON_VERTEX_CORNER_RADIUS
  );
}

module edge_plate () {
  rotate(a = [0, 0, (1 / 2 * OCTAHEDRON_VERTEX_EDGE_SIDES) * ROT])
  // polygon
  rounded_polygon(
    num_sides = OCTAHEDRON_VERTEX_EDGE_SIDES,
    depth = OCTAHEDRON_VERTEX_EDGE_OUTER_DEPTH,
    radius = OCTAHEDRON_VERTEX_EDGE_OUTER_RADIUS,
    corner_radius = OCTAHEDRON_VERTEX_EDGE_CORNER_RADIUS
  );
}

module edge_gap () {
  // rotate(a = [0, 0, (1 / 2 * EDGES_PER_OCTAHEDRON_VERTEX) * ROT])
  // minus inner polygon
  translate([0, 0, INFINITESIMAL])
  rounded_polygon(
    num_sides = OCTAHEDRON_VERTEX_EDGE_SIDES,
    depth = OCTAHEDRON_VERTEX_EDGE_OUTER_DEPTH + 3 * INFINITESIMAL,
    radius = OCTAHEDRON_VERTEX_EDGE_INNER_RADIUS,
    corner_radius = OCTAHEDRON_VERTEX_EDGE_CORNER_RADIUS
  );
}

module edge_plate_negatives () {
  // subtract the space that would interfere with the edge connectors
  for_each_radial(
    num_steps = EDGES_PER_OCTAHEDRON_VERTEX,
    radius = OCTAHEDRON_VERTEX_EDGES_RADIUS
  ) {
    rotate(a = [0, OCTAHEDRON_VERTEX_EDGE_ANGLE])
    rotate([0, 0, (1 / 2 * EDGES_PER_OCTAHEDRON_VERTEX) * ROT])
    translate([(-1/2) * INFINITY, (-1/2) * INFINITY, (1/2) * OCTAHEDRON_VERTEX_EDGE_OUTER_DEPTH - INFINITESIMAL])
    cube(INFINITY);
  }
}

module edge_bolts () {
  // minus bolts
  rotate(a = [0, 0, (1 / 2) * OCTAHEDRON_VERTEX_EDGE_SIDES * ROT])
  for_each_radial(
    start_step = 1,
    num_steps = OCTAHEDRON_VERTEX_EDGE_SIDES,
    radius = OCTAHEDRON_VERTEX_EDGE_BOLTS_RADIUS
  ) {
    translate([0, 0, - (1/2) * OCTAHEDRON_VERTEX_EDGE_BOLT_LENGTH])
    bolt_hole(
      size = OCTAHEDRON_VERTEX_EDGE_BOLT_SIZE,
      length = OCTAHEDRON_VERTEX_EDGE_BOLT_LENGTH,
      tolerance = OCTAHEDRON_VERTEX_EDGE_BOLT_TOLERANCE
    );
  }
}

module edge_between () {
  rotate(a = [0, 0, (1 / 16) * EDGES_PER_OCTAHEDRON_VERTEX * ROT])
  translate([0, 0, OCTAHEDRON_VERTEX_EDGE_BETWEEN_DEPTH_OFFSET])
  difference () {
    // polygon
    rounded_box(
      size = [OCTAHEDRON_VERTEX_EDGE_BETWEEN_WIDTH, OCTAHEDRON_VERTEX_EDGE_BETWEEN_HEIGHT, OCTAHEDRON_VERTEX_EDGE_BETWEEN_DEPTH],
      radius = OCTAHEDRON_VERTEX_EDGE_CORNER_RADIUS
    );
  }
}
