echo(version=version());

ROT=360;
INFINITESIMAL = 0.01;

EDGES_PER_VERTEX = 3;
CHANNEL_DEPTH = 18;
CHANNEL_TOLERANCE = 0.5;
CHANNEL_LENGTH = 16 + CHANNEL_TOLERANCE;
ROD_RADIUS = 2;
ARM_OFFSET = 20;
ARM_HEIGHT= 40;
ARM_RADIUS = CHANNEL_LENGTH + 3;
CAP_OUTER_RADIUS= 40;
CAP_OFFSET = 25;
CAP_INNER_RADIUS = 35;
BEYOND = 100;

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


main();

module main () {
  intersection () {
    positive_z();
  
    difference () {
      union () {
        translate(
          [
            0,
            0,
            CAP_OFFSET
          ]
        )
        sphere(
          r = CAP_OUTER_RADIUS,
          $fa = MIN_ARC_FRAGMENT_ANGLE,
          $fs = MIN_ARC_FRAGMENT_SIZE
        );
        
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
          cylinder(
            r = ARM_RADIUS + ROD_RADIUS,
            h = ARM_HEIGHT,
            $fa = MIN_ARC_FRAGMENT_ANGLE,
            $fs = MIN_ARC_FRAGMENT_SIZE
          );
        }
      };
    
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
        arm();
      }
      
      sphere(
        r = CAP_INNER_RADIUS,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );
    };
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