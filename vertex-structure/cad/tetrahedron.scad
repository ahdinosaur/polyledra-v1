echo(version=version());

ROT=360;
INFINITESIMAL = 0.01;

EDGES_PER_VERTEX = 3;
CHANNEL_DEPTH = 10;
CHANNEL_TOLERANCE = 1;
CHANNEL_LENGTH = 16 + CHANNEL_TOLERANCE;
ROD_RADIUS = 2;
ARM_HEIGHT= 50;
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
  
  echo(arm_theta, arm_phi);
    
  rotate(
    a = [
      0,
      arm_theta,
      arm_phi
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
          (1/3) * ROT * i
        ]
      )
      translate(
        [
          ROD_RADIUS,
          ROD_RADIUS,
          ARM_HEIGHT - CHANNEL_DEPTH
        ]
      )
      intersection () {
        cube(
          [
            CHANNEL_LENGTH,
            CHANNEL_LENGTH,
            CHANNEL_DEPTH + INFINITESIMAL
          ]
        );
        cylinder(
          r = CHANNEL_LENGTH,
          h = CHANNEL_DEPTH + INFINITESIMAL,
          $fa = MIN_ARC_FRAGMENT_ANGLE,
          $fs = MIN_ARC_FRAGMENT_SIZE
        );
      };
    }
  };
}

sphere(
  r = CAP_RADIUS,
  $fa = MIN_ARC_FRAGMENT_ANGLE,
  $fs = MIN_ARC_FRAGMENT_SIZE
);