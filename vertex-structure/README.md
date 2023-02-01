# polyledra vertex structure

## usage

install openscad

```
openscad cad/tetrahedron.scad
```

![tetrahedron vertex openscad](./images/tetrahedron-structure-openscad.png)

## design

each edge has 3 [CN-601A](https://www.walmart.ca/en/ip/3Pcs-CN-601A-1m-16mmx16mm-LED-Aluminum-Channel-System-w-Cover-for-LED-Strip/PRD67I4N8FXE8O8) channels.

![CN-601A diagram](./images/CN-601A-diagram.jpg)

each edge of the polyhedron will be 3 aluminum led channels in parallel.

each vertex will connect respective edges using a 3d-printed structure (for example, a vertex connecting 3 edges will connect 9 channels).

## maths

### tetrahedron

```
sin(phi) = x
sin^-1(x) = phi

h^2 + (1/2)^2 = 1^2
h = sqrt(3) / 2

h = x + w

tan(30) = w / (1/2)
w = (1/2)tan(30)

phi = sin^-1((sqrt(3)/2) - (1/2)tan(30))

30 from vertical
120 around vertical axis
120 again

nominate an axis as the pole
rotate your point towards the normal = latitude
rotate around the pole = longitude

phi = 35.26439
```

## octahedron

```
2a^2 = 1
a = sqrt(1/2)

sin(phi) = (a/1) = a = sqrt(1/2)
phi = sin^-1(sqrt(1/2))

phi = 45
```

## license

Copyright (c) Michael Williams
