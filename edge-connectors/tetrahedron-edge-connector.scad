echo(version=version());

ROT = 360;
HEIGHT = 1000;

color("red")
    rotate(a = [0, -30, -60])
        linear_extrude(height = HEIGHT)
            circle(r=5);

color("green")
    rotate(a = [0, -30, 60])
        linear_extrude(height = HEIGHT)
            circle(r=5);
            
  color("blue")
    rotate(a = [0, 30, 0])
        linear_extrude(height = HEIGHT)
            circle(r=5);
            
            
  /*
  
// Simple example with a single function argument (which should
// be a number) and returning a number calculated based on that.
function f(x) = 0.5 * x + 1;

// Functions can call other functions and return complex values
// too. In this case a 3 element vector is returned which can
// be used as point in 3D space or as vector (in the mathematical
// meaning) for translations and other transformations.
function g(x) = [ 5 * x + 20, f(x) * f(x) - 50, 0 ];

*/