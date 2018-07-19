echo(version=version());

include <constants.scad>
include <nuts-and-bolts.scad>

ARMS_PER_EDGE = 3;
EDGES_PER_VERTEX = 3;
EDGE_CONNECTOR_LENGTH = 4;
EDGE_CONNECTOR_OFFSET = 4;
EDGE_CONNECTOR_HEIGHT = 2;
VERTEX_CONNECTOR_LENGTH = 4;
VERTEX_CONNECTOR_HEIGHT = 2;
SCREW_SIZE = 5;
SCREW_LENGTH = INFINITY;

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
  linear_extrude(
    height = VERTEX_CONNECTOR_HEIGHT
  )
  polygon(ngon(EDGES_PER_VERTEX, VERTEX_CONNECTOR_LENGTH));
}

module edge_connector () {
  difference () {
    linear_extrude(
      height = EDGE_CONNECTOR_HEIGHT
    )
    polygon(ngon(ARMS_PER_EDGE, EDGE_CONNECTOR_LENGTH));
    
    /*
    bolt_hole(
      size = SCREW_SIZE,
      length = SCREW_LENGTH
    );
    */
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