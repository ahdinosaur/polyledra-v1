const CENTER = { x: 150, y: 100 }
const HEADER_RADIUS = 15
const CUT_RADIUS = 20
const CUT_SIDES = 6

const HeaderComponent = require('./header')

const page = {
  type: 'A4',
  title: 'Polyledra Edge'
}

const nets = [
  {
    name: '+5V'
  },
  {
    name: 'GND'
  },
  {
    name: 'IO_DATA_TO_ARM_1_DATA'
  },
  {
    name: 'IO_CLOCK_TO_ARM_1_CLOCK'
  },
  {
    name: 'ARM_2_DATA_TO_ARM_3_DATA'
  },
  {
    name: 'ARM_2_CLOCK_TO_ARM_3_CLOCK'
  }
]

const net_classes = [
  {
    name: 'Default',
    description: 'default net class',
    clearance: 0.254,
    trace_width: 0.254,
    via_dia: 0.6858,
    via_drill: 0.3302,
    nets: [
      'IO_DATA_TO_ARM_1_DATA',
      'IO_CLOCK_TO_ARM_1_CLOCK',
      'ARM_2_DATA_TO_ARM_3_DATA',
      'ARM_2_CLOCK_TO_ARM_3_CLOCK'
    ]
  },
  {
    name: 'Power',
    description: 'default net class',
    clearance: 0.5,
    trace_width: 1.7,
    via_dia: 1.7,
    via_drill: 0.8,
    nets: [
      '+5V',
      'GND'
    ]
  },
]

const modules = [
  {
    component: HeaderComponent,
    name: 'IO',
    at: {
      x: CENTER.x,
      y: CENTER.y,
      angle: -(1/4) * 360
    },
    pads: [
      { net: 'GND' },
      { net: 'IO_DATA_TO_ARM_1_DATA' },
      { net: 'IO_CLOCK_TO_ARM_1_CLOCK' },
      { net: '+5V' }
    ]
  },
  {
    component: HeaderComponent,
    name: 'ARM_1',
    at: {
      x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4) * 2 * Math.PI),
      y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4) * 2 * Math.PI),
      angle: -(1/4) * 360
    },
    pads: [
      { net: 'GND' },
      { net: 'IO_DATA_TO_ARM_1_DATA' },
      { net: 'IO_CLOCK_TO_ARM_1_CLOCK' },
      { net: '+5V' }
    ]
  },
  {
    component: HeaderComponent,
    name: 'ARM_2',
    at: {
      x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4 + 1/3) * 2 * Math.PI),
      y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4 + 1/3) * 2 * Math.PI),
      angle: (-1/4 + 1/3) * 360 + 180
    },
    pads: [
      { net: 'GND' },
      { net: 'ARM_2_DATA_TO_ARM_3_DATA' },
      { net: 'ARM_2_CLOCK_TO_ARM_3_CLOCK' },
      { net: '+5V' }
    ]
  },
  {
    component: HeaderComponent,
    name: 'ARM_3',
    at: {
      x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4 + 2/3) * 2 * Math.PI),
      y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4 + 2/3) * 2 * Math.PI),
      angle: (-1/4 + 2/3) * 360
    },
    pads: [
      { net: 'GND' },
      { net: 'ARM_2_DATA_TO_ARM_3_DATA' },
      { net: 'ARM_2_CLOCK_TO_ARM_3_CLOCK' },
      { net: '+5V' }
    ]
  }
]

const tracks = [
]

const graphics = [
  ...range(CUT_SIDES).map(i => ({
    type: 'line',
    start: {
      x: CENTER.x + CUT_RADIUS * Math.cos((i / CUT_SIDES) * 2 * Math.PI),
      y: CENTER.y + CUT_RADIUS * Math.sin((i / CUT_SIDES) * 2 * Math.PI)
    },
    end: {
      x: CENTER.x + CUT_RADIUS * Math.cos(((i + 1) / CUT_SIDES) * 2 * Math.PI),
      y: CENTER.y + CUT_RADIUS * Math.sin(((i + 1) / CUT_SIDES) * 2 * Math.PI)
    },
    angle: 90,
    layer: 'Edge.Cuts',
    width: 0.15
  }))
]

const zones = [
  {
    net: 'GND',
    layer: 'F.Cu',
    hatch: { edge: 0.508 },
    connect_pads: {
      clearance: 0.2
    },
    min_thickness: 0.1778,
    fill: {
      arc_segments: 16,
      thermal_gap: 0.254,
      thermal_bridge_width: 0.4064
    },
    polygon: {
      pts: range(CUT_SIDES + 1).map(i => ({
        x: CENTER.x + CUT_RADIUS * Math.cos(((i / CUT_SIDES)) * 2 * Math.PI),
        y: CENTER.y + CUT_RADIUS * Math.sin(((i / CUT_SIDES)) * 2 * Math.PI)
      }))
    }
  }
]

module.exports = {
  graphics,
  modules,
  nets,
  net_classes,
  page,
  tracks,
  zones
}

function range (n) {
  return [...Array(n).keys()]
}
