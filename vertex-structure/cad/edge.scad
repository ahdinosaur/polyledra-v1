include <constants.scad>
include <helpers.scad>
include <nuts-and-bolts.scad>

echo(version=version());

CHANNELS_PER_EDGE = 3;
CHANNEL_LENGTH_XY = 16 + XY_TOLERANCE;
CHANNEL_LENGTH_Z = 8 + Z_TOLERANCE;
CHANNELS_RADIUS = 2;

HEADER_PITCH = 2.54;
HEADER_NUM_PINS = 4;
HEADER_LENGTH_X = HEADER_PITCH * HEADER_NUM_PINS + XY_TOLERANCE;
HEADER_LENGTH_Y = 2.54 + XY_TOLERANCE;
HEADER_LENGTH_Z = 2.54 + Z_TOLERANCE;
HEADERS_RADIUS = CHANNEL_LENGTH_XY / 2 + CHANNELS_RADIUS;

EDGE_CONNECTOR_SIDES = CHANNELS_PER_EDGE * 2;
EDGE_CONNECTOR_RADIUS = CHANNEL_LENGTH_XY + CHANNELS_RADIUS + 4;
EDGE_CONNECTOR_LENGTH_Z = CHANNEL_LENGTH_Z + HEADER_LENGTH_Z;

BOLT_SIZE = 4;
BOLT_LENGTH = EDGE_CONNECTOR_LENGTH_Z - 2;
BOLT_RADIUS = EDGE_CONNECTOR_RADIUS / 2;
BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[BOLT_SIZE] / 2;
BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[BOLT_SIZE];

main();

module main () {
  echo(
    edge_connector_radius=EDGE_CONNECTOR_RADIUS
  );
  edge();
}

module edge () {
  difference () {
    linear_extrude(
      height = EDGE_CONNECTOR_LENGTH_Z
    )
    rotate(ROT / (EDGE_CONNECTOR_SIDES * 2))
    polygon(ngon(EDGE_CONNECTOR_SIDES, EDGE_CONNECTOR_RADIUS));

    bolts();
    channels();
    headers();
  }
}

module bolts () {
  for_each_radial(
    start_step = 1,
    num_steps = CHANNELS_PER_EDGE,
    radius = BOLT_RADIUS,
    radial_offset = (1/2) * ROT
  ) {
    translate([0, 0, EDGE_CONNECTOR_LENGTH_Z + INFINITESIMAL])
    rotate([0, 1/2 * ROT, 0])
    bolt_hole(
      size = BOLT_SIZE,
      length = BOLT_LENGTH
    );
  };
}

module channels () {
  for_each_radial(
    num_steps = CHANNELS_PER_EDGE,
    radius = CHANNELS_RADIUS,
    radial_offset = 0,
    rotation_offset = (-1/8) * ROT
  ) {
    channel();
  };
}

module channel () {
  translate(
    [
      0,
      0,
      EDGE_CONNECTOR_LENGTH_Z - CHANNEL_LENGTH_Z
    ]
  )
  linear_extrude(
    height = CHANNEL_LENGTH_Z + INFINITESIMAL
  )
  channel_shape(
    length = CHANNEL_LENGTH_XY
  );
}

module headers () {
  for_each_radial(
    num_steps = CHANNELS_PER_EDGE,
    radius = HEADERS_RADIUS,
    radial_offset = 0,
    rotation_offset = (1/4) * ROT
  ) {
    header();
  };
}

module header () {
    translate(
    [
      0,
      0,
      -INFINITESIMAL
    ]
  )
  linear_extrude(
    height = HEADER_LENGTH_Z + 2 * INFINITESIMAL
  )
  header_shape();
}

module header_shape () {
  square(
    size = [
      HEADER_LENGTH_X,
      HEADER_LENGTH_Y
    ],
    center = true
  );
}

module channel_shape (length) {
  intersection () {
    square(length);
    
    circle(
      r = length,
      $fa = MIN_ARC_FRAGMENT_ANGLE,
      $fs = MIN_ARC_FRAGMENT_SIZE
    );
  };
}