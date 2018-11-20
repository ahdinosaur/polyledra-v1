include <constants.scad>
include <helpers.scad>
include <nuts-and-bolts.scad>

echo(version=version());

CHANNELS_PER_EDGE = 3;
CHANNEL_LENGTH_SIDE = 15.5 + XY_TOLERANCE; // or 15.75
CHANNEL_LENGTH_HYPOTENUSE = sqrt(2 * pow(CHANNEL_LENGTH_SIDE, 2));
CHANNEL_LENGTH_HEIGHT = triangle_height(CHANNEL_LENGTH_HYPOTENUSE, CHANNEL_LENGTH_SIDE, CHANNEL_LENGTH_SIDE);
echo(channel_length_height = CHANNEL_LENGTH_HEIGHT); // = 11.63
// hyp with bulge: 17
CHANNEL_BULGE_RX = CHANNEL_LENGTH_HEIGHT / 2;
CHANNEL_BULGE_RY = CHANNEL_LENGTH_HYPOTENUSE / 2;
CHANNEL_LENGTH_Z = 10 + Z_TOLERANCE;
CHANNELS_RADIUS = 0.6;

HEADER_PITCH = 2.54;
HEADER_NUM_PINS = 4;
HEADER_LENGTH_X = HEADER_PITCH * HEADER_NUM_PINS + XY_TOLERANCE;
HEADER_LENGTH_Y = HEADER_PITCH + 2 * XY_TOLERANCE;
HEADER_LENGTH_Z = HEADER_PITCH + 2 * Z_TOLERANCE;
HEADERS_RADIUS = CHANNEL_LENGTH_SIDE / 2 + CHANNELS_RADIUS + 0.7; // 6.55

EDGE_CONNECTOR_SIDES = CHANNELS_PER_EDGE * 2;
EDGE_CONNECTOR_RADIUS = CHANNEL_LENGTH_SIDE + CHANNELS_RADIUS + 3;
EDGE_CONNECTOR_LENGTH_Z = CHANNEL_LENGTH_Z + HEADER_LENGTH_Z;
EDGE_CONNECTOR_INRADIUS = polygon_inradius(
  circumradius = EDGE_CONNECTOR_RADIUS,
  sides = EDGE_CONNECTOR_SIDES
);
EDGE_CONNECTOR_SIDE_LENGTH = polygon_side_length(
  circumradius = EDGE_CONNECTOR_RADIUS,
  sides = EDGE_CONNECTOR_SIDES
);

INNER_BOLT_SIZE = 3;
INNER_BOLT_LENGTH = EDGE_CONNECTOR_LENGTH_Z - 2;
INNER_BOLTS_RADIUS = (2/5) * EDGE_CONNECTOR_RADIUS;
INNER_BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[INNER_BOLT_SIZE] / 2;
INNER_BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[INNER_BOLT_SIZE];
INNER_BOLT_TOLERANCE = 0.01;

OUTER_BOLT_SIZE = 4;
OUTER_BOLT_LENGTH = EDGE_CONNECTOR_LENGTH_Z + 3;
OUTER_BOLTS_RADIUS = EDGE_CONNECTOR_INRADIUS;
OUTER_BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[OUTER_BOLT_SIZE] / 2;
OUTER_BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[OUTER_BOLT_SIZE];
OUTER_BOLT_TOLERANCE = XY_TOLERANCE;

SIDES_RADIUS = EDGE_CONNECTOR_INRADIUS;
SIDE_BOLT_SIZE = OUTER_BOLT_SIZE + 1;
SIDE_ACCESS_SIZE = EDGE_CONNECTOR_SIDE_LENGTH / 2;
SIDE_ACCESS_HOLE_SIZE = SIDE_ACCESS_SIZE - 2;

main();

module main () {
  echo(
    inner_bolts_radius=INNER_BOLTS_RADIUS,
    inner_bolt_length=INNER_BOLT_LENGTH,
    outer_bolts_radius = OUTER_BOLTS_RADIUS,
    outer_bolts_distance = sqrt(pow(OUTER_BOLTS_RADIUS, 2) - pow((OUTER_BOLTS_RADIUS / 2), 2)) * 2,
    outer_bolt_length=OUTER_BOLT_LENGTH,
    headers_radius=HEADERS_RADIUS,
    edge_connector_radius=EDGE_CONNECTOR_RADIUS,
    sides_radius = SIDES_RADIUS
  );
  edge();
}

module edge () {
  difference () {
    union () {
      body();
      sides();
    }

    inner_bolts();
    outer_bolts();
    channels();
    headers();
  }
}

module body () {
  linear_extrude(
    height = EDGE_CONNECTOR_LENGTH_Z
  )
  rotate(ROT / (EDGE_CONNECTOR_SIDES * 2))
  polygon(ngon(EDGE_CONNECTOR_SIDES, EDGE_CONNECTOR_RADIUS));
}

module sides () {
  for_each_radial(
    start_step = 0,
    end_step = 1,
    num_steps = CHANNELS_PER_EDGE,
    radius = SIDES_RADIUS,
    radial_offset = (1/2) * ROT
  ) {
    difference () {
      cylinder(
        r = SIDE_ACCESS_SIZE,
        h = EDGE_CONNECTOR_LENGTH_Z,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );
      
      translate([0, 0, EDGE_CONNECTOR_LENGTH_Z + INFINITESIMAL])
      rotate([0, 1/2 * ROT, 0])
      cylinder(
        r = SIDE_ACCESS_HOLE_SIZE,
        h = EDGE_CONNECTOR_LENGTH_Z + 2 * INFINITESIMAL,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );
    }
  }
  for_each_radial(
    start_step = 1,
    num_steps = CHANNELS_PER_EDGE,
    radius = SIDES_RADIUS,
    radial_offset = (1/2) * ROT
  ) {
    cylinder(
      r = OUTER_BOLT_SIZE + 1,
      h = EDGE_CONNECTOR_LENGTH_Z,
      $fa = MIN_ARC_FRAGMENT_ANGLE,
      $fs = MIN_ARC_FRAGMENT_SIZE
    );
  }
}

module inner_bolts () {  
  for_each_radial(
    start_step = 1,
    num_steps = CHANNELS_PER_EDGE,
    radius = INNER_BOLTS_RADIUS,
    radial_offset = (1/2) * ROT
  ) {
    translate([0, 0, -INFINITESIMAL])
    bolt_hole(
      size = INNER_BOLT_SIZE,
      length = INNER_BOLT_LENGTH,
      tolerance = INNER_BOLT_TOLERANCE
    );
  };
  
}

module outer_bolts () {
  for_each_radial(
    start_step = 1,
    num_steps = CHANNELS_PER_EDGE,
    radius = OUTER_BOLTS_RADIUS,
    radial_offset = (1/2) * ROT
  ) {
    translate([0, 0, EDGE_CONNECTOR_LENGTH_Z + INFINITESIMAL])
    rotate([0, 1/2 * ROT, 0])
    bolt_hole(
      size = OUTER_BOLT_SIZE,
      length = OUTER_BOLT_LENGTH,
      tolerance = OUTER_BOLT_TOLERANCE
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
      EDGE_CONNECTOR_LENGTH_Z - CHANNEL_LENGTH_Z
    ]
  )
  linear_extrude(
    height = CHANNEL_LENGTH_Z + INFINITESIMAL
  )
  channel_shape();
}

module headers () {
  for_each_radial(
    num_steps = CHANNELS_PER_EDGE,
    radius = HEADERS_RADIUS,
    radial_offset = 0,
    rotation_offset = (1/4) * ROT
  ) {
    header();
  };
}

module header () {
    translate(
    [
      0,
      0,
      -INFINITESIMAL
    ]
  )
  linear_extrude(
    height = HEADER_LENGTH_Z + 2 * INFINITESIMAL
  )
  header_shape();
}

module header_shape () {
  square(
    size = [
      HEADER_LENGTH_X,
      HEADER_LENGTH_Y
    ],
    center = true
  );
}

module channel_shape () {

  intersection () {
    square(INFINITY);
    
    union () {
      circle(
        r = CHANNEL_LENGTH_SIDE,
        $fa = MIN_ARC_FRAGMENT_ANGLE,
        $fs = MIN_ARC_FRAGMENT_SIZE
      );


      rotate((1/8) * ROT)
      translate([
        CHANNEL_LENGTH_HEIGHT,
        0
      ])
      ellipses(
        rx = CHANNEL_BULGE_RX,
        ry = CHANNEL_BULGE_RY
      );
    }
  };
}