pub mod compute_edge_lengths;

fn mapf (x: f32, in_min: f32, in_max: f32, out_min: f32, out_max: f32) -> f32 {
  (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
}

fn mapl (x: f32, in_min: f32, in_max: f32, out_min: f32, out_max: f32) -> f32 {
  let min = out_min.log(2.);
  let max = out_max.log(2.);

  let scale = (max - min) / (in_max - in_min);

  (min + scale * (x - in_min)).exp()
}
