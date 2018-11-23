const {
  CENTER,
  HEADER_RADIUS,
  HEADER_PITCH,
  SCREW_RADIUS,
  CUT_SIDES,
  CUT_RADIUS
} = require('./constants')

const H4 = require('./components/h4')
const H3 = require('./components/h3')
const H2 = require('./components/h2')
const M3 = require('./components/m3')

var pcb = module.exports = {
  general: {
    page: 'A4',
    title: 'Polyledra Edge',
    area: [
      104.572999,
      74.854999,
      178.510001,
      123.265001
    ],
    thickness: 1.6,
    setup: {
      last_trace_width: 0.254,
      user_trace_width: [
        0.1524,
        0.254,
        0.3302,
        0.508,
        0.762,
        1.27
      ],
      trace_clearance: 0.254,
      zone_clearance: 0.508,
      zone_45_only: 'no',
      trace_min: 0.1524,
      segment_width: 0.1524,
      edge_width: 0.1524,
      via_size: 0.6858,
      via_drill: 0.3302,
      via_min_size: 0.6858,
      via_min_drill: 0.3302,
      user_via: [
        [
          0.6858,
          0.3302
        ],
        [
          0.762,
          0.4064
        ],
        [
          0.8636,
          0.508
        ]
      ],
      uvia_size: 0.6858,
      uvia_drill: 0.3302,
      uvias_allowed: 'no',
      uvia_min_size: 0,
      uvia_min_drill: 0,
      pcb_text_width: 0.1524,
      pcb_text_size: [
        1.016,
        1.016
      ],
      mod_edge_width: 0.1524,
      mod_text_size: [
        1.016,
        1.016
      ],
      mod_text_width: 0.1524,
      pad_size: [
        1.524,
        1.524
      ],
      pad_drill: 0.762,
      pad_to_mask_clearance: 0.0762,
      solder_mask_min_width: 0.1016,
      pad_to_paste_clearance: -0.0762,
      aux_axis_origin: [
        0,
        0
      ],
      visible_elements: 'FFFEDF7D',
      pcbplotparams: {
        layerselection: '0x310fc_80000001',
        usegerberextensions: 'true',
        excludeedgelayer: 'true',
        linewidth: 0.1,
        plotframeref: 'false',
        viasonmask: 'false',
        mode: 1,
        useauxorigin: 'false',
        hpglpennumber: 1,
        hpglpenspeed: 20,
        hpglpendiameter: 15,
        hpglpenoverlay: 2,
        psnegative: 'false',
        psa4output: 'false',
        plotreference: 'true',
        plotvalue: 'true',
        plotinvisibletext: 'false',
        padsonsilk: 'false',
        subtractmaskfromsilk: 'false',
        outputformat: 1,
        mirror: 'false',
        drillshape: 0,
        scaleselection: 1,
        outputdirectory: 'gerbers'
      }
    },
  },
  layers: {
    '0': [ 'F.Cu', 'signal' ],
    '31': [ 'B.Cu', 'signal' ],
    '34': [ 'B.Paste', 'user' ],
    '35': [ 'F.Paste', 'user' ],
    '36': [ 'B.SilkS', 'user' ],
    '37': [ 'F.SilkS', 'user' ],
    '38': [ 'B.Mask', 'user' ],
    '39': [ 'F.Mask', 'user' ],
    '40': [ 'Dwgs.User', 'user' ],
    '44': [ 'Edge.Cuts', 'user' ],
    '46': [ 'B.CrtYd', 'user' ],
    '47': [ 'F.CrtYd', 'user' ],
    '48': [ 'B.Fab', 'user' ],
    '49': [ 'F.Fab', 'user' ]
  },
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
          content: 'J3',
          at: { x: 2.3495, y: -0.3175 }
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
          content: 'J4'
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
          content: 'J5',
          at: { x: 2.3495, y: -0.3175 }
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
}

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

function add (a, b) {
  return {
    x: a.x + b.x,
    y: a.y + b.y
  }
}

function range (...args) {
  var start = 0
  var end = 1
  if (args.length === 2) {
    [start, end] = args
  } else {
    [end] = args
  }
  var keys = [...Array(end - start).keys()]
  return keys.map(index => index + start)
}

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
