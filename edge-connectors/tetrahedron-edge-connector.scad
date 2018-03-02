echo(version=version());

// https://en.wikipedia.org/wiki/Tetrahedron

// v1 = ( sqrt(8/9), 0 , -1/3 )
// v2 = ( -sqrt(2/9), sqrt(2/3), -1/3 )
// v3 = ( -sqrt(2/9), -sqrt(2/3), -1/3 )
// v4 = ( 0 , 0 , 1 )

// https://en.wikipedia.org/wiki/Spherical_coordinate_system

// radius = sqrt(a^2 + b^2 + c^2)
// inclination = arccos(z/r)
// azimuth = arctan(y/x)

// cartesian coordinate to spherical rotation
 //   radius = pow(x, 2) + pow(y, 2) + pow(z, 2);
//    inclination = acos(z / r);
//    azimuth = atan2(y, x);

ROT=360;
CAP_RADIUS=19;
CHANNEL_DEPTH = 10;
CHANNEL_LENGTH = 16;
ROD_RADIUS = 2;
ARM_HEIGHT= 30;
ARM_RADIUS = CHANNEL_LENGTH + 1;
INFINITESIMAL = 0.01;

function radius (x, y, z) = pow(x, 2) + pow(y, 2) + pow(z, 2);
function rotation (x, y, z) = [0, acos(z / radius(x, y, z)), atan2(y, x)];

arm_points = [
  [sqrt(8/9), 0, -4/3],
  [-sqrt(2/9), sqrt(2/3), -4/3],
  [-sqrt(2/9), -sqrt(2/3), -4/3]
];

for (arm_point = arm_points) {
  arm_rotation = rotation(arm_point[0], arm_point[1], arm_point[2]);
  echo(arm_rotation);
  
  rotate(a = arm_rotation)
  difference () {
    linear_extrude(height = ARM_HEIGHT)
    circle(r=ARM_RADIUS + ROD_RADIUS);
        
    for (i = [0 : 2]) {
      rotate(a = [0, 0, (1/3) * ROT * i])
      translate([ROD_RADIUS, ROD_RADIUS, ARM_HEIGHT - CHANNEL_DEPTH])
      cube([CHANNEL_LENGTH,CHANNEL_LENGTH, CHANNEL_DEPTH + INFINITESIMAL]);
    }
  }
}

sphere(r=CAP_RADIUS);