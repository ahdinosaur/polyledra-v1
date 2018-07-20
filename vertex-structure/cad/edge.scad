include <constants.scad>
include <nuts-and-bolts.scad>

echo(version=version());

CHANNEL_DEPTH = 10;
CHANNEL_TOLERANCE = 0.5;
CHANNEL_LENGTH = 16 + CHANNEL_TOLERANCE;
ARM_OFFSET = 10;
ARM_HEIGHT= 20;
ARM_RADIUS = CHANNEL_LENGTH + 3;
BOLT_SIZE = 4;
BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[BOLT_SIZE] / 2;
BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[BOLT_SIZE];

main();

module main () {
  difference () {
    edge_connector();
    
    translate([0, 0, -INFINITESIMAL])
    bolt_hole(
      size = BOLT_SIZE,
      length = INFINITY
    );
  }
}

module edge_connector () {
  difference () {
    cylinder(
        r = ARM_RADIUS + BOLT_CAP_RADIUS,
        h = ARM_HEIGHT,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );
    arm();
  }
}

module arm () {
  difference () {

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
    translate(
      [
        BOLT_CAP_RADIUS,
        BOLT_CAP_RADIUS,
        ARM_HEIGHT - CHANNEL_DEPTH
      ]
    )
    linear_extrude(
      height = CHANNEL_DEPTH + INFINITESIMAL + INFINITY
    )
    channel_shape(
      length = CHANNEL_LENGTH
    );
    
    translate(
      [
        BOLT_CAP_RADIUS,
        BOLT_CAP_RADIUS,
        -INFINITY
      ]
    )
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