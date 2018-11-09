const CENTER = { x: 150, y: 100 }
const HEADER_RADIUS = 27
const CUT_RADIUS = 35

const HeaderComponent = require('./header')

const page = {
  type: 'A4',
  title: 'Example'
}

const nets = [
  {
    name: '+5V'
  },
  {
    name: 'GND'
  },
  {
    name: 'IO_TO_ARM_1_DATA'
  },
  {
    name: 'IO_TO_ARM_1_CLOCK'
  },
  {
    name: 'ARM_2_TO_ARM_3_DATA'
  },
  {
    name: 'ARM_2_TO_ARM_3_CLOCK'
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
      'IO_TO_ARM_1_DATA',
      'IO_TO_ARM_1_CLOCK',
      'ARM_2_TO_ARM_3_DATA',
      'ARM_2_TO_ARM_3_CLOCK'
    ]
  },
  {
    name: 'Power',
    description: 'default net class',
    clearance: 0.254,
    trace_width: 1,
    via_dia: 1.2,
    via_drill: 0.635,
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
      angle: 0
    },
    pads: [
      { net: 'GND' },
      { net: 'IO_TO_ARM_1_DATA' },
      { net: 'IO_TO_ARM_1_CLOCK' },
      { net: '+5V' }
    ]
  },
  {
    component: HeaderComponent,
    name: 'ARM_1',
    at: {
      x: CENTER.x + HEADER_RADIUS * Math.cos((1/4 + 1/3) * 2 * Math.PI),
      y: CENTER.y + HEADER_RADIUS * Math.sin((1/4 + 1/3) * 2 * Math.PI),
      angle: -(1/4 + 1/3) * 360
    },
    pads: [
      { net: 'GND' },
      { net: 'IO_TO_ARM_1_DATA' },
      { net: 'IO_TO_ARM_1_CLOCK' },
      { net: '+5V' }
    ]
  },
  {
    component: HeaderComponent,
    name: 'ARM_2',
    at: {
      x: CENTER.x + HEADER_RADIUS * Math.cos((1/4) * 2 * Math.PI),
      y: CENTER.y + HEADER_RADIUS * Math.sin((1/4) * 2 * Math.PI),
      angle: -(1/4) * 360
    },
    pads: [
      { net: 'GND' },
      { net: 'ARM_2_TO_ARM_3_DATA' },
      { net: 'ARM_2_TO_ARM_3_CLOCK' },
      { net: '+5V' }
    ]
  },
  {
    component: HeaderComponent,
    name: 'ARM_3',
    at: {
      x: CENTER.x + HEADER_RADIUS * Math.cos((1/4 + 2/3) * 2 * Math.PI),
      y: CENTER.y + HEADER_RADIUS * Math.sin((1/4 + 2/3) * 2 * Math.PI),
      angle: -(1/4 + 2/3) * 360
    },
    pads: [
      { net: 'GND' },
      { net: 'ARM_2_TO_ARM_3_DATA' },
      { net: 'ARM_2_TO_ARM_3_CLOCK' },
      { net: '+5V' }
    ]
  }
]


const tracks = [
/*
  {
    start: { x: 50, y: 50 },
    end: { x: 25, y: 25 },
    width: 0.254,
    layer: 'B.Cu',
    net: '+5V'
  },
  {
    start: { x: 61.0616, y: 34.5186 },
    end: { x: 62.23, y: 33.3502 },
    width: 0.254,
    layer: 'B.Cu',
    net: '+5V'
  },
  {
    start: { x: 69.85, y: 33.3502 },
    end: { x: 70.993, y: 33.3502 },
    width: 0.5,
    layer: 'B.Cu',
    net: 'GND'
  },
  {
    start: { x: 71.2216, y: 33.5788 },
    end: { x: 71.2216, y: 36.8808 },
    width: 0.5,
    layer: 'B.Cu',
    net: 'GND'
  },
  {
    start: { x: 70.993, y: 33.3502 },
    end: { x: 71.2216, y: 33.5788 },
    width: 0.5,
    layer: 'B.Cu',
    net: 'GND'
  },
*/
]


const graphics = [
  {
    type: 'line',
    start: { x: 0, y: 0 },
    end: { x: 50, y: 50 },
    angle: 90,
    layer: 'Edge.Cuts',
    width: 0.15
  },
  {
    type: 'line',
    start: { x: 50, y: 50 },
    end: { x: 0, y: 100 },
    angle: 90,
    layer: 'Edge.Cuts',
    width: 0.15
  },
  {
    type: 'line',
    start: { x: 0, y: 100 },
    end: { x: 0, y: 0 },
    angle: 90,
    layer: 'Edge.Cuts',
    width: 0.15
  }
]

const zones = [
  {
    net: 'GND',
    layer: 'B.Cu',
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
      pts: [
        { x: 0, y: 0 },
        { x: 50, y: 50 },
        { x: 0, y: 100 }
      ]
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
