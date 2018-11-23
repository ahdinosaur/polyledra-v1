echo(version=version());

include <constants.scad>
include <helpers.scad>
include <nuts-and-bolts.scad>

EDGES_PER_VERTEX = 3;
EDGES_RADIUS = 24;
EDGE_ANGLE = 35.26439;

EDGE_BOLT_SIZE = 4;
EDGE_BOLT_LENGTH = INFINITY;
EDGE_BOLT_TOLERANCE = (4/3) * TOLERANCE;

EDGE_SIDES = 3;
EDGE_BOLTS_RADIUS = 17.3205;
EDGE_OUTER_RADIUS = EDGE_BOLTS_RADIUS + 4;
EDGE_INNER_RADIUS = EDGE_OUTER_RADIUS - EDGE_BOLT_SIZE * 2 - 7;
EDGE_BETWEEN_RADIUS = EDGE_OUTER_RADIUS - 8;
EDGE_MARGIN = 2;
EDGE_OUTER_DEPTH = 5;
EDGE_BETWEEN_DEPTH = EDGE_OUTER_DEPTH - 2;
EDGE_BETWEEN_DEPTH_OFFSET = 2;
EDGE_CORNER_RADIUS = EDGE_BOLT_SIZE;

VERTEX_BOLT_SIZE = 4;
VERTEX_BOLT_LENGTH = INFINITY;
VERTEX_BOLT_TOLERANCE = TOLERANCE;
VERTEX_SIDES = EDGES_PER_VERTEX * 2;
VERTEX_NUM_BOLTS = 2;
VERTEX_OUTER_RADIUS = 16;
VERTEX_OUTER_DEPTH = 5;
VERTEX_OUTER_DEPTH_OFFSET = 6;
VERTEX_CORNER_RADIUS = VERTEX_BOLT_SIZE;
VERTEX_BOLTS_RADIUS = 9;

MAX_Z = VERTEX_OUTER_DEPTH_OFFSET + (VERTEX_OUTER_DEPTH / 2);

echo("tetrahedron vertex:");
echo(
  vertex_bolts_radius = VERTEX_BOLTS_RADIUS
);

// rotate([0, 180, 0])
if ($main != 1) tetrahedron_vertex();
  
module tetrahedron_vertex () {
  intersection () {
    below_z(z = MAX_Z);
    
    difference () {
      union () {
        vertex_plate();
        
        for_each_radial(
          num_steps = EDGE_SIDES,
          radius = EDGES_RADIUS
        ) {
          rotate(a = [0, EDGE_ANGLE])
          edge_plate();
        }
              
       for_each_radial(
          num_steps = EDGE_SIDES,
          radius = EDGES_RADIUS,
          radial_offset = (1 / EDGE_SIDES / 2) * ROT,
          rotation_offset = (1 / EDGE_SIDES / 2) * ROT
        ) {
          rotate(a = [0, EDGE_ANGLE])
          edge_between();
        }
      }

      
      //vertex_gap();
    }
  }
}

module vertex_plate () {
  difference () {
    // polygon
    rotate((1 / 4) * EDGES_PER_VERTEX * ROT)
    translate([0, 0, VERTEX_OUTER_DEPTH_OFFSET])
    difference () {
      rounded_polygon(
        num_sides = VERTEX_SIDES,
        depth = VERTEX_OUTER_DEPTH,
        radius = VERTEX_OUTER_RADIUS,
        corner_radius = VERTEX_CORNER_RADIUS
      );
    }
    
    // minus bolts
    rotate((1 / 2) * EDGES_PER_VERTEX * ROT)
    for_each_radial(
      num_steps = EDGES_PER_VERTEX,
      end_step = VERTEX_NUM_BOLTS,
      radius = VERTEX_BOLTS_RADIUS
    ) {
      translate([0, 0, - (1/2) * VERTEX_BOLT_LENGTH])
      bolt_hole(
        size = VERTEX_BOLT_SIZE,
        length = VERTEX_BOLT_LENGTH,
        tolerance = VERTEX_BOLT_TOLERANCE
      );
    }
    
    // subtract the space that would interfere with the edge connectors
    for_each_radial(
      num_steps = EDGES_PER_VERTEX,
      radius = EDGES_RADIUS
    ) {
      rotate(a = [0, EDGE_ANGLE])
      rotate([0, 0, (1 / 2 * EDGES_PER_VERTEX) * ROT])
      translate([(-1/2) * INFINITY, (-1/2) * INFINITY, (1/2) * EDGE_OUTER_DEPTH - INFINITESIMAL])
      cube(INFINITY);
    }
  }
}

module vertex_gap () {
  rotate((1 / 2) * EDGES_PER_VERTEX * ROT)
  translate([0, 0, VERTEX_OUTER_DEPTH_OFFSET])
  // minus inner polygon
  translate([0, 0, INFINITESIMAL])
  rounded_polygon(
    num_sides = VERTEX_SIDES,
    depth = VERTEX_DEPTH + 3 * INFINITESIMAL,
    radius = VERTEX_INNER_RADIUS,
    corner_radius = VERTEX_CORNER_RADIUS
  );
}
module edge_plate () {
  rotate(a = [0, 0, (1 / 2 * EDGES_PER_VERTEX) * ROT])
  difference () {
    // polygon
    rounded_polygon(
      num_sides = EDGE_SIDES,
      depth = EDGE_OUTER_DEPTH,
      radius = EDGE_OUTER_RADIUS,
      corner_radius = EDGE_CORNER_RADIUS
    );
    
    // minus inner polygon
    translate([0, 0, INFINITESIMAL])
    rounded_polygon(
      num_sides = EDGE_SIDES,
      depth = EDGE_OUTER_DEPTH + 3 * INFINITESIMAL,
      radius = EDGE_INNER_RADIUS,
      corner_radius = EDGE_CORNER_RADIUS
    );

    // minus bolts
    for_each_radial(
      start_step = 1,
      num_steps = EDGES_PER_VERTEX,
      radius = EDGE_BOLTS_RADIUS
    ) {
      translate([0, 0, - (1/2) * EDGE_BOLT_LENGTH])
      bolt_hole(
        size = EDGE_BOLT_SIZE,
        length = EDGE_BOLT_LENGTH,
        tolerance = EDGE_BOLT_TOLERANCE
      );
    }
  }
}

module edge_between () {
  rotate(a = [0, 0, (1 / 8 * EDGES_PER_VERTEX) * ROT])
  translate([0, 0, EDGE_BETWEEN_DEPTH_OFFSET])
  difference () {
    // polygon
    rounded_polygon(
      num_sides = 4,
      depth = EDGE_BETWEEN_DEPTH,
      radius = EDGE_BETWEEN_RADIUS,
      corner_radius = EDGE_CORNER_RADIUS
    );
  }
}
