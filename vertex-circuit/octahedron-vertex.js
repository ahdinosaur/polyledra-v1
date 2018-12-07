const {
  CENTER,
  HEADER_PITCH,
  CUT_RADIUS
} = require('./constants')

const CUT_SIDES = 2 * 4
const SCREW_RADIUS = 7
const CAP_OFFSET_Y = -4
const HEADER_RADIUS = 11

const Pcb = require('./lib/pcb')
const range = require('./lib/range')

const H2 = require('./components/h2')
const M4 = require('./components/m4-pad')
const Cap = require('./components/cap-radial-D8.0mm-P3.50mm.js')

var pcb = module.exports = Pcb({
  title: 'Tetrahedron Vertex',
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
      component: H2,
      at: {
        x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4) * 2 * Math.PI),
        y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4) * 2 * Math.PI),
        angle: (1/4) * 360
      },
      graphics: {
        reference: {
          content: 'J1'
        },
        value: {
          content: 'EDGE_1'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: '+5V' } }
      ]
    },
    {
      component: H2,
      at: {
        x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4 + 1/4) * 2 * Math.PI),
        y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4 + 1/4) * 2 * Math.PI),
        angle: (1/4 + 1/4) * 360
      },
      graphics: {
        reference: {
          content: 'J2'
        },
        value: {
          content: 'EDGE_2'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: '+5V' } }
      ]
    },
    {
      component: H2,
      at: {
        x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4 + 2/4) * 2 * Math.PI),
        y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4 + 2/4) * 2 * Math.PI),
        angle: (1/4 + 2/4) * 360
      },
      graphics: {
        reference: {
          content: 'J3'
        },
        value: {
          content: 'EDGE_3'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: '+5V' } }
      ]
    },
    {
      component: H2,
      at: {
        x: CENTER.x + HEADER_RADIUS * Math.cos(-(1/4 + 3/4) * 2 * Math.PI),
        y: CENTER.y + HEADER_RADIUS * Math.sin(-(1/4 + 3/4) * 2 * Math.PI),
        angle: (1/4 + 3/4) * 360
      },
      graphics: {
        reference: {
          content: 'J4'
        },
        value: {
          content: 'EDGE_4'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: '+5V' } }
      ]
    },
    {
      component: M4,
      at: {
        x: CENTER.x + SCREW_RADIUS * Math.cos((3/8 + 1/4) * 2 * Math.PI),
        y: CENTER.y + SCREW_RADIUS * Math.sin((3/8 + 1/4) * 2 * Math.PI)
      },
      graphics: {
        reference: {
          content: 'H1'
        },
        value: {
          content: 'M4 GND'
        },
      },
      pads: [
        { net: { name: 'GND' } }
      ]
    },
    {
      component: M4,
      at: {
        x: CENTER.x + SCREW_RADIUS * Math.cos((3/8 + 2/4) * 2 * Math.PI),
        y: CENTER.y + SCREW_RADIUS * Math.sin((3/8 + 2/4) * 2 * Math.PI)
      },
      graphics: {
        reference: {
          content: 'H2'
        },
        value: {
          content: 'M4 +5V'
        },
      },
      pads: [
        { net: { name: '+5V' } }
      ]
    },
    {
      component: Cap,
      at: {
        // -1.75 because Cap component is not yet centered,
        // so need to offset based on half the diameter.
        x: CENTER.x - 1.75,
        y: CENTER.y - CAP_OFFSET_Y
      },
      graphics: {
        reference: {
          content: 'C1'
        },
        value: {
          content: '1000uF Electrolytic Capacitor'
        },
      },
      pads: [
        { net: { name: 'GND' } },
        { net: { name: '+5V' } }
      ]
    }
  ],
  graphics: [
    ...range(CUT_SIDES).map(i => ({
      type: 'line',
      start: {
        x: CENTER.x + CUT_RADIUS * Math.cos((-1/16 + i / CUT_SIDES) * 2 * Math.PI),
        y: CENTER.y + CUT_RADIUS * Math.sin((-1/16 + i / CUT_SIDES) * 2 * Math.PI)
      },
      end: {
        x: CENTER.x + CUT_RADIUS * Math.cos((-1/16 + (i + 1) / CUT_SIDES) * 2 * Math.PI),
        y: CENTER.y + CUT_RADIUS * Math.sin((-1/16 + (i + 1) / CUT_SIDES) * 2 * Math.PI)
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
            x: CENTER.x + CUT_RADIUS * Math.cos((-1/16 + i / CUT_SIDES) * 2 * Math.PI),
            y: CENTER.y + CUT_RADIUS * Math.sin((-1/16 + i / CUT_SIDES) * 2 * Math.PI)
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
            x: CENTER.x + CUT_RADIUS * Math.cos((-1/16 + i / CUT_SIDES) * 2 * Math.PI),
            y: CENTER.y + CUT_RADIUS * Math.sin((-1/16 + i / CUT_SIDES) * 2 * Math.PI)
          }))
        }
      }
    }
  ]
})
