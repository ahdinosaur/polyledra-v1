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
BOLT_LENGTH = 10;
BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[BOLT_SIZE] / 2;
BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[BOLT_SIZE];
BOLT_TOLERANCE = (XY_TOLERANCE / 4) + (Z_TOLERANCE / 4);

// x is length
// y is thickness
// z is height


EDGE_CONNECTOR_ANGLE = 35.26439;

EDGE_BOLTS_DISTANCE = 14.775;
EDGE_CONNECTOR_THICKNESS = 6;
EDGE_CONNECTOR_LENGTH = 30;
EDGE_CONNECTOR_MARGIN = 1;
EDGE_CONNECTOR_OFFSET = 10;
EDGE_CONNECTOR_BOLT_SIZE = BOLT_SIZE;

VERTEX_BOLTS_DISTANCE = EDGE_BOLTS_DISTANCE;
VERTEX_CONNECTOR_THICKNESS = EDGE_CONNECTOR_THICKNESS;
VERTEX_CONNECTOR_LENGTH = EDGE_CONNECTOR_LENGTH;
VERTEX_CONNECTOR_MARGIN = EDGE_CONNECTOR_MARGIN;
VERTEX_CONNECTOR_OFFSET = EDGE_CONNECTOR_OFFSET;
VERTEX_CONNECTOR_BOLT_SIZE = EDGE_CONNECTOR_BOLT_SIZE;

main();

module main () {
  tetrahedron_angle();
}

module tetrahedron_angle () {
  difference () {
    union () {
      rotate(EDGE_CONNECTOR_ANGLE)
      rotate((1/2) * ROT)
      edge_connector();

      vertex_connector();
    }
    


    union () {
      rotate(EDGE_CONNECTOR_ANGLE)
      edge_connector_negative();
      
      vertex_connector_negative();
    }
  }
}

module edge_connector () {
  connector(
    length = EDGE_CONNECTOR_LENGTH,
    distance = EDGE_BOLTS_DISTANCE,
    bolt_size = EDGE_CONNECTOR_BOLT_SIZE,
    thickness = EDGE_CONNECTOR_THICKNESS,
    margin = EDGE_CONNECTOR_MARGIN,
    offset = EDGE_CONNECTOR_OFFSET
  );
}

module edge_connector_negative () {
  connector_negative(
    thickness = EDGE_CONNECTOR_THICKNESS
  );
}

module vertex_connector () {
  connector(
    length = VERTEX_CONNECTOR_LENGTH,
    distance = VERTEX_BOLTS_DISTANCE,
    bolt_size = VERTEX_CONNECTOR_BOLT_SIZE,
    thickness = VERTEX_CONNECTOR_THICKNESS,
    margin = VERTEX_CONNECTOR_MARGIN,
    offset = VERTEX_CONNECTOR_OFFSET
  );
}

module vertex_connector_negative () {
  connector_negative(
    thickness = VERTEX_CONNECTOR_THICKNESS
  );
}

module connector (
  length,
  distance,
  bolt_size = 4,
  thickness = NOZZLE_WIDTH * 4,
  length_margin = 0,
  offset = 0
) {
  width = length + bolt_size + 2 * margin + offset;
  height = distance + 2 * bolt_size + 2 * margin;
  
  // translate([(-1/2) * length + offset, 0, 0])
  translate([(1/2) * (length - offset), 0, 0])
  // triangle
  rotate(a = [(1/4) * ROT, (0/8) * ROT, (4/8) * ROT])
  difference () {
    right_triangle(
      a = width,
      b = height,
      corner_radius = bolt_size,
      height = thickness
    );
    
    translate([
      BOLT_SIZE,
      0
    ])
    translate([
      margin,
      margin
    ])
    translate([
      - width / 2,
      - height / 2,
      - (1/2) * BOLT_LENGTH
    ])
    union () {
      translate([0, distance, 0])
      bolt_hole(
        size = BOLT_SIZE,
        length = BOLT_LENGTH,
        tolerance = XY_TOLERANCE
      );

      bolt_hole(
        size = BOLT_SIZE,
        length = BOLT_LENGTH,
        tolerance = XY_TOLERANCE
      );
    }
  }
}

module connector_negative (
  thickness
) {
  translate(
    [
      0,
      thickness + (INFINITY / 2) + INFINITESIMAL
    ]
  )
  cube(
    [
      INFINITY,
      thickness + INFINITY,
      INFINITY
    ],
    center = true
  );
}