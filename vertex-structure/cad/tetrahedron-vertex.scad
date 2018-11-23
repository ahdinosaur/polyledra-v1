echo(version=version());

include <constants.scad>
include <helpers.scad>
include <nuts-and-bolts.scad>

EDGES_PER_VERTEX = 3;
EDGES_RADIUS = 24;
EDGE_ANGLE = 35.26439;

EDGE_BOLT_SIZE = 4;
EDGE_BOLT_LENGTH = INFINITY;
EDGE_BOLT_TOLERANCE = (3/4) * TOLERANCE;

EDGE_SIDES = 3;
EDGE_BOLTS_RADIUS = 30;
EDGE_OUTER_RADIUS = EDGE_BOLTS_RADIUS + 4;
EDGE_INNER_RADIUS = EDGE_OUTER_RADIUS - EDGE_BOLT_SIZE * 2 - 10;
EDGE_MARGIN = 2;
EDGE_DEPTH = 8;
EDGE_CORNER_RADIUS = EDGE_BOLT_SIZE;

VERTEX_BOLT_SIZE = 4;
VERTEX_BOLT_LENGTH = INFINITY;
VERTEX_BOLT_TOLERANCE = TOLERANCE;

VERTEX_SIDES = EDGES_PER_VERTEX;
VERTEX_OUTER_RADIUS = EDGES_RADIUS + 4;
VERTEX_INNER_RADIUS = VERTEX_OUTER_RADIUS - EDGE_BOLT_SIZE * 2 - 5;
VERTEX_DEPTH = 10;
VERTEX_DEPTH_OFFSET = 5;
VERTEX_CORNER_RADIUS = VERTEX_BOLT_SIZE;

MAX_Z = VERTEX_DEPTH_OFFSET + (VERTEX_DEPTH / 2);

/*
HEADER_NUM_PINS = 4;
HEADER_PITCH = 2.54;
HEADER_X_LENGTH = HEADER_PITCH * (HEADER_NUM_PINS * + 0.4) + 0.25;
HEADER_Y_LENGTH = 2.4;
HEADER_Z_LENGTH = 8.5;
HEADER_Y_OFFSET = 2;
*/

// rotate([0, 180, 0])
main();

module main () {
  intersection () {
    below_z(z = MAX_Z);
    
    difference () {
      union () {
        vertex_plate();
        for_each_radial(
          num_steps = EDGES_PER_VERTEX,
          radius = EDGES_RADIUS
        ) {
          rotate(a = [0, EDGE_ANGLE])
          edge_plate();
        }
      };
      
      vertex_gap();
    }
  }
}

module vertex_plate () {
  difference () {
    // polygon
    rotate((1 / 2) * EDGES_PER_VERTEX * ROT)
    translate([0, 0, VERTEX_DEPTH_OFFSET])
    difference () {
      rounded_polygon(
        num_sides = VERTEX_SIDES,
        depth = VERTEX_DEPTH,
        radius = VERTEX_OUTER_RADIUS,
        corner_radius = VERTEX_CORNER_RADIUS
      );
    }
    
    // subtract the space that would interfere with the edge connectors
    for_each_radial(
      num_steps = EDGES_PER_VERTEX,
      radius = EDGES_RADIUS
    ) {
      rotate(a = [0, EDGE_ANGLE])
      rotate([0, 0, (1 / 2 * EDGES_PER_VERTEX) * ROT])
      translate([(-1/2) * INFINITY, (-1/2) * INFINITY, (1/2) * EDGE_DEPTH - INFINITESIMAL])
      cube(INFINITY);
    }
  }
}

module vertex_gap () {
  rotate((1 / 2) * EDGES_PER_VERTEX * ROT)
  translate([0, 0, VERTEX_DEPTH_OFFSET])
  // minus inner polygon
  translate([0, 0, INFINITESIMAL])
  rounded_polygon(
    num_sides = VERTEX_SIDES,
    depth = VERTEX_DEPTH + 3 * INFINITESIMAL,
    radius = VERTEX_INNER_RADIUS,
    corner_radius = VERTEX_CORNER_RADIUS
  );
}
module edge_plate () {
  rotate(a = [0, 0, (1 / 2 * EDGES_PER_VERTEX) * ROT])
  difference () {
    // polygon
    rounded_polygon(
      num_sides = EDGE_SIDES,
      depth = EDGE_DEPTH,
      radius = EDGE_OUTER_RADIUS,
      corner_radius = EDGE_CORNER_RADIUS
    );
    
    // minus inner polygon
    translate([0, 0, INFINITESIMAL])
    rounded_polygon(
      num_sides = EDGE_SIDES,
      depth = EDGE_DEPTH + 3 * INFINITESIMAL,
      radius = EDGE_INNER_RADIUS,
      corner_radius = EDGE_CORNER_RADIUS
    );

    // minus bolts
    for_each_radial(
      start_step = 1,
      num_steps = EDGES_PER_VERTEX,
      radius = EDGE_BOLTS_RADIUS
    ) {
      translate([0, 0, - (1/2) * EDGE_BOLT_LENGTH])
      bolt_hole(
        size = EDGE_BOLT_SIZE,
        length = EDGE_BOLT_LENGTH,
        tolerance = EDGE_BOLT_TOLERANCE
      );
    }
  }
}