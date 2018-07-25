include <constants.scad>
include <nuts-and-bolts.scad>

echo(version=version());

CHANNELS_PER_ARM = 3;
CHANNEL_DEPTH = 18;
CHANNEL_TOLERANCE = 0.5;
CHANNEL_LENGTH = 16 + CHANNEL_TOLERANCE;
CHANNEL_OFFSET = 5;

ARM_HEIGHT= CHANNEL_DEPTH + 2;
ARM_RADIUS = CHANNEL_LENGTH + CHANNEL_OFFSET + 3;

BOLT_SIZE = 4;
BOLT_LENGTH = 35;
BOLT_OFFSET = ARM_RADIUS / 2;
BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[BOLT_SIZE] / 2;
BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[BOLT_SIZE];

HOLE_RADIUS = 5;

main();

// Simple list comprehension for creating N-gon vertices
function ngon(num, r) = [for (i=[0:num-1], a=i*360/num) [ r*cos(a), r*sin(a) ]];

module main () {
  echo(arm_radius = ARM_RADIUS, bolt_offset = BOLT_OFFSET);
  //polygon(ngon(3, 20));
  
  arm();
}

module arm () {
  union () {
    cylinder(
        r = ARM_RADIUS,
        h = ARM_HEIGHT,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
    );
    
    hole();
    bolts();
    channels();
  }
}

module hole () {
  translate([0, 0, -(1/2) * INFINITY])
  cylinder(
    r = HOLE_RADIUS,
    h = INFINITY
  );
}

module bolts () {
  for (screw_index = [1 : CHANNELS_PER_ARM - 1]) {
    screw_phi = screw_index * (ROT / CHANNELS_PER_ARM);

    translate([
      BOLT_OFFSET*cos(screw_phi),
      BOLT_OFFSET*sin(screw_phi),
      0 //- (1/2) * BOLT_LENGTH
    ])
    translate([0, 0, ARM_HEIGHT + INFINITESIMAL])
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
        ARM_HEIGHT - CHANNEL_DEPTH
      ]
    )
      rotate([0, 0, 1/4* ROT])
    linear_extrude(
      height = CHANNEL_DEPTH + INFINITESIMAL + INFINITY
    )
    channel_shape(
      length = CHANNEL_LENGTH
    );
    
    // back stopper
    translate(
      [
        CHANNEL_OFFSET,
        CHANNEL_OFFSET,
        -INFINITY
      ]
    )
          rotate([0, 0, 1/4* ROT])

    linear_extrude(
      height = (ARM_HEIGHT - CHANNEL_DEPTH) + 2 * INFINITY
    )
    channel_led_shape(
      length = CHANNEL_LENGTH
     );
  };
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