// Simple list comprehension for creating N-gon vertices
function ngon(num, r) = [for (i=[0:num-1], a=i*360/num) [ r*cos(a), r*sin(a) ]];

module for_each_radial (
  start_step = 0,
  num_steps,
  radius,
  radial_offset = 0,
  rotation_offset = 0
) {
  for (index = [start_step : num_steps - 1]) {
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
