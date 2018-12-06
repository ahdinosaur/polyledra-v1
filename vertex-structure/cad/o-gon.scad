// inspiration from https://www.thingiverse.com/thing:1653180

// create box
// create markers
// create outer gon
// create inner gon

include <helpers.scad>
include <constants.scad>

// if gon.sides == 1, then torus

translate([70, 0])
ogon_side(
  side="a",
  radius = 20,
  num_sides = 6,
  tube_radius = 2,
  sprue_radius = 1
);

ogon_side(
  side="b",
  radius = 20,
  num_sides = 6,
  tube_radius = 2,
  sprue_radius = 1
);

module ogon_side(
  side = "b",
  radius,
  num_sides,
  margin = 1
) {
  outer_radius = radius + 2 * (margin + tube_radius);
  container_width = 2 * (outer_radius + tube_radius + margin);
  container_height = 2 * (tube_radius + margin);
  
  difference () {
    union () {
      difference () {
        rounded_box(
          size = [container_width, container_width, container_height]
        );
        
        if (side == "a") {
          markers(
            container_width = container_width,
            container_height = container_height,
            radius = tube_radius
          );
          ring(
            radius = outer_radius,
            num_sides = num_sides,
            tube_radius = tube_radius
          );
        }
        ring(
          radius = radius,
          num_sides = num_sides,
          tube_radius = tube_radius
        );
        
        above_z(0);
      }
            
      if (side == "b") {
        ring(
          radius = outer_radius,
          num_sides = num_sides,
          tube_radius = tube_radius
        );
        markers(
          container_width = container_width,
          container_height = container_height,
          radius = tube_radius
        );
      }
    }
    
    sprue(
      radius = radius,
      container_width = container_width,
      sprue_radius = sprue_radius
    );
  }
}

module ring (
  radius,
  num_sides,
  tube_radius
) {
  if (num_sides == 1) {
    torus(
      radius = radius,
      tube_radius = tube_radius
    );
  } else if (num_sides > 1) {
    polygon_ring(
      radius = radius,
      num_sides = num_sides,
      tube_radius = tube_radius
    );
  }
}

module markers (
  container_width,
  container_height,
  radius
) {
  offset = (3 * radius + 2) / 2;
  
  translate([(1/2) * container_width - offset, (1/2) * container_width - offset])
  sphere(
    radius,
    center = true,
    $fa = MIN_ARC_FRAGMENT_ANGLE,
    $fs = MIN_ARC_FRAGMENT_SIZE
  );
  
  translate([(-1/2) * container_width + offset, (1/2) * container_width - offset])
  sphere(
    radius,
    center = true,
    $fa = MIN_ARC_FRAGMENT_ANGLE,
    $fs = MIN_ARC_FRAGMENT_SIZE
  );
  
  translate([(1/2) * container_width - offset, (-1/2) * container_width + offset])
  sphere(
    radius,
    center = true,
    $fa = MIN_ARC_FRAGMENT_ANGLE,
    $fs = MIN_ARC_FRAGMENT_SIZE
  );
  
  translate([(-1/2) * container_width + offset, (-1/2) * container_width + offset])
  sphere(
    radius,
    center = true,
    $fa = MIN_ARC_FRAGMENT_ANGLE,
    $fs = MIN_ARC_FRAGMENT_SIZE
  );
}

module sprue (
  container_width,
  radius,
  sprue_radius
) {
  rotate([0, 90, 0])
  translate([0,0, radius])
  cylinder(
    h = (1/2 * container_width) - radius + INFINITY,
    r = sprue_radius,
    $fa = MIN_ARC_FRAGMENT_ANGLE,
    $fs = MIN_ARC_FRAGMENT_SIZE
  );
}  

/*
ranslate([0,0,moldDepth]) {
    rotate([0,-90,0]) {
    translate([0,(moldWidth/1.5),0]) {
        rotate([0,0,180]) {
            union() {
            difference() {
                union() {
                    difference() {
                        translate([0,-(moldWidth/2),-(moldWidth/2)]) {
                            cube([moldDepth,moldWidth,moldHeight]);
                        }
                        rotate([0,90,0]) {
                            rotate_extrude(convexity = 10, $fn = resolution) {
                                translate([radius + (Inner_Diameter/2),0,0]) {
                                    circle(radius, $fn = resolution);
                                }
                            }
                        }
                    }
                    rotate([0,90,0]) {
                        rotate_extrude(convexity = 10, $fn = resolution) {
                            translate([radius + ((1.5*(Inner_Diameter + radius + 6))/2),0,0]) {
                                circle(radius, $fn = resolution);
                            }
                        }
                    }
                }
                translate([0,0,(Inner_Diameter/2) + radius]) {
                    cylinder((moldHeight/2), r = Sprue_Radius, $fn = resolution);
                }
            }

        }
        }
    }
    
    */