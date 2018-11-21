echo(version=version());

include <constants.scad>
include <helpers.scad>
include <nuts-and-bolts.scad>

EDGES_PER_VERTEX = 3;

BOTTOM_BOLT_SIZE = 4;
BOTTOM_BOLT_LENGTH = INFINITY;
BOTTOM_BOLT_CAP_HEIGHT = METRIC_NUT_THICKNESS[BOTTOM_BOLT_SIZE];
BOTTOM_BOLT_CAP_RADIUS = METRIC_NUT_AC_WIDTHS[BOTTOM_BOLT_SIZE] / 2;
BOTTOM_BOLTS_RADIUS = 10; // same as angle bolts distance
BOTTOM_BED_RADIUS = BOTTOM_BOLTS_RADIUS + 5;
BOTTOM_BED_SIDES = EDGES_PER_VERTEX * 2;
BOTTOM_BED_LENGTH_Z = 3;

TOP_BOLT_SIZE = 3;
TOP_BOLT_LENGTH = 5;
TOP_BED_RADIUS = TOP_BOLT_SIZE + 2;
TOP_BED_SIDES = EDGES_PER_VERTEX * 2;
TOP_BED_LENGTH_Z = 3;

main();

module main () {
  vertex_bed();
}

module vertex_bed () {
  difference () {
    union () {
      bottom_bed();
      top_bed();
    }
    
    bottom_bolts();
    top_bolts();
  }
}

module bottom_bed () {
  linear_extrude(
    height = BOTTOM_BED_LENGTH_Z
  )
  polygon(ngon(BOTTOM_BED_SIDES, BOTTOM_BED_RADIUS));
}

module bottom_bolts () {
  translate([0, 0, BOTTOM_BED_LENGTH_Z + INFINITESIMAL])
  rotate([0, (1/2) * ROT])
  for_each_radial(
    start_step = 0,
    num_steps = BOTTOM_BED_SIDES,
    radius = BOTTOM_BOLTS_RADIUS
  ) {
    bolt_hole(
      size = BOTTOM_BOLT_SIZE,
      length = BOTTOM_BOLT_LENGTH,
      tolerance = XY_TOLERANCE
    );
  }
}

module top_bed () {
  translate([0, 0, BOTTOM_BED_LENGTH_Z])
  linear_extrude(
    height = TOP_BED_LENGTH_Z
  )
  polygon(ngon(TOP_BED_SIDES, TOP_BED_RADIUS));
}

module top_bolts () {
  translate([0, 0, BOTTOM_BED_LENGTH_Z + TOP_BED_LENGTH_Z + INFINITESIMAL])
  rotate([0, (1/2) * ROT])
  bolt_hole(
    size = TOP_BOLT_SIZE,
    length = TOP_BOLT_LENGTH,
    tolerance = XY_TOLERANCE
  );
}
