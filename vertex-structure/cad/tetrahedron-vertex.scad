recho(version=version());

include <constants.scad>
include <nuts-and-bolts.scad>

ARMS_PER_EDGE = 3;
EDGES_PER_VERTEX = 3;
EDGE_CONNECTOR_LENGTH = 25;
EDGE_CONNECTOR_OFFSET = 30;
EDGE_CONNECTOR_HEIGHT = 8.5;

VERTEX_SURFACE_LENGTH = 22;
VERTEX_SURFACE_HEIGHT = 5;

VERTEX_Z_OFFSET = 5;

VERTEX_BEAM_X_LENGTH = 26;
VERTEX_BEAM_Y_LENGTH = 8;
VERTEX_BEAM_Z_LENGTH = 10;

VERTEX_MAX_Z = VERTEX_Z_OFFSET + VERTEX_SURFACE_HEIGHT + VERTEX_Z_OFFSET;

SCREW_SIZE = 4;
SCREW_LENGTH = INFINITY;

/*
HEADER_NUM_PINS = 4;
HEADER_PITCH = 2.54;
HEADER_X_LENGTH = HEADER_PITCH * (HEADER_NUM_PINS * + 0.4) + 0.25;
HEADER_Y_LENGTH = 2.4;
HEADER_Z_LENGTH = 8.5;
HEADER_Y_OFFSET = 2;
*/

// sin(phi) = x
// sin^-1(x) = phi

// h^2 + (1/2)^2 = 1^2
// h = sqrt(3) / 2

// h = x + w

// tan(30) = w / (1/2)
// w = (1/2)tan(30)

// phi = sin^-1((sqrt(3)/2) - (1/2)tan(30))

edge_theta = 35.26439;

// 30 from vertical
// 120 around vertical axis
// 120 again

// nominate an axis as the pole
// rotate your point towards the normal = latitude
// rotate around the pole = longitude


     
main();

module main () {
  intersection () {
    below(z = VERTEX_MAX_Z);
    
    union () {
      vertex_connector();
      edge_connectors();
    };
  }
}

module vertex_connector () {
  difference () {
    union () {
      rotate((1 / EDGES_PER_VERTEX) * ROT)
      translate([0, 0, VERTEX_Z_OFFSET])
      linear_extrude(
        height = VERTEX_SURFACE_HEIGHT
      )
      polygon(ngon(EDGES_PER_VERTEX, VERTEX_SURFACE_LENGTH));
    
      for (edge_index = [0 : EDGES_PER_VERTEX]) {
        edge_phi = edge_index * (ROT / EDGES_PER_VERTEX);
        
        rotate(a = [0, 0, edge_phi])
        translate([
          0,
          -(1/2) * VERTEX_BEAM_Y_LENGTH,
          VERTEX_Z_OFFSET
        ])
        cube([
          VERTEX_BEAM_X_LENGTH,
          VERTEX_BEAM_Y_LENGTH,
          VERTEX_BEAM_Z_LENGTH
        ]);
      }
    }
    
    // subtract the space that would interfere with the edge connectors
    union () {
      for (edge_index = [0 : EDGES_PER_VERTEX]) {
        edge_phi = edge_index * (ROT / EDGES_PER_VERTEX);
        
        translate(
          [
            EDGE_CONNECTOR_OFFSET*cos(edge_phi),
            EDGE_CONNECTOR_OFFSET*sin(edge_phi),
            0
          ]
        )
        rotate(a = [0, edge_theta, edge_phi])
        rotate([0, 0, (1 / 2 * EDGES_PER_VERTEX) * ROT])
        translate([0, (-1/2) * INFINITY, (1/2) * EDGE_CONNECTOR_HEIGHT - INFINITESIMAL])
        cube(INFINITY);
      }
    }
  }
}

module edge_connectors () {
  for (edge_index = [0 : EDGES_PER_VERTEX]) {
    edge_phi = edge_index * (ROT / EDGES_PER_VERTEX);

    translate(
      [
        EDGE_CONNECTOR_OFFSET*cos(edge_phi),
        EDGE_CONNECTOR_OFFSET*sin(edge_phi),
        0
      ]
    )
    rotate(a = [0, edge_theta, edge_phi])
    //cylinder(r = 23.55, h = 20);
    edge_connector();
  }
}

module edge_connector () {
  rotate(a = [0, 0, (1 / 2 * ARMS_PER_EDGE) * ROT])
  difference () {
    // triangle
    translate([0, 0, (-1/2) * EDGE_CONNECTOR_HEIGHT])
    linear_extrude(
      height = EDGE_CONNECTOR_HEIGHT
    )
    polygon(ngon(ARMS_PER_EDGE, EDGE_CONNECTOR_LENGTH));
    
    // minus bolt
    rotate([0, (1/2) * ROT, 0])
    translate([0, 0, - (1/2) * SCREW_LENGTH])
    bolt_hole(
      size = SCREW_SIZE,
      length = SCREW_LENGTH
    );
  }
}

// Simple list comprehension for creating N-gon vertices
function ngon(num, r) = [for (i=[0:num-1], a=i*360/num) [ r*cos(a), r*sin(a) ]];

module below (z) {
  translate(
    [
      -INFINITY / 2,
      -INFINITY / 2,
      z - (INFINITY)
    ]
  )
  cube(INFINITY);
}

module above (z) {
  translate(
    [
      -INFINITY / 2,
      -INFINITY / 2,,
      z
    ]
  )
  cube(INFINITY);
}