include <constants.scad>
include <helpers.scad>
include <nuts-and-bolts.scad>

echo(version=version());

HEADER_PITCH = 2.54;
HEADER_NUM_PINS = 4;
HEADER_LENGTH_X = HEADER_PITCH * HEADER_NUM_PINS + XY_TOLERANCE;
HEADER_LENGTH_Y = 2.54 + XY_TOLERANCE;
HEADER_LENGTH_Z = 2.54 + Z_TOLERANCE;
EDGE_HEADER_OFFSET = 0;

BOLT_SIZE = 4;
BOLT_LENGTH = INFINITY;
BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[BOLT_SIZE] / 2;
BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[BOLT_SIZE];
BOLT_TOLERANCE = XY_TOLERANCE / 2;
BOLTS_RADIUS = 17.4937;

// x is width
// y is depth
// z is height


/*
EDGE_NUM_BOLTS = 2;
EDGE_PART_DEPTH = 15;
EDGE_PART_HEIGHT = 8;
VERTEX_BOLTS_DISTANCE = EDGE_BOLTS_DISTANCE;
VERTEX_PART_WIDTH = VERTEX_BOLTS_DISTANCE + 2;
VERTEX_PART_DEPTH = 15;
VERTEX_PART_HEIGHT = cos(EDGE_PART_ANGLE) * EDGE_PART_HEIGHT;
*/



// 
// z is width

EDGE_CONNECTOR_ANGLE = 35.26439;

EDGE_BOLTS_DISTANCE = 14.775;
EDGE_CONNECTOR_THICKNESS = 6;
EDGE_CONNECTOR_LENGTH = 20;
EDGE_CONNECTOR_MARGIN = 2;
EDGE_CONNECTOR_OFFSET = 4;
EDGE_CONNECTOR_HEIGHT = EDGE_BOLTS_DISTANCE + 2 * EDGE_CONNECTOR_MARGIN;
EDGE_CONNECTOR_CORNER_RADIUS = 0.01;

VERTEX_BOLTS_DISTANCE = EDGE_BOLTS_DISTANCE;
VERTEX_CONNECTOR_THICKNESS = EDGE_CONNECTOR_THICKNESS;
VERTEX_CONNECTOR_LENGTH = EDGE_CONNECTOR_LENGTH;
VERTEX_CONNECTOR_MARGIN = EDGE_CONNECTOR_MARGIN;
VERTEX_CONNECTOR_OFFSET = EDGE_CONNECTOR_OFFSET;
VERTEX_CONNECTOR_HEIGHT = VERTEX_BOLTS_DISTANCE + 2 * VERTEX_CONNECTOR_MARGIN;
VERTEX_CONNECTOR_CORNER_RADIUS = 0.01;


/*
EDGE_CONNECTOR_SIDES = EDGES_PER_VERTEX;
EDGE_PART_OFFSET = sin(EDGE_PART_ANGLE) * EDGE_CONNECTORS_RADIUS;

EDGE_CONNECTOR_SIDES = EDGES_PER_VERTEX;
EDGE_CONNECTOR_RADIUS = 30;
EDGE_CONNECTOR_LENGTH_Z = 8.5;
EDGE_CONNECTORS_RADIUS = 24;
*/

// VERTEX_PART_HEIGHT = cos(EDGE_PART_ANGLE) * EDGE_PART_HEIGHT;
// EDGE_PART_OFFSET = sin(EDGE_PART_ANGLE) * EDGE_CONNECTORS_RADIUS;

main();

module main () {
  tetrahedron_angle();
}

module tetrahedron_angle () {
  rotate(EDGE_CONNECTOR_ANGLE)
  rotate((1/2) * ROT)
  edge_connector();

  vertex_connector();
}

module edge_connector () {
  connector(
    length = EDGE_CONNECTOR_LENGTH,
    height = EDGE_CONNECTOR_HEIGHT,
    corner_radius = EDGE_CONNECTOR_CORNER_RADIUS,
    thickness = EDGE_CONNECTOR_THICKNESS,
    offset = EDGE_CONNECTOR_OFFSET
  );
}


module vertex_connector () {
  connector(
    length = VERTEX_CONNECTOR_LENGTH,
    height = VERTEX_CONNECTOR_HEIGHT,
    corner_radius = VERTEX_CONNECTOR_CORNER_RADIUS,
    thickness = VERTEX_CONNECTOR_THICKNESS,
    offset = VERTEX_CONNECTOR_OFFSET
  );
}

module connector (
  length,
  height,
  corner_radius = 0.01,
  thickness = NOZZLE_WIDTH * 4,
  offset = 0
) {
  translate([-length / 2 + offset, 0])
  union () {
    // triangle
    rotate(a = [(1/4) * ROT, (0/8) * ROT, (0/8) * ROT])
    //translate([(-1/2) * EDGE_CONNECTOR_LENGTH, -(1/2) * EDGE_CONNECTOR_HEIGHT, (-1/2) * EDGE_CONNECTOR_THICKNESS])
    right_triangle(
      a = length,
      b = height,
      corner_radius = corner_radius,
      height = thickness
    )
      
    for (bolt_index = [0: 1]) {
      translate([
        0,
        0,
        - (1/2) * BOLT_LENGTH
      ])
      bolt_hole(
        size = BOLT_SIZE,
        length = BOLT_LENGTH,
        tolerance = XY_TOLERANCE
      );
    }

/*
    // minus bolts
    //translate([0, -EDGE_CONNECTOR_RADIUS / 4, 0])
    //rotate(a = [0, (0/4) * ROT, (1/12) * ROT])
    union () {
      for_each_radial(
        start_step = 0,
        end_step = 2,
        num_steps = NUM_BOLTS,
        radius = BOLTS_RADIUS
      ) {
        translate([
          0,
          0,
          - (1/2) * BOLT_LENGTH
        ])

        bolt_hole(
          size = BOLT_SIZE,
          length = BOLT_LENGTH,
          tolerance = XY_TOLERANCE
        );
      }
    }
    */
  }
}