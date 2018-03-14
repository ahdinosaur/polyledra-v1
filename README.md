# chandeledra

[light-emitting](https://en.wikipedia.org/wiki/Light-emitting_diode) [polyhedron](https://en.wikipedia.org/wiki/Polyhedron) [chandeliers](https://en.wikipedia.org/wiki/Chandelier)

![rainbow-tetrahedron](./controller-app/images/rainbow-tetrahedron.gif)

## background

after playing with [aburndance](https://github.com/ahdinosaur/aburndance), i thought about my learning objectives for the [next stage of portable rainbow exploration](https://viewer.scuttlebot.io/%25sO9UYU8pod1sS7JlpX15rfEtGMZ6znMxZEySYql221Q%3D.sha256):

- i want to go [back to the BeagleBone](https://github.com/ahdinosaur/pixelbeat/tree/bbb), but this time using Rust instead of JavaScript
- i want to get [back into 3d printing](https://github.com/ahdinosaur/prusa-mendel) for enclosures and structures
- i want to upgrade from breadboards to protoboards to custom pcb circuits, out-source soldering!
- i want to play with graphics code

i was sitting on a hill listening to music at a gathering in the forest last weekend, when i saw a 20-sided shape hanging over a stage, with fairy lights strung around the edges. :sparkles:

i thought "what if i did the same with leds"? :rainbow:

i then continued to spend the rest of the festival obsessing about the shape, leds, and rust interfaces, which led to here. :cat:

## sub-projects

- [`shapes`](./shapes): playing with polyhedra shapes
- [`controller-app`](./controller-app): a rust app to control the led pixels by rendering scenes
- [`controller-circuit`](./controller-circuit): a circuit for the BeagleBone controller
- [`vertex-structure`](./vertex-structure): a 3d model for the vertex structure(s) that connect the polyhedron's edge channels
- [`vertex-circuit`](./vertex-circuit): a circuit to daisy chain the leds and inject power
