# chandeledra controller circuit

a [pocketbeagle](https://github.com/beagleboard/pocketbeagle)

## design

- 1x rotary encoder (eQEP)
  - with reset button
- param selector buttons (+ and -)
- mode selector buttons (+ and -)
- brightness potentiometer
- apa102 spi out

nice to have:

- microphone sensitivity potentiometer
- microphone in
- audio jack in

## sofar

```
3.3V ------|
           |
        switch
           |
           |
GPIO 27 ---|
           |
           |
        10k ohm resistor
           |
GND -------|
```
