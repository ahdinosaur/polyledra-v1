echo(version=version());

ROT = 360;
HEIGHT = 1000;

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
function radius (x, y, z) = pow(x, 2) + pow(y, 2) + pow(z, 2);
function rotation (x, y, z) = [0, acos(z / radius(x, y, z)), atan2(y, x)];

echo(rotation(sqrt(8/9), 0, -4/3));
echo(rotation(sqrt(8/9), 0, -4/3));
echo(rotation(-sqrt(2/9), -sqrt(2/3), -4/3 ));

color("red")
    rotate(a = rotation(sqrt(8/9), 0, -4/3))
        linear_extrude(height = HEIGHT)
            circle(r=5);

color("green")
    rotate(a = rotation(-sqrt(2/9), sqrt(2/3), -4/3 ))
        linear_extrude(height = HEIGHT)
            circle(r=5);
            
  color("blue")
    rotate(a = rotation(-sqrt(2/9), -sqrt(2/3), -4/3 ))
        linear_extrude(height = HEIGHT)
            circle(r=5);