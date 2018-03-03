echo(version=version());

ROT=360;
INFINITESIMAL = 0.01;

EDGES_PER_VERTEX = 3;
CAP_RADIUS=19;
CHANNEL_DEPTH = 10;
CHANNEL_LENGTH = 16;
ROD_RADIUS = 2;
ARM_HEIGHT= 30;
ARM_RADIUS = CHANNEL_LENGTH + 1;

FILAMENT_WIDTH = 3;
MIN_ARC_FRAGMENT_ANGLE = 6;
MIN_ARC_FRAGMENT_SIZE = FILAMENT_WIDTH / 2;

arm_theta = 60;

for (arm_index = [0 : EDGES_PER_VERTEX]) {
  arm_phi = arm_index * (ROT / EDGES_PER_VERTEX);
    
  rotate(a = [0, arm_theta, arm_phi])
  difference () {
    cylinder(r=ARM_RADIUS + ROD_RADIUS, h= ARM_HEIGHT, $fa=MIN_ARC_FRAGMENT_ANGLE, $fs = MIN_ARC_FRAGMENT_SIZE);
        
    for (i = [0 : 2]) {
      rotate(a = [0, 0, (1/3) * ROT * i])
      translate([ROD_RADIUS, ROD_RADIUS, ARM_HEIGHT - CHANNEL_DEPTH])
      cube([CHANNEL_LENGTH,CHANNEL_LENGTH, CHANNEL_DEPTH + INFINITESIMAL]);
    }
  }
}

sphere(r=CAP_RADIUS, $fa = MIN_ARC_FRAGMENT_ANGLE, $fs = MIN_ARC_FRAGMENT_SIZE);