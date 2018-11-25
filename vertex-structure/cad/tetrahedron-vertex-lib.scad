include <constants.scad>
include <helpers.scad>
include <nuts-and-bolts.scad>

EDGES_PER_TETRAHEDRON_VERTEX = 3;
TETRAHEDRON_VERTEX_EDGES_RADIUS = 24;
TETRAHEDRON_VERTEX_EDGE_ANGLE = 35.26439;

TETRAHEDRON_VERTEX_EDGE_SIDES = 3;
TETRAHEDRON_VERTEX_EDGE_BOLT_SIZE = 4;
TETRAHEDRON_VERTEX_EDGE_BOLT_LENGTH = INFINITY;
TETRAHEDRON_VERTEX_EDGE_BOLT_TOLERANCE = (4/3) * TOLERANCE;
TETRAHEDRON_VERTEX_EDGE_BOLTS_RADIUS = 17.3205;
TETRAHEDRON_VERTEX_EDGE_OUTER_RADIUS = TETRAHEDRON_VERTEX_EDGE_BOLTS_RADIUS + 4;
TETRAHEDRON_VERTEX_EDGE_INNER_RADIUS = TETRAHEDRON_VERTEX_EDGE_OUTER_RADIUS - TETRAHEDRON_VERTEX_EDGE_BOLT_SIZE * 2 - 7;
TETRAHEDRON_VERTEX_EDGE_MARGIN = 2;
TETRAHEDRON_VERTEX_EDGE_OUTER_DEPTH = 5;
TETRAHEDRON_VERTEX_EDGE_BETWEEN_WIDTH = (TETRAHEDRON_VERTEX_EDGE_OUTER_RADIUS - 4) * 2;
TETRAHEDRON_VERTEX_EDGE_BETWEEN_HEIGHT = TETRAHEDRON_VERTEX_EDGE_BETWEEN_WIDTH / 2;
TETRAHEDRON_VERTEX_EDGE_BETWEEN_DEPTH = 2;
TETRAHEDRON_VERTEX_EDGE_BETWEEN_DEPTH_OFFSET = 1;
TETRAHEDRON_VERTEX_EDGE_CORNER_RADIUS = TETRAHEDRON_VERTEX_EDGE_BOLT_SIZE;

TETRAHEDRON_VERTEX_SIDES = EDGES_PER_TETRAHEDRON_VERTEX * 2;
TETRAHEDRON_VERTEX_BOLTS_RADIUS = 9;
TETRAHEDRON_VERTEX_BOLT_SIZE = 4;
TETRAHEDRON_VERTEX_BOLT_LENGTH = INFINITY;
TETRAHEDRON_VERTEX_BOLT_TOLERANCE = TOLERANCE;
TETRAHEDRON_VERTEX_NUM_BOLTS = 2;
TETRAHEDRON_VERTEX_OUTER_RADIUS = 16;
TETRAHEDRON_VERTEX_OUTER_DEPTH = 5;
TETRAHEDRON_VERTEX_OUTER_DEPTH_OFFSET = 6;
TETRAHEDRON_VERTEX_CORNER_RADIUS = TETRAHEDRON_VERTEX_BOLT_SIZE;

TETRAHEDRON_VERTEX_MAX_Z = TETRAHEDRON_VERTEX_OUTER_DEPTH_OFFSET + (TETRAHEDRON_VERTEX_OUTER_DEPTH / 2);
  
module tetrahedron_vertex_negative () {
  above_z(z = TETRAHEDRON_VERTEX_MAX_Z);
  
  vertex_bolts();
  //vertex_gap();

  for_each_radial(
    num_steps = TETRAHEDRON_VERTEX_EDGE_SIDES,
    radius = TETRAHEDRON_VERTEX_EDGES_RADIUS
  ) {
    rotate(a = [0, TETRAHEDRON_VERTEX_EDGE_ANGLE])
    edge_bolts();
    
    rotate(a = [0, TETRAHEDRON_VERTEX_EDGE_ANGLE])
    edge_gap();
  }
  
  edge_plate_negatives();
}
  
module tetrahedron_vertex () {
  difference () {
    union () {
      vertex_plate();
      
      for_each_radial(
        num_steps = TETRAHEDRON_VERTEX_EDGE_SIDES,
        radius = TETRAHEDRON_VERTEX_EDGES_RADIUS
      ) {
        rotate(a = [0, TETRAHEDRON_VERTEX_EDGE_ANGLE])
        edge_plate();
      }
            
     for_each_radial(
        num_steps = TETRAHEDRON_VERTEX_EDGE_SIDES,
        radius = TETRAHEDRON_VERTEX_EDGES_RADIUS,
        radial_offset = (1 / TETRAHEDRON_VERTEX_EDGE_SIDES / 2) * ROT,
        rotation_offset = (1 / TETRAHEDRON_VERTEX_EDGE_SIDES / 2) * ROT
      ) {
        rotate(a = [0, TETRAHEDRON_VERTEX_EDGE_ANGLE])
        edge_between();
      }
    }
    
    tetrahedron_vertex_negative();
  }
}

module vertex_plate () {
  // polygon
  rotate((1 / 4) * EDGES_PER_TETRAHEDRON_VERTEX * ROT)
  translate([0, 0, TETRAHEDRON_VERTEX_OUTER_DEPTH_OFFSET])
  difference () {
    rounded_polygon(
      num_sides = TETRAHEDRON_VERTEX_SIDES,
      depth = TETRAHEDRON_VERTEX_OUTER_DEPTH,
      radius = TETRAHEDRON_VERTEX_OUTER_RADIUS,
      corner_radius = TETRAHEDRON_VERTEX_CORNER_RADIUS
    );
  }
}

module vertex_bolts () {
  // minus bolts
  rotate((1 / 2) * EDGES_PER_TETRAHEDRON_VERTEX * ROT)
  for_each_radial(
    num_steps = EDGES_PER_TETRAHEDRON_VERTEX,
    end_step = TETRAHEDRON_VERTEX_NUM_BOLTS,
    radius = TETRAHEDRON_VERTEX_BOLTS_RADIUS
  ) {
    translate([0, 0, - (1/2) * TETRAHEDRON_VERTEX_BOLT_LENGTH])
    bolt_hole(
      size = TETRAHEDRON_VERTEX_BOLT_SIZE,
      length = TETRAHEDRON_VERTEX_BOLT_LENGTH,
      tolerance = TETRAHEDRON_VERTEX_BOLT_TOLERANCE
    );
  }
}

module vertex_gap () {
  rotate((1 / 2) * EDGES_PER_TETRAHEDRON_VERTEX * ROT)
  translate([0, 0, TETRAHEDRON_VERTEX_OUTER_DEPTH_OFFSET])
  // minus inner polygon
  translate([0, 0, INFINITESIMAL])
  rounded_polygon(
    num_sides = TETRAHEDRON_VERTEX_SIDES,
    depth = TETRAHEDRON_VERTEX_OUTER_DEPTH + 3 * INFINITESIMAL,
    radius = TETRAHEDRON_VERTEX_INNER_RADIUS,
    corner_radius = TETRAHEDRON_VERTEX_CORNER_RADIUS
  );
}

module edge_plate () {
  rotate(a = [0, 0, (1 / 2 * EDGES_PER_TETRAHEDRON_VERTEX) * ROT])
  // polygon
  rounded_polygon(
    num_sides = TETRAHEDRON_VERTEX_EDGE_SIDES,
    depth = TETRAHEDRON_VERTEX_EDGE_OUTER_DEPTH,
    radius = TETRAHEDRON_VERTEX_EDGE_OUTER_RADIUS,
    corner_radius = TETRAHEDRON_VERTEX_EDGE_CORNER_RADIUS
  );
}

module edge_gap () {
  rotate(a = [0, 0, (1 / 2 * EDGES_PER_TETRAHEDRON_VERTEX) * ROT])
  // minus inner polygon
  translate([0, 0, INFINITESIMAL])
  rounded_polygon(
    num_sides = TETRAHEDRON_VERTEX_EDGE_SIDES,
    depth = TETRAHEDRON_VERTEX_EDGE_OUTER_DEPTH + 3 * INFINITESIMAL,
    radius = TETRAHEDRON_VERTEX_EDGE_INNER_RADIUS,
    corner_radius = TETRAHEDRON_VERTEX_EDGE_CORNER_RADIUS
  );
}

module edge_plate_negatives () {
  // subtract the space that would interfere with the edge connectors
  for_each_radial(
    num_steps = EDGES_PER_TETRAHEDRON_VERTEX,
    radius = TETRAHEDRON_VERTEX_EDGES_RADIUS
  ) {
    rotate(a = [0, TETRAHEDRON_VERTEX_EDGE_ANGLE])
    rotate([0, 0, (1 / 2 * EDGES_PER_TETRAHEDRON_VERTEX) * ROT])
    translate([(-1/2) * INFINITY, (-1/2) * INFINITY, (1/2) * TETRAHEDRON_VERTEX_EDGE_OUTER_DEPTH - INFINITESIMAL])
    cube(INFINITY);
  }
}

module edge_bolts () {
  // minus bolts
  rotate(a = [0, 0, (1 / 2 * EDGES_PER_TETRAHEDRON_VERTEX) * ROT])
  for_each_radial(
    start_step = 1,
    num_steps = EDGES_PER_TETRAHEDRON_VERTEX,
    radius = TETRAHEDRON_VERTEX_EDGE_BOLTS_RADIUS
  ) {
    translate([0, 0, - (1/2) * TETRAHEDRON_VERTEX_EDGE_BOLT_LENGTH])
    bolt_hole(
      size = TETRAHEDRON_VERTEX_EDGE_BOLT_SIZE,
      length = TETRAHEDRON_VERTEX_EDGE_BOLT_LENGTH,
      tolerance = TETRAHEDRON_VERTEX_EDGE_BOLT_TOLERANCE
    );
  }
}

module edge_between () {
  rotate(a = [0, 0, (1 / 4 * EDGES_PER_TETRAHEDRON_VERTEX) * ROT])
  translate([0, 0, TETRAHEDRON_VERTEX_EDGE_BETWEEN_DEPTH_OFFSET])
  difference () {
    // polygon
    rounded_box(
      size = [TETRAHEDRON_VERTEX_EDGE_BETWEEN_WIDTH, TETRAHEDRON_VERTEX_EDGE_BETWEEN_HEIGHT, TETRAHEDRON_VERTEX_EDGE_BETWEEN_DEPTH],
      radius = TETRAHEDRON_VERTEX_EDGE_CORNER_RADIUS
    );
  }
}
