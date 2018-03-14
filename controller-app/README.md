# chandeledra pixel control

## usage

install rust

```shell
cargo run
```

![rainbow-tetrahedron](./images/rainbow-tetrahedron.gif)

## design

inputs:

- clock
- scene
- shape
  - edges
  - vertices
  - dots (pixels)
    - position [x, y, z]
    - edge
    - normal vector?
  - bounds
- TODO params (name, encoder value)
- TODO audio

on each clock tick, renders the scene (currently a function, maybe later use glsl).

a scene may update some internal state on each render.

outputs:

- in development, simulate leds with graphics renderer
- TODO apa102 spi interface (like [fastled](https://github.com/FastLED/FastLED))
