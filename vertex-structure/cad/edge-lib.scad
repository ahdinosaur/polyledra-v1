include <constants.scad>
include <helpers.scad>
include <nuts-and-bolts.scad>

CHANNELS_PER_EDGE = 3;
CHANNEL_SIDE_LENGTH = 15.5 + XY_TOLERANCE; // or 15.75
CHANNEL_HYPOTENUSE_LENGTH = sqrt(2 * pow(CHANNEL_SIDE_LENGTH, 2));
CHANNEL_HEIGHT = triangle_height(CHANNEL_HYPOTENUSE_LENGTH, CHANNEL_SIDE_LENGTH, CHANNEL_SIDE_LENGTH);
echo(channel_length_height = CHANNEL_HEIGHT); // = 11.63
// hyp with bulge: 17
CHANNEL_DEPTH = 10 + Z_TOLERANCE;
CHANNEL_GAP_LENGTH = CHANNEL_HYPOTENUSE_LENGTH - 2.50;
CHANNELS_RADIUS = 1.3;

EDGE_HEADER_PITCH = 2.54;
EDGE_HEADER_NUM_PINS = 4;
EDGE_HEADER_HEIGHT = EDGE_HEADER_PITCH + 2 * XY_TOLERANCE;
EDGE_HEADER_DEPTH = EDGE_HEADER_PITCH + 2 * Z_TOLERANCE;
EDGE_HEADERS_RADIUS = CHANNEL_SIDE_LENGTH / 2 + CHANNELS_RADIUS + 0.85; // 6.55

EDGE_SIDES = CHANNELS_PER_EDGE * 2;
EDGE_RADIUS = CHANNEL_SIDE_LENGTH + CHANNELS_RADIUS + 3;
EDGE_LENGTH_Z = CHANNEL_DEPTH + EDGE_HEADER_DEPTH;
EDGE_INRADIUS = polygon_inradius(
  circumradius = EDGE_RADIUS,
  sides = EDGE_SIDES
);
EDGE_SIDE_LENGTH = polygon_side_length(
  circumradius = EDGE_RADIUS,
  sides = EDGE_SIDES
);

EDGE_INNER_BOLT_SIZE = 3;
EDGE_INNER_BOLT_LENGTH = EDGE_LENGTH_Z - 2;
EDGE_INNER_BOLTS_RADIUS = 9;
EDGE_INNER_BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[EDGE_INNER_BOLT_SIZE] / 2;
EDGE_INNER_BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[EDGE_INNER_BOLT_SIZE];
EDGE_INNER_BOLT_TOLERANCE = 0.01;

EDGE_OUTER_BOLT_SIZE = 4;
EDGE_OUTER_BOLT_LENGTH = EDGE_LENGTH_Z + 3;
EDGE_OUTER_BOLTS_RADIUS = EDGE_INRADIUS;
EDGE_OUTER_BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[EDGE_OUTER_BOLT_SIZE] / 2;
EDGE_OUTER_BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[EDGE_OUTER_BOLT_SIZE];
EDGE_OUTER_BOLT_TOLERANCE = XY_TOLERANCE;

EDGE_SIDES_RADIUS = EDGE_INRADIUS;
EDGE_SIDE_BOLT_SIZE = EDGE_OUTER_BOLT_SIZE + 1;
EDGE_SIDE_ACCESS_SIZE = EDGE_SIDE_LENGTH / 2;
EDGE_SIDE_ACCESS_HOLE_SIZE = EDGE_SIDE_ACCESS_SIZE - 2;

EDGE_CASE_INNER_RADIUS = 15 + XY_TOLERANCE * 2;
EDGE_CASE_OUTER_RADIUS = EDGE_CASE_INNER_RADIUS + 1.5;
EDGE_CASE_BODY_DEPTH = 1.6 /* 63 mil */ + 0.03556 /* 1.6 mil */ + 2 * Z_TOLERANCE;
EDGE_CASE_TOP_DEPTH = 1.5; // thickness of header pin == 2.5

echo(
  inner_bolts_radius=EDGE_INNER_BOLTS_RADIUS,
  inner_bolt_length=EDGE_INNER_BOLT_LENGTH,
  outer_bolts_radius = EDGE_OUTER_BOLTS_RADIUS,
  outer_bolts_distance = sqrt(pow(EDGE_OUTER_BOLTS_RADIUS, 2) - pow((EDGE_OUTER_BOLTS_RADIUS / 2), 2)) * 2,
  outer_bolt_length=EDGE_OUTER_BOLT_LENGTH,
  headers_radius=EDGE_HEADERS_RADIUS,
  edge_connector_radius=EDGE_RADIUS,
  sides_radius = EDGE_SIDES_RADIUS
);

module edge () {
  difference () {
    union () {
      body();
      sides();
    }

    inner_bolts();
    outer_bolts();
    channels();
    arm_headers();
  }
}

module edge_case () {
  rotate((1/4) * ROT)
  difference () {
    // outer case
    linear_extrude(height = EDGE_CASE_TOP_DEPTH + EDGE_CASE_BODY_DEPTH)
    polygon(ngon(EDGE_SIDES, EDGE_CASE_OUTER_RADIUS));
  
    // minus inner body
    translate([0, 0, EDGE_CASE_TOP_DEPTH])
    linear_extrude(height = EDGE_CASE_BODY_DEPTH + INFINITESIMAL)
    polygon(ngon(EDGE_SIDES, EDGE_CASE_INNER_RADIUS));

    // minus bolts
    for_each_radial(
      start_step = 1,
      num_steps = CHANNELS_PER_EDGE,
      radius = EDGE_INNER_BOLTS_RADIUS,
      radial_offset = (1/4) * ROT
    ) {
      translate([0, 0, -INFINITESIMAL])
      bolt_hole(
        size = EDGE_INNER_BOLT_SIZE,
        length = EDGE_INNER_BOLT_LENGTH,
        tolerance = EDGE_INNER_BOLT_TOLERANCE
      );
    }

    // minus headers
    //
    translate([0, -EDGE_HEADER_PITCH, 0])
    header(num_pins = 3);

    translate([0, EDGE_HEADER_PITCH, 0])
    header(num_pins = 2);
  }
}

module body () {
  linear_extrude(
    height = EDGE_LENGTH_Z
  )
  rotate(ROT / (EDGE_SIDES * 2))
  polygon(ngon(EDGE_SIDES, EDGE_RADIUS));
}

module sides () {
  for_each_radial(
    start_step = 0,
    end_step = 1,
    num_steps = CHANNELS_PER_EDGE,
    radius = EDGE_SIDES_RADIUS,
    radial_offset = (1/2) * ROT
  ) {
    difference () {
      cylinder(
        r = EDGE_SIDE_ACCESS_SIZE,
        h = EDGE_LENGTH_Z,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );
      
      translate([0, 0, EDGE_LENGTH_Z + INFINITESIMAL])
      rotate([0, 1/2 * ROT, 0])
      cylinder(
        r = EDGE_SIDE_ACCESS_HOLE_SIZE,
        h = EDGE_LENGTH_Z + 2 * INFINITESIMAL,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );
    }
  }
  for_each_radial(
    start_step = 1,
    num_steps = CHANNELS_PER_EDGE,
    radius = EDGE_SIDES_RADIUS,
    radial_offset = (1/2) * ROT
  ) {
    cylinder(
      r = EDGE_OUTER_BOLT_SIZE + 1,
      h = EDGE_LENGTH_Z,
      $fa = MIN_ARC_FRAGMENT_ANGLE,
      $fs = MIN_ARC_FRAGMENT_SIZE
    );
  }
}

module inner_bolts () {  
  for_each_radial(
    start_step = 1,
    num_steps = CHANNELS_PER_EDGE,
    radius = EDGE_INNER_BOLTS_RADIUS,
    radial_offset = (1/2) * ROT
  ) {
    translate([0, 0, -INFINITESIMAL])
    bolt_hole(
      size = EDGE_INNER_BOLT_SIZE,
      length = EDGE_INNER_BOLT_LENGTH,
      tolerance = EDGE_INNER_BOLT_TOLERANCE
    );
  };
  
}

module outer_bolts () {
  for_each_radial(
    start_step = 1,
    num_steps = CHANNELS_PER_EDGE,
    radius = EDGE_OUTER_BOLTS_RADIUS,
    radial_offset = (1/2) * ROT
  ) {
    translate([0, 0, EDGE_LENGTH_Z + INFINITESIMAL])
    rotate([0, 1/2 * ROT, 0])
    bolt_hole(
      size = EDGE_OUTER_BOLT_SIZE,
      length = EDGE_OUTER_BOLT_LENGTH,
      tolerance = EDGE_OUTER_BOLT_TOLERANCE
    );
  };
}

module channels () {
  for_each_radial(
    num_steps = CHANNELS_PER_EDGE,
    radius = CHANNELS_RADIUS,
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
      EDGE_LENGTH_Z - CHANNEL_DEPTH
    ]
  )
  linear_extrude(
    height = CHANNEL_DEPTH + INFINITESIMAL
  )
  channel_shape();
}

module arm_headers () {
  for_each_radial(
    num_steps = CHANNELS_PER_EDGE,
    radius = EDGE_HEADERS_RADIUS,
    radial_offset = 0,
    rotation_offset = (1/4) * ROT
  ) {
    header();
  };
}

module header (num_pins = 4) {
  translate(
    [
      0,
      0,
      -INFINITESIMAL
    ]
  )
  linear_extrude(
    height = EDGE_HEADER_DEPTH + 2 * INFINITESIMAL
  )
  header_shape(num_pins);
}

module header_shape (num_pins) {
  width = EDGE_HEADER_PITCH * num_pins + XY_TOLERANCE;

  square(
    size = [
      width,
      EDGE_HEADER_HEIGHT
    ],
    center = true
  );
}

module channel_shape () {

  intersection () {
    square(INFINITY);
    
    union () {
      circle(
        r = CHANNEL_SIDE_LENGTH,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );

      rotate((1/8) * ROT)
      translate([
        CHANNEL_HEIGHT,
        0
      ])
      square(
        [
          INFINITY,
          CHANNEL_GAP_LENGTH
        ],
        center = true
      );
    }
  };
}
