include <constants.scad>
include <nuts-and-bolts.scad>

echo(version=version());

CHANNELS_PER_ARM = 3;
// CHANNEL_DEPTH = 2;
CHANNEL_DEPTH = 18;
CHANNEL_TOLERANCE = 0.5;
CHANNEL_LENGTH = 16 + CHANNEL_TOLERANCE;
CHANNEL_OFFSET = 2;

HEADER_DEPTH = 2.5;
HEADER_PITCH = 2.54;
HEADER_NUM_PINS = 4;
HEADER_LENGTH = HEADER_PITCH * HEADER_NUM_PINS + 0.1;
HEADER_WIDTH = 2.5;
HEADER_OFFSET = 8;

CONNECTOR_HEIGHT= CHANNEL_DEPTH + HEADER_DEPTH;
CONNECTOR_RADIUS = CHANNEL_LENGTH + CHANNEL_OFFSET + 3;

HOLE_WIDTH_START = 2;
HOLE_WIDTH_END = 6.5;
HOLE_OFFSET = CHANNEL_OFFSET;
HOLE_WIDTH_LENGTH = 1/2 * CONNECTOR_RADIUS;

BOLT_SIZE = 4;
BOLT_LENGTH = 35;
BOLT_OFFSET = CONNECTOR_RADIUS / 2;
BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[BOLT_SIZE] / 2;
BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[BOLT_SIZE];

main();

// Simple list comprehension for creating N-gon vertices
function ngon(num, r) = [for (i=[0:num-1], a=i*360/num) [ r*cos(a), r*sin(a) ]];

module main () {
  echo(arm_radius = CONNECTOR_RADIUS, bolt_offset = BOLT_OFFSET);
  //polygon(ngon(3, 25));
  
  edge();
}

module edge () {
  difference () {
    cylinder(
        r = CONNECTOR_RADIUS,
        h = CONNECTOR_HEIGHT,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
    );
    
    //utility_hole();
    bolts();
    channels();
  }
}

module utility_hole () {
  translate([HOLE_OFFSET, 0, -1/2 * INFINITY])
  hull () {
    translate([0, -1/2 * HOLE_WIDTH_START, 0])
    cube([HOLE_WIDTH_LENGTH, HOLE_WIDTH_START, INFINITY]);
    
    translate([0, -1/2 * HOLE_WIDTH_END, 0])
    translate([HOLE_WIDTH_LENGTH, 0, 0])
    cube([INFINITESIMAL, HOLE_WIDTH_END, INFINITY]);
  }
}

module bolts () {
  for (screw_index = [1 : CHANNELS_PER_ARM - 1]) {
    screw_phi = screw_index * (ROT / CHANNELS_PER_ARM);

    translate([
      BOLT_OFFSET*cos(screw_phi),
      BOLT_OFFSET*sin(screw_phi),
      0 //- (1/2) * BOLT_LENGTH
    ])
    translate([0, 0, CONNECTOR_HEIGHT + INFINITESIMAL])
    rotate([0, 1/2 * ROT, 0])
    bolt_hole(
      size = BOLT_SIZE,
      length = BOLT_LENGTH
    );
  }
}

module channels () {
  union () {
    for (i = [0 : 2]) {
      rotate(
        a = [
          0,
          0,
          (1/3) * ROT * i + (3/8) * ROT
        ]
      )
      channel();
    }
  };
}

module channel () {
  union () {
    // front entry
    translate(
      [
        CHANNEL_OFFSET,
        CHANNEL_OFFSET,
        CONNECTOR_HEIGHT - CHANNEL_DEPTH
      ]
    )
    linear_extrude(
      height = CHANNEL_DEPTH + INFINITESIMAL
    )
    channel_shape(
      length = CHANNEL_LENGTH
    );
    
    // back stopper (with header)
    translate(
      [
        CHANNEL_OFFSET,
        CHANNEL_OFFSET,
        -INFINITESIMAL
      ]
    )
    linear_extrude(
      height = HEADER_DEPTH + 2 * INFINITESIMAL
    )
    header_shape();
  };
}

module header_shape () {
  rotate(3/8 * ROT)
  translate([
    -1/2 * HEADER_LENGTH,
     - HEADER_WIDTH - HEADER_OFFSET
  ])
  square(
    size = [
      HEADER_LENGTH,
      HEADER_WIDTH
    ]
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

module channel_led_shape (length) {
  intersection () {
    channel_shape(
      length = length
    );
    
    translate(
      [
        length,
        length
      ]
    )
    rotate((1/8) * ROT)
    square(
      length * 2,
      center = true
    );
  };
}


module positive_z () {
  translate(
    [
      -INFINITY / 2,
      -INFINITY / 2,,
      0
    ]
  )
  cube(INFINITY);
}