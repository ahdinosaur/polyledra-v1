const add = require('./add')
const rotate = require('./rotate')

module.exports = pad_at

function pad_at (module, index) {
  const component_pad = module.component.pads[index]
  const component_at = component_pad.at
  const module_at = module.at
  const center = { x: 0, y: 0 }
  const angle = module.at.angle || 0
  const rotated_component_at = rotate(component_at, center, angle)
  const value = add(rotated_component_at, module_at)
  return value
}
