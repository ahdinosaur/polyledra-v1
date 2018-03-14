# chandeledra vertex circuit

## design

each vertex should inject power like [AllPixel Power Tap Kit](https://www.seeedstudio.com/AllPixel-Power-Tap-Kit-p-2380.html)

each led strip will use a 4 pin female header connector that can be plugged into 4 pin male headers on a circuit board: like [this](https://www.amazon.com/gp/product/B0777BQC1P/).

the led strips must be daisy chained as a single chain across the entire polyhedron, routed by each vertex.

since each edge has 3 channels, we can daisy chain a given edge internally (from here to there, to here, to there) so that it's the same as if there were 1 channel.

each vertex should encode the routing paths and be explicitly labelled, so once the chandeledra is setup once, you could tear it down and set it up within 30 minutes.
