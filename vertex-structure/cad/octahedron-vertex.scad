echo(version=version());

include <octahedron-vertex-lib.scad>

echo("octahedron vertex:");
echo(
  vertex_bolts_radius = OCTAHEDRON_VERTEX_BOLTS_RADIUS
);

rotate([0, 1/2 * ROT, 0])
octahedron_vertex();
