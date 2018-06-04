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

## installations

if you are playing with `chandeledra`, i'd love to hear about it!

- https://twitter.com/ahdinosaur/status/962158033764691968

## license

copyright (c) Michael Williams 2018

licensed under [creative commons cc-by-sa-nc 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)

[![creative commons license](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

you are free to:

- share: copy and redistribute the material in any medium or format 
- adapt: remix, transform, and build upon the material

under the following terms:

- attribution: you must give appropriate credit, provide a link to the license, and indicate if changes were made. you may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
- non-commercial: you may not use the material for commerical purposes.
- share-alike: if you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
