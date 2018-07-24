
const args = process.argv.slice(2).map(Number)

console.log(polygon(...args))

function polygon (num_sides = 3, length = 1, start_x = 0, start_y = 0) {
  return Array.from(Array(num_sides).keys()).map(i => {
    const angle = i * 2 * Math.PI / num_sides
    return {
      x: start_x + length * Math.cos(angle),
      y: start_y + length * Math.sin(angle)
    }
  })
}
