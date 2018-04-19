echo(version=version());

ROT=360;
INFINITESIMAL = 0.01;

EDGES_PER_VERTEX = 3;
CHANNEL_DEPTH = 10;
CHANNEL_TOLERANCE = 1;
CHANNEL_LENGTH = 16 + CHANNEL_TOLERANCE;
ROD_RADIUS = 2;
ARM_OFFSET = 20;
ARM_HEIGHT= 30;
ARM_RADIUS = CHANNEL_LENGTH + 3;
CAP_RADIUS=ARM_RADIUS + 2;

FILAMENT_WIDTH = 3;
MIN_ARC_FRAGMENT_ANGLE = 6;
MIN_ARC_FRAGMENT_SIZE = FILAMENT_WIDTH / 2;

// sin(phi) = x
// sin^-1(x) = phi

// h^2 + (1/2)^2 = 1^2
// h = sqrt(3) / 2

// h = x + w

// tan(30) = w / (1/2)
// w = (1/2)tan(30)

// phi = sin^-1((sqrt(3)/2) - (1/2)tan(30))

arm_theta = 35.26439;

// 30 from vertical
// 120 around vertical axis
// 120 again

// nominate an axis as the pole
// rotate your point towards the normal = latitude
// rotate around the pole = longitude

for (arm_index = [0 : EDGES_PER_VERTEX]) {
  arm_phi = arm_index * (ROT / EDGES_PER_VERTEX);
    
  rotate(
    a = [
      0,
      arm_theta,
      arm_phi
    ]
  )
  translate(
    [
      0,
      0,
      ARM_OFFSET
    ]
  )
  difference () {
    cylinder(
      r = ARM_RADIUS + ROD_RADIUS,
      h = ARM_HEIGHT,
      $fa = MIN_ARC_FRAGMENT_ANGLE,
      $fs = MIN_ARC_FRAGMENT_SIZE
    );
        
    for (i = [0 : 2]) {
      rotate(
        a = [
          0,
          0,
          (1/3) * ROT * i + (3/8) * ROT
        ]
      )
      union () {
        translate(
          [
            ROD_RADIUS,
            ROD_RADIUS,
            ARM_HEIGHT - CHANNEL_DEPTH
          ]
        )
        linear_extrude(
          height = CHANNEL_DEPTH + INFINITESIMAL
        )
        channel_shape(
          width = CHANNEL_LENGTH
        );
        
        translate(
          [
            ROD_RADIUS,
            ROD_RADIUS,
            -INFINITESIMAL
          ]
        )
        linear_extrude(
          height = (ARM_HEIGHT - CHANNEL_DEPTH) + 2 * INFINITESIMAL
        )
        led_shape(
          width = CHANNEL_LENGTH
        );
      };
    }
  };
}

module channel_shape (width) {
  intersection () {
    square(CHANNEL_LENGTH);
    circle(
      r = CHANNEL_LENGTH,
      $fa = MIN_ARC_FRAGMENT_ANGLE,
      $fs = MIN_ARC_FRAGMENT_SIZE
    );
  };
}

module led_shape (width) {
  intersection () {
    channel_shape(
      width = CHANNEL_LENGTH
    );
    
    translate(
      [
        CHANNEL_LENGTH,
        CHANNEL_LENGTH
      ]
    )
    rotate((1/8) * ROT)
    square(
      CHANNEL_LENGTH * 2,
      center = true
    );
  };
}