echo(version=version());

include <tetrahedron-vertex-lib.scad>

echo("tetrahedron vertex:");
echo(
  vertex_bolts_radius = TETRAHEDRON_VERTEX_BOLTS_RADIUS
);

tetrahedron_vertex();
