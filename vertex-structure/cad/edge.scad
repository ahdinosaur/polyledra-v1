include <edge-lib.scad>

echo(version=version());

edge();

/*
translate([0, 0, - EDGE_CASE_BODY_DEPTH - EDGE_CASE_TOP_DEPTH])
edge_case();
*/