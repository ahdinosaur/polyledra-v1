const {
  CENTER,
  HEADER_RADIUS,
  HEADER_PITCH,
  SCREW_RADIUS,
  CUT_SIDES,
  CUT_RADIUS
} = require('./constants')

const add = require('./lib/add')
const Pcb = require('./lib/pcb')
const pad_at = require('./lib/pad_at')
const range = require('./lib/range')
const rotate = require('./lib/rotate')

const H4 = require('./components/h4')
const H3 = require('./components/h3')
const H2 = require('./components/h2')
const M3 = require('./components/m3')

var pcb = module.exports = Pcb({
  title: 'Polyledra Edge',
  nets: [
    {
      name: '+5V'
    },
    {
      name: 'GND'
    },
    {
      name: 'ARM_1_DATA_TO_ARM_2_DATA'
    },
    {
      name: 'ARM_1_CLOCK_TO_ARM_2_CLOCK'
    },
    {
      name: 'ARM_3_DATA_TO_OUTPUT_DATA'
    },
    {
      name: 'ARM_3_CLOCK_TO_OUTPUT_CLOCK'
    }
  ],
  net_classes: [
    {
      name: 'Default',
      description: 'default net class',
      clearance: 0.254,
      trace_width: 0.254,
      via_dia: 0.6858,
      via_drill: 0.3302,
      uvia_dia: 0.6858,
      uvia_drill: 0.3302,
      add_net: [
        'ARM_1_DATA_TO_ARM_2_DATA',
        'ARM_1_CLOCK_TO_ARM_2_CLOCK',
        'ARM_3_DATA_TO_OUTPUT_DATA',
        'ARM_3_CLOCK_TO_OUTPUT_CLOCK'
      ]
    },
    {
      name: 'Power',
      description: 'net class for high-power',
      clearance: 0.4,
      trace_width: 1.5,
      via_dia: 1.5,
      via_drill: 0.8,
      uvia_dia: 1.5,
      uvia_drill: 0.8,
      add_net: [
        '+5V',
        'GND'
      ]
    }
  ],
  modules: [
    {
      component: H3,
      at: {
        x: CENTER.x,
        y: CENTER.y - HEADER_PITCH,
        angle: (1/4) * 360
      },
      graphics: {
        reference: {
          content: 'J1'
        },
        value: {
          content: 'OUTPUT'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: 'ARM_3_DATA_TO_OUTPUT_DATA' } },
        { net: { name: 'ARM_3_CLOCK_TO_OUTPUT_CLOCK' } }
      ]
    },
    {
      component: H2,
      at: {
        x: CENTER.x,
        y: CENTER.y + HEADER_PITCH,
        angle: (1/4) * 360
      },
      graphics: {
        reference: {
          content: 'J2'
        },
        value: {
          content: 'POWER'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: '+5V' } },
      ]
    },
    {
      component: H4,
      at: {
        x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4) * 2 * Math.PI),
        y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4) * 2 * Math.PI),
        angle: (1/4) * 360
      },
      graphics: {
        reference: {
          content: 'J3'
        },
        value: {
          content: 'ARM_1_IN'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: 'ARM_1_DATA_TO_ARM_2_DATA' } },
        { net: { name: 'ARM_1_CLOCK_TO_ARM_2_CLOCK' } },
        { net: { name: '+5V' } }
      ]
    },
    {
      component: H4,
      name: 'ARM_2',
      at: {
        x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4 + 1/3) * 2 * Math.PI),
        y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4 + 1/3) * 2 * Math.PI),
        angle: (1/4 + 1/3) * 360 + 180
      },
      graphics: {
        reference: {
          content: 'J4',
          at: { x: 2.3495, y: -0.3175 }
        },
        value: {
          content: 'ARM_2_OUT'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: 'ARM_1_DATA_TO_ARM_2_DATA' } },
        { net: { name: 'ARM_1_CLOCK_TO_ARM_2_CLOCK' } },
        { net: { name: '+5V' } }
      ]
    },
    {
      component: H4,
      at: {
        x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4 + 2/3) * 2 * Math.PI),
        y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4 + 2/3) * 2 * Math.PI),
        angle: (1/4 + 2/3) * 360
      },
      graphics: {
        reference: {
          content: 'J5'
        },
        value: {
          content: 'ARM_3_IN'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: 'ARM_3_DATA_TO_OUTPUT_DATA' } },
        { net: { name: 'ARM_3_CLOCK_TO_OUTPUT_CLOCK' } },
        { net: { name: '+5V' } }
      ]
    },
    {
      component: M3,
      at: {
        x: CENTER.x + SCREW_RADIUS * Math.cos((1/4 + 1/3) * 2 * Math.PI),
        y: CENTER.y + SCREW_RADIUS * Math.sin((1/4 + 1/3) * 2 * Math.PI)
      },
      graphics: {
        reference: {
          content: 'H1'
        },
        value: {
          content: 'M3'
        },
      },
      pads: [
        { net: { name: 'GND' } }
      ]
    },
    {
      component: M3,
      at: {
        x: CENTER.x + SCREW_RADIUS * Math.cos((1/4 + 2/3) * 2 * Math.PI),
        y: CENTER.y + SCREW_RADIUS * Math.sin((1/4 + 2/3) * 2 * Math.PI)
      },
      graphics: {
        reference: {
          content: 'H2'
        },
        value: {
          content: 'M3'
        },
      },
      pads: [
        { net: { name: 'GND' } }
      ]
    }
  ],
  graphics: [
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
  ],
  zones: [
    {
      net: { name: 'GND' },
      layer: 'F.Cu',
      hatch: [ 'edge', 0.508 ],
      min_thickness: 0.1778,
      connect_pads: {
        clearance: 0.2
      },
      fill: {
        arc_segments: 16,
        thermal_gap: 0.254,
        thermal_bridge_width: 0.4064
      },
      polygon: {
        pts: {
          xy: range(CUT_SIDES + 1).map(i => ({
            x: CENTER.x + CUT_RADIUS * Math.cos(((i / CUT_SIDES)) * 2 * Math.PI),
            y: CENTER.y + CUT_RADIUS * Math.sin(((i / CUT_SIDES)) * 2 * Math.PI)
          }))
        }
      }
    },
    {
      net: { name: '+5V' },
      layer: 'B.Cu',
      hatch: [ 'edge', 0.508 ],
      min_thickness: 0.1778,
      connect_pads: {
        clearance: 0.2
      },
      fill: {
        arc_segments: 16,
        thermal_gap: 0.254,
        thermal_bridge_width: 0.4064
      },
      polygon: {
        pts: {
          xy: range(CUT_SIDES + 1).map(i => ({
            x: CENTER.x + CUT_RADIUS * Math.cos(((i / CUT_SIDES)) * 2 * Math.PI),
            y: CENTER.y + CUT_RADIUS * Math.sin(((i / CUT_SIDES)) * 2 * Math.PI)
          }))
        }
      }
    }
  ]
})

const DEFAULT_NET_CLASS = pcb.net_classes[0]
const POWER_NET_CLASS = pcb.net_classes[1]

const OUTPUT = pcb.modules[0]
const POWER = pcb.modules[1]
const ARM_1 = pcb.modules[2]
const ARM_2 = pcb.modules[3]
const ARM_3 = pcb.modules[4]


pcb.tracks = [
  // ARM_1 TO ARM_2
  // pin 2
  {
    start: pad_at(ARM_1, 1),
    end: add(
      pad_at(ARM_1, 1),
      { x: 0, y: HEADER_PITCH }
    ),
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_1.pads[1].net
  },
  {
    start: add(
      pad_at(ARM_1, 1),
      { x: 0, y: HEADER_PITCH }
    ),
    end: {
      x: pad_at(OUTPUT, 0).x - HEADER_PITCH,
      y: pad_at(ARM_1, 1).y + HEADER_PITCH,
    },
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_1.pads[1].net
  },
  {
    start: {
      x: pad_at(OUTPUT, 0).x - HEADER_PITCH,
      y: pad_at(ARM_1, 1).y + HEADER_PITCH,
    },
    end: {
      x: pad_at(OUTPUT, 0).x - HEADER_PITCH,
      y: pad_at(ARM_2, 1).y,
    },
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_1.pads[1].net
  },
  {
    start: {
      x: pad_at(OUTPUT, 0).x - HEADER_PITCH,
      y: pad_at(ARM_2, 1).y,
    },
    end: pad_at(ARM_2, 1),
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_1.pads[1].net
  },
  // pin 3
  {
    start: pad_at(ARM_1, 2),
    end: add(
      pad_at(ARM_1, 2),
      { x: 0, y: (4/3) * HEADER_PITCH }
    ),
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_1.pads[2].net
  },
  {
    start: add(
      pad_at(ARM_1, 2),
      { x: 0, y: (4/3) * HEADER_PITCH }
    ),
    end: {
      x: pad_at(OUTPUT, 0).x - (2/3) * HEADER_PITCH,
      y: pad_at(ARM_1, 2).y + (4/3) * HEADER_PITCH,
    },
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_1.pads[2].net
  },
  {
    start: {
      x: pad_at(OUTPUT, 0).x - (2/3) * HEADER_PITCH,
      y: pad_at(ARM_1, 2).y + (4/3) * HEADER_PITCH,
    },
    end: {
      x: pad_at(OUTPUT, 0).x - (2/3) * HEADER_PITCH,
      y: pad_at(ARM_2, 2).y,
    },
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_1.pads[2].net
  },
  {
    start: {
      x: pad_at(OUTPUT, 0).x - (2/3) * HEADER_PITCH,
      y: pad_at(ARM_2, 2).y,
    },
    end: pad_at(ARM_2, 2),
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_1.pads[2].net
  },
  // ARM 3 TO OUTPUT
  {
    start: pad_at(ARM_3, 1),
    end: pad_at(OUTPUT, 1),
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_3.pads[1].net
  },
  {
    start: pad_at(ARM_3, 2),
    end: pad_at(OUTPUT, 2),
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'B.Cu',
    net: ARM_3.pads[2].net
  }
]
