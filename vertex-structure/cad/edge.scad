include <constants.scad>
include <nuts-and-bolts.scad>

echo(version=version());

CHANNELS_PER_EDGE = 3;
CHANNEL_DEPTH = 8;
CHANNEL_TOLERANCE = 0.5;
CHANNEL_LENGTH = 16 + CHANNEL_TOLERANCE;
CHANNEL_RADIUS = 2;

HEADER_DEPTH = 2.5;
HEADER_PITCH = 2.54;
HEADER_NUM_PINS = 4;
HEADER_LENGTH = HEADER_PITCH * HEADER_NUM_PINS + 0.1;
HEADER_WIDTH = 2.5;
HEADER_RADIUS = CHANNEL_LENGTH / 2 + CHANNEL_RADIUS;

EDGE_CONNECTOR_SIDES = CHANNELS_PER_EDGE * 2;
EDGE_CONNECTOR_RADIUS = CHANNEL_LENGTH + CHANNEL_RADIUS + 4;
EDGE_CONNECTOR_HEIGHT = CHANNEL_DEPTH + HEADER_DEPTH;

HOLE_WIDTH_START = 2;
HOLE_WIDTH_END = 6.5;
HOLE_OFFSET = CHANNEL_RADIUS;
HOLE_WIDTH_LENGTH = 1/2 * EDGE_CONNECTOR_RADIUS;

BOLT_SIZE = 4;
BOLT_LENGTH = 35;
BOLT_RADIUS = EDGE_CONNECTOR_RADIUS / 2;
BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[BOLT_SIZE] / 2;
BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[BOLT_SIZE];

main();

// Simple list comprehension for creating N-gon vertices
function ngon(num, r) = [for (i=[0:num-1], a=i*360/num) [ r*cos(a), r*sin(a) ]];

module main () {
  // echo(arm_radius = ARM_RADIUS, bolt_offset = BOLT_OFFSET);
  // polygon(ngon(3, 25));
  
  edge();
}

module edge () {
  difference () {
    linear_extrude(
      height = EDGE_CONNECTOR_HEIGHT
    )
    rotate(ROT / (EDGE_CONNECTOR_SIDES * 2))
    polygon(ngon(EDGE_CONNECTOR_SIDES, EDGE_CONNECTOR_RADIUS));

    bolts();
    channels();
    headers();
  }
}

//         x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4 + 1/3) * 2 * Math.PI),
//        y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4 + 1/3) * 2 * Math.PI),
//        angle: (-1/4 + 1/3) * 360 + 180
//

module for_each_radial (
  start_step = 0,
  num_steps,
  radius,
  radial_offset = 0,
  rotation_offset = 0
) {
  for (index = [start_step : num_steps - 1]) {
    angle = index * (ROT / num_steps);
    radial = angle + radial_offset;
    rotation = angle + rotation_offset;

    translate([
      radius * cos(radial),
      radius * sin(radial),
      0
    ])
    rotate(rotation)
    children();
  }
}

module bolts () {
  for_each_radial(
    start_step = 1,
    num_steps = CHANNELS_PER_EDGE,
    radius = BOLT_RADIUS,
    radial_offset = (1/2) * ROT
  ) {
    translate([0, 0, EDGE_CONNECTOR_HEIGHT + INFINITESIMAL])
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
    radius = CHANNEL_RADIUS,
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
      EDGE_CONNECTOR_HEIGHT - CHANNEL_DEPTH
    ]
  )
  linear_extrude(
    height = CHANNEL_DEPTH + INFINITESIMAL
  )
  channel_shape(
    length = CHANNEL_LENGTH
  );
}

module headers () {
  for_each_radial(
    num_steps = CHANNELS_PER_EDGE,
    radius = HEADER_RADIUS,
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
    height = HEADER_DEPTH + 2 * INFINITESIMAL
  )
  header_shape();
}

module header_shape () {
  //rotate(3/8 * ROT)
  //translate([
  //  -1/2 * HEADER_LENGTH,
  //   - HEADER_WIDTH - HEADER_OFFSET
  //])
  square(
    size = [
      HEADER_LENGTH,
      HEADER_WIDTH
    ],
    center = true
  );
}

module channel_shape (length) {
  /*
  translate([
    -length / 2,
    -length / 2
  ])
  */
  intersection () {
    square(length);
    
    circle(
      r = length,
      $fa = MIN_ARC_FRAGMENT_ANGLE,
      $fs = MIN_ARC_FRAGMENT_SIZE
    );
  };
}