echo(version=version());

ROT=360;
INFINITESIMAL = 0.01;

CHANNEL_DEPTH = 18;
CHANNEL_TOLERANCE = 0.5;
CHANNEL_LENGTH = 16 + CHANNEL_TOLERANCE;
ROD_RADIUS = 2;
ARM_OFFSET = 10;
ARM_HEIGHT= 40;
ARM_RADIUS = CHANNEL_LENGTH + 3;
BEYOND = 100;

FILAMENT_WIDTH = 3;
MIN_ARC_FRAGMENT_ANGLE = 6;
MIN_ARC_FRAGMENT_SIZE = FILAMENT_WIDTH / 2;

main();

module main () {
  difference () {
    cylinder(
        r = ARM_RADIUS + ROD_RADIUS,
        h = ARM_HEIGHT,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );
    arm();
  };
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
      height = CHANNEL_DEPTH + INFINITESIMAL + BEYOND
    )
    channel_shape(
      length = CHANNEL_LENGTH
    );
    
    translate(
      [
        ROD_RADIUS,
        ROD_RADIUS,
        -BEYOND
      ]
    )
    linear_extrude(
      height = (ARM_HEIGHT - CHANNEL_DEPTH) + 2 * BEYOND
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
      -BEYOND / 2,
      -BEYOND / 2,,
      0
    ]
  )
  cube(BEYOND);
}