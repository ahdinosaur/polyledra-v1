include <constants.scad>
include <nuts-and-bolts.scad>

echo(version=version());

CHANNEL_DEPTH = 18;
CHANNEL_TOLERANCE = 0.5;
CHANNEL_LENGTH = 16 + CHANNEL_TOLERANCE;
ROD_RADIUS = 2;
ARM_OFFSET = 10;
ARM_HEIGHT= 30;
ARM_RADIUS = CHANNEL_LENGTH + 3;
PLUG_HEIGHT = 20;
PLUG_RADIUS = 6;
SCREW_SIZE = 5;
SCREW_LENGTH = INFINITY;
SCREW_OFFSET = 10;

main();

module main () {
  union () {
    translate(
      [
        0,
        0,
        PLUG_HEIGHT
      ]
    )
    edge_connector();
    
    plug();
  }
}

module plug () {
  difference () {
    cylinder(
        r = PLUG_RADIUS,
        h = PLUG_HEIGHT,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );
    
      translate(
        [
          0,
          (1/2) * SCREW_LENGTH,
          SCREW_OFFSET
        ]
      )
      rotate(
        a = [
          (1/4) * ROT,
          0,
          0
        ]
      )
      bolt_hole(
        size = SCREW_SIZE,
        length = SCREW_LENGTH
      );
  }
}

module edge_connector () {
  difference () {
    cylinder(
        r = ARM_RADIUS + ROD_RADIUS,
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
        ROD_RADIUS,
        ROD_RADIUS,
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
        ROD_RADIUS,
        ROD_RADIUS,
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