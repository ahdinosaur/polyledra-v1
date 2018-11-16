include <constants.scad>

// Simple list comprehension for creating N-gon vertices
function ngon(num, r) = [for (i=[0:num-1], a=i*360/num) [ r*cos(a), r*sin(a) ]];

// https://www.wikihow.com/Find-the-Height-of-a-Triangle
function triangle_height (a, b, c) =
  let (
    perimeter = (a + b + c),
    s = perimeter / 2,
    area = sqrt(s * (s - a) * (s - b) * (s - c)),
    base = a,
    height = area / ((1 / 2) * base)
  ) height;

// https://www.onlinemathlearning.com/cosecant.html
function sec (theta) = 1 / cos(theta);
function csc (theta) = 1 / sin(theta);
function cot (theta) = 1 / tan(theta);

// http://www.mathopenref.com/polygonsides.html
function polygon_side_length (circumradius, sides) =
  2 * circumradius * sin(180 / sides);

// https://math.stackexchange.com/a/1282689
function polygon_inradius (circumradius, sides) =
  circumradius / sec(180 / sides);

// http://forum.openscad.org/test-if-variable-is-defined-td2994.html
function defined(a) = str(a) != "undef"; 

// http://forum.openscad.org/Drawing-Ellipses-td536.html
module ellipses (rx, ry) {
  scale([
    1,
    ry / rx
  ])
  circle(
    r = rx,
    $fa = MIN_ARC_FRAGMENT_ANGLE,
    $fs = MIN_ARC_FRAGMENT_SIZE
  );
}

module for_each_radial (
  start_step = 0,
  end_step,
  num_steps,
  radius,
  radial_offset = 0,
  rotation_offset = 0
) {
  end_step_value = defined(end_step) ? end_step - 1 : num_steps - 1;
  
  for (index = [start_step : end_step_value]) {
    angle = index * (ROT / num_steps);
    radial = angle + radial_offset;
    rotation = angle + rotation_offset;

    translate([
      radius * cos(radial),
      radius * sin(radial),
      0
    ])
    rotate(rotation)
    children();
  }
}

// https://www.youtube.com/watch?v=c1LKQaFIPNA
module right_triangle (a, b, corner_radius, height) {
  translate([(-1/2) * a, (-1/2) * b, (-1/2) * height])
  linear_extrude(height = height)
  translate([corner_radius, 0])
  hull () {
    circle(r = corner_radius);

    translate([a - corner_radius * 2, 0])
    circle(r = corner_radius);

    translate([0, b - corner_radius * 2])
    circle(r = corner_radius);
  }
}

module below_x (x) {
  translate(
    [
      x - (INFINITY),
      -INFINITY / 2,
      -INFINITY / 2
    ]
  )
  cube(INFINITY);
}

module below_z (z) {
  translate(
    [
      -INFINITY / 2,
      -INFINITY / 2,
      z - (INFINITY)
    ]
  )
  cube(INFINITY);
}

module above_z (z) {
  translate(
    [
      -INFINITY / 2,
      -INFINITY / 2,,
      z
    ]
  )
  cube(INFINITY);
}
