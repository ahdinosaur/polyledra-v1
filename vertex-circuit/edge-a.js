const {
  CENTER,
  HEADER_RADIUS,
  HEADER_PITCH,
  SCREW_RADIUS,
  CUT_SIDES,
  CUT_RADIUS
} = require('./constants')

const add = require('./lib/add')
const pad_at = require('./lib/pad_at')
const Pcb = require('./lib/pcb')
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
      name: 'INPUT_DATA_TO_ARM_1_DATA'
    },
    {
      name: 'INPUT_CLOCK_TO_ARM_1_CLOCK'
    },
    {
      name: 'ARM_2_DATA_TO_ARM_3_DATA'
    },
    {
      name: 'ARM_2_CLOCK_TO_ARM_3_CLOCK'
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
        'INPUT_DATA_TO_ARM_1_DATA',
        'INPUT_CLOCK_TO_ARM_1_CLOCK',
        'ARM_2_DATA_TO_ARM_3_DATA',
        'ARM_2_CLOCK_TO_ARM_3_CLOCK'
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
          content: 'INPUT'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: 'INPUT_DATA_TO_ARM_1_DATA' } },
        { net: { name: 'INPUT_CLOCK_TO_ARM_1_CLOCK' } }
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
          content: 'ARM_1'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: 'INPUT_DATA_TO_ARM_1_DATA' } },
        { net: { name: 'INPUT_CLOCK_TO_ARM_1_CLOCK' } },
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
          content: 'ARM_2'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: 'ARM_2_DATA_TO_ARM_3_DATA' } },
        { net: { name: 'ARM_2_CLOCK_TO_ARM_3_CLOCK' } },
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
          content: 'ARM_3'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: 'ARM_2_DATA_TO_ARM_3_DATA' } },
        { net: { name: 'ARM_2_CLOCK_TO_ARM_3_CLOCK' } },
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
        { net: { name: '+5V' } }
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

const INPUT = pcb.modules[0]
const POWER = pcb.modules[1]
const ARM_1 = pcb.modules[2]
const ARM_2 = pcb.modules[3]
const ARM_3 = pcb.modules[4]


pcb.tracks = [
  // INPUT TO ARM 1 (except GND and 5V)
  ...range(1, H4.pads.length - 1).map(index => {
    const net = INPUT.pads[index].net
    const net_class = pcb.net_classes.find(net_class => net_class.add_net.includes(net.name))

    return {
      start: pad_at(INPUT, index),
      end: pad_at(ARM_1, index),
      width: net_class.trace_width,
      layer: 'F.Cu',
      net
    }
  }),
  // ARM 1 TO ARM 2 (except GND and 5v)
  {
    start: pad_at(ARM_2, 1),
    end: {
      x: pad_at(ARM_2, 1).x + HEADER_PITCH,
      y: pad_at(ARM_2, 1).y + (1/2) * HEADER_PITCH,
    },
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_2.pads[1].net
  },
  {
    start: {
      x: pad_at(ARM_2, 1).x + HEADER_PITCH,
      y: pad_at(ARM_2, 1).y + (1/2) * HEADER_PITCH,
    },
    end: {
      x: pad_at(ARM_3, 1).x - HEADER_PITCH,
      y: pad_at(ARM_3, 1).y + (1/2) * HEADER_PITCH,
    },
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_2.pads[1].net
  },
  {
    start: {
      x: pad_at(ARM_3, 1).x - HEADER_PITCH,
      y: pad_at(ARM_3, 1).y + (1/2) * HEADER_PITCH,
    },
    end: pad_at(ARM_3, 1),
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_2.pads[1].net
  },
  {
    start: pad_at(ARM_2, 2),
    end: pad_at(ARM_3, 2),
    width: DEFAULT_NET_CLASS.trace_width,
    layer: 'F.Cu',
    net: ARM_2.pads[2].net
  },
]
