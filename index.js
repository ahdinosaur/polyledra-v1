var createScene = require('gl-plot3d')
var createMesh = require('gl-mesh3d')

var scene = createScene()

function geoelongatedPentagonalDipyramid (length) {
  var shape = {
    positions: [],
    cells: [
      // upper pyramid
      [0, 1, 2],
      [0, 2, 3],
      [0, 3, 4],
      [0, 4, 5],
      [0, 5, 1],

      // anti-prism
      [1, 6, 2],
      [6, 2, 7],
      [2, 7, 3],
      [7, 3, 8],
      [3, 8, 4],
      [8, 4, 9],
      [4, 9, 5],
      [9, 5, 10],
      [5, 10, 1],
      [10, 1, 6],

      // lower pyramid
      [11, 6, 7],
      [11, 7, 8],
      [11, 8, 9],
      [11, 9, 10],
      [11, 10, 6]
    ]
  }

  const height = (1/2) * Math.sqrt(3) * length

  // top of upper pyramid: 0
  shape.positions.push([0, 0, 0])

  // bottom of upper pyramid / top of antiprism: 1-5
  polygon(
    { n: 5, r: 1, center: { x: 0, y: 0 } },
    ({ i, x, y }) => {
      shape.positions.push([x, y, height])
    }
  )

  // top of lower pyramid / bottom of antiprism: 6-10
  polygon(
    { n: 5, r: 1, center: { x: 0, y: 0 } },
    ({ i, x, y }) => {
      shape.positions.push([x, y, height * 2])
    }
  )

  // bottom of lower pyramid: 11
  shape.positions.push([0, 0, height * 3])

  console.log('shape', shape)

  return shape
}

var shape = geoelongatedPentagonalDipyramid(1)

var mesh = createMesh({
  gl: scene.gl,
  cells: shape.cells,
  positions: shape.positions,
  colormap: 'jet'
})

scene.add(mesh)

function polygon ({ n, r, center }, cb) {
  for (i = 0; i < n; i++) {
    const x = center.x + r * Math.cos(2 * Math.PI * i / n)
    const y = center.y + r * Math.sin(2 * Math.PI * i / n)
    cb({ i, x, y })
  }
}
