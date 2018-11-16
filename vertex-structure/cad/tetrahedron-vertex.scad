echo(version=version());

include <constants.scad>
include <helpers.scad>
include <nuts-and-bolts.scad>

EDGES_PER_VERTEX = 3;
EDGE_CONNECTOR_ANGLE = 35.26439;

EDGE_CONNECTOR_SIDES = EDGES_PER_VERTEX;
EDGE_CONNECTOR_RADIUS = 28;
EDGE_CONNECTOR_LENGTH_Z = 8.5;
EDGE_CONNECTORS_RADIUS = 24;

VERTEX_CONNECTOR_RADIUS = 18;
VERTEX_CONNECTOR_LENGTH_Z = 8;
VERTEX_CONNECTOR_SIDES = EDGES_PER_VERTEX * 2;
VERTEX_CONNECTOR_OFFSET_Z = -2;

MAX_Z = VERTEX_CONNECTOR_OFFSET_Z + VERTEX_CONNECTOR_LENGTH_Z;

BOLT_SIZE = 4;
BOLT_LENGTH = INFINITY;
BOLTS_RADIUS = 17.4937;

/*
HEADER_NUM_PINS = 4;
HEADER_PITCH = 2.54;
HEADER_X_LENGTH = HEADER_PITCH * (HEADER_NUM_PINS * + 0.4) + 0.25;
HEADER_Y_LENGTH = 2.4;
HEADER_Z_LENGTH = 8.5;
HEADER_Y_OFFSET = 2;
*/

// rotate([0, 180, 0])
main();

module main () {
  intersection () {
    below(z = MAX_Z);
    
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
      translate([0, 0, VERTEX_CONNECTOR_OFFSET_Z])
      linear_extrude(
        height = VERTEX_CONNECTOR_LENGTH_Z
      )
      polygon(ngon(VERTEX_CONNECTOR_SIDES, VERTEX_CONNECTOR_RADIUS));
    }
    
    // subtract the space that would interfere with the edge connectors
    union () {
      for (edge_index = [0 : EDGES_PER_VERTEX]) {
        edge_theta = EDGE_CONNECTOR_ANGLE;
        edge_phi = edge_index * (ROT / EDGES_PER_VERTEX);
        
        translate(
          [
            EDGE_CONNECTORS_RADIUS*cos(edge_phi),
            EDGE_CONNECTORS_RADIUS*sin(edge_phi),
            0
          ]
        )
        rotate(a = [0, edge_theta, edge_phi])
        rotate([0, 0, (1 / 2 * EDGES_PER_VERTEX) * ROT])
        translate([0, (-1/2) * INFINITY, (1/2) * EDGE_CONNECTOR_LENGTH_Z - INFINITESIMAL])
        cube(INFINITY);
      }
    }
  }
}

module edge_connectors () {
  for (edge_index = [0 : EDGES_PER_VERTEX]) {
    edge_theta = EDGE_CONNECTOR_ANGLE;
    edge_phi = edge_index * (ROT / EDGES_PER_VERTEX);

    translate(
      [
        EDGE_CONNECTORS_RADIUS*cos(edge_phi),
        EDGE_CONNECTORS_RADIUS*sin(edge_phi),
        0
      ]
    )
    rotate(a = [0, edge_theta, edge_phi])
    // union () {
    //  cylinder(r = 21.5, h = 20);
    edge_connector();
    // }
  }
}

module edge_connector () {
  rotate(a = [0, 0, (1 / 2 * EDGES_PER_VERTEX) * ROT])
  difference () {
    // triangle
    translate([0, 0, (-1/2) * EDGE_CONNECTOR_LENGTH_Z])
    linear_extrude(
      height = EDGE_CONNECTOR_LENGTH_Z
    )
    polygon(ngon(EDGE_CONNECTOR_SIDES, EDGE_CONNECTOR_RADIUS));

    // minus bolts
    for_each_radial(
      start_step = 1,
      num_steps = EDGES_PER_VERTEX,
      radius = BOLTS_RADIUS
    ) {
      translate([
        0,
        0,
        - (1/2) * BOLT_LENGTH
      ])
      bolt_hole(
        size = BOLT_SIZE,
        length = BOLT_LENGTH,
        tolerance = XY_TOLERANCE
      );
    }
  }
}
