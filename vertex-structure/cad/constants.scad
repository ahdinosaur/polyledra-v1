MM = 1;
CM = 10 * MM;
DM = 100 * MM;
M = 1000 * MM;

X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

ROT=360;
INFINITESIMAL = 0.01;
INFINITY = 1000;

FILAMENT_WIDTH = 3;
MIN_ARC_FRAGMENT_ANGLE = 6;
MIN_ARC_FRAGMENT_SIZE = FILAMENT_WIDTH / 2;

LAYER_HEIGHT = 0.2;
NOZZLE_WIDTH = 0.4;

// https://www.reddit.com/r/3Dprinting/comments/42mwhw/fdm_and_tolerances/czbj3b6/
XY_TOLERANCE = NOZZLE_WIDTH;
Z_TOLERANCE = LAYER_HEIGHT;
