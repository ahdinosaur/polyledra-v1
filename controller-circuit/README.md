# chandeledra controller circuit

a [pocketbeagle](https://github.com/beagleboard/pocketbeagle)

## design

- 6x mode buttons
- apa102 spi out
- power in

nice to have:

- 1x rotary encoder (eQEP)
  - with reset button
- brightness potentiometer
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
