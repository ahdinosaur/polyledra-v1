echo(version=version());

include <constants.scad>
include <nuts-and-bolts.scad>

ARMS_PER_EDGE = 3;
EDGES_PER_VERTEX = 3;
EDGE_CONNECTOR_LENGTH = 16;
EDGE_CONNECTOR_OFFSET = 14;
EDGE_CONNECTOR_HEIGHT = 4;
VERTEX_CONNECTOR_LENGTH = 16 + INFINITESIMAL;
VERTEX_CONNECTOR_HEIGHT = 6;
SCREW_SIZE = 5;
SCREW_LENGTH = INFINITY;

HEADER_WIDTH = 14;
HEADER_HEIGHT = 10;
HEADER_OFFSET = 2;

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
    //positive_z();
  
    union () {
      vertex_connector();
      
      for (edge_index = [0 : EDGES_PER_VERTEX]) {
        edge_phi = edge_index * (ROT / EDGES_PER_VERTEX);

        translate(
          [
            EDGE_CONNECTOR_OFFSET*cos(edge_phi),
            EDGE_CONNECTOR_OFFSET*sin(edge_phi),
            0
          ]
        )
        rotate(
          a = [
            0,
            edge_theta,
            edge_phi
          ]
        )
        edge_connector();
      }
    };
  };
}

module vertex_connector () {
  rotate(1/(2 * EDGES_PER_VERTEX) * ROT)
  linear_extrude(
    height = VERTEX_CONNECTOR_HEIGHT
  )
  polygon(ngon(EDGES_PER_VERTEX, VERTEX_CONNECTOR_LENGTH));
}

module edge_connector () {
  union () {
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
    
    // minus each arm header
    for (arm_index = [0 : ARMS_PER_EDGE]) {
      arm_phi = arm_index * (ROT / ARMS_PER_EDGE);
      
      rotate([0, 0, 1/4 * ROT])
      rotate([0, 0, arm_phi])
      translate([-(1/2)* HEADER_WIDTH, -(1/4)*HEADER_HEIGHT, 0])
      cube([HEADER_WIDTH, HEADER_HEIGHT, INFINITY]);
    }
  }
}

// Simple list comprehension for creating N-gon vertices
function ngon(num, r) = [for (i=[0:num-1], a=i*360/num) [ r*cos(a), r*sin(a) ]];

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