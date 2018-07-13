echo(version=version());

include <constants.scad>
include <nuts-and-bolts.scad>

EDGES_PER_VERTEX = 3;
SOCKET_OFFSET = 1;
SOCKET_HEIGHT = 30;
SOCKET_RADIUS = 10;
SCREW_SIZE = 5;
SCREW_LENGTH = SOCKET_RADIUS * 2 + 1;
SCREW_OFFSET = SOCKET_HEIGHT - 10;
PLUG_RADIUS = 6;
CAP_RADIUS= SOCKET_RADIUS;
CAP_OFFSET = 0;

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
    //positive_z();
  
    union () {
      translate(
        [
          0,
          0,
          CAP_OFFSET
        ]
      )
      sphere(
        r = CAP_RADIUS,
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
            SOCKET_OFFSET
          ]
        )
        socket();
      }
    };
  };
}

module socket () {
  screw_cap_height = METRIC_NUT_THICKNESS[SCREW_SIZE];
  
  difference () {
    union () {
      cylinder(
        r = SOCKET_RADIUS,
        h = SOCKET_HEIGHT,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );
      
      translate(
        [
          0,
          -SCREW_LENGTH + 3.5 * screw_cap_height,
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
      cylinder(
        r = SCREW_SIZE + 1,
        h = screw_cap_height,
        $fn = 6
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
      cylinder(
        r = SCREW_SIZE + 1,
        h = screw_cap_height,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );
    };
    
    cylinder(
      r = PLUG_RADIUS,
      h = SOCKET_HEIGHT + INFINITESIMAL,
      $fa = MIN_ARC_FRAGMENT_ANGLE,
      $fs = MIN_ARC_FRAGMENT_SIZE
    );
    
    translate(
      [
        0,
        (1/2) * (SCREW_LENGTH - screw_cap_height),
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
    
    translate(
      [
        0,
        -SCREW_LENGTH + 3 * screw_cap_height,
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
    nut_hole(
      size = SCREW_SIZE
    );
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