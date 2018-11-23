module.exports = Pcb

function Pcb (options) {
  const {
    title,
    nets,
    net_classes,
    modules,
    graphics,
    zones
  } = options

  return {
    general: {
      page: 'A4',
      title,
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
    nets,
    net_classes,
    modules,
    graphics,
    zones
  }
}
