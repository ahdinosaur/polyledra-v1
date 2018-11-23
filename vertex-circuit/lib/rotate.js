module.exports = rotate

// https://stackoverflow.com/a/2259502
function rotate (point, center, angle) {
  var s = Math.sin(angle * (2 * Math.PI / 360))
  var c = Math.cos(angle * (2 * Math.PI / 360))

  // translate point back to origin:
  var centered = {
    x: point.x - center.x,
    y: point.y - center.y
  }

  // rotate point
  var next_point = {
    x: centered.x * c + centered.y * s,
    y: -centered.x * s + centered.y * c,
  }

  // translate point back:
  return {
    x: next_point.x + center.x,
    y: next_point.y + center.y,
  }
}
