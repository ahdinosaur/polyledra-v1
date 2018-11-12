const KISYS3DMOD = process.env.KISYS3DMOD || '/usr/share/kicad/modules/packages3d/'

/*
  -1.27 = -5.08 (left edge)
  8.89 = 5.08 (right edge)
  -0.635 = -4.445 (in between left edge and first pin)
  0.635 = -3.175 (in between first pin and first edge)
  8.95 = 5.13 (right edge + 0.05)
  1.27 = -2.54
  -1.33 = -5.13
  -1.8 = -5.61
  9.4 = 5.61
  0 = -3.81
  */

  /*
  (fp_text reference ${module.name} (at -2.3495 -0.3175 360) (layer F.SilkS)
    (effects (font (size 1 1) (thickness 0.15)))
  )
  */

module.exports = {
  name: 'H4-2.54mm',
  description: 'Through hole straight pin header, 1x04, 2.54mm pitch, single row',
  tags: 'Through hole pin header THT 1x04 2.54mm single row',
  graphics: (graphics) => {
    const {
      reference = {},
      value = {},
    } = graphics

    return [
      {
        type: 'text',
        id: 'reference',
        content: reference.content || '**REF**',
        at: reference.at || { x: -2.3495, y: -0.3175 },
        layer: reference.layer || 'F.SilkS',
        effects: {
          font: {
            size: { x: 1, y: 1 },
            thickness: 0.15
          }
        }
      },
      {
        type: 'text',
        id: 'value',
        content: value.content || '**VALUE**',
        at: value.at || { x: 0, y: 9.95 },
        layer: value.layer || 'F.Fab',
        effects: {
          font: {
            size: { x: 1, y: 1 },
            thickness: 0.15
          }
        }
      },
      {
        type: 'line',
        start: { x: -0.635, y: -5.08 },
        end: { x: 1.27, y: -5.08 },
        layer: 'F.Fab',
        width: 0.1
      },
      {
        type: 'line',
        start: { x: 1.27, y: -5.08 },
        end: { x: 1.27, y: 5.08 },
        layer: 'F.Fab',
        width: 0.1
      },
      {
        type: 'line',
        start: { x: 1.27, y: 5.08 },
        end: { x: -1.27, y: 5.08 },
        layer: 'F.Fab',
        width: 0.1
      },
      {
        type: 'line',
        start: { x: -1.27, y: 5.08 },
        end: { x: -1.27, y: -4.445 },
        layer: 'F.Fab',
        width: 0.1
      },
      {
        type: 'line',
        start: { x: -1.27, y: -4.44 },
        end: { x: end -0.635, y: -5.08 },
        layer: 'F.Fab',
        width: 0.1
      },
      {
        type: 'line',
        start: { x: -1.33, y: 5.13 },
        end: { x: 1.33, y: 5.13 },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: { x: -1.33, y: -2.54 },
        end: { x: -1.33, y: 5.13 },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: { x: 1.33, y: -2.54 },
        end: { x: 1.33, y: 5.13 },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: { x: -1.33, y: -2.54 },
        end: { x: 1.33, y: -2.54 },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: { x: -1.33, y: -3.81 },
        end: { x: -1.33, y: -5.13 },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: { x: -1.33, y: -5.13 },
        end: { x: 0, y: -5.13 },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: { x: -1.8, y: -5.61 },
        end: { x: -1.8, y: 5.61 },
        layer: 'F.CrtYd',
        width: 0.05
      },
      {
        type: 'line',
        start: { x: -1.8, y: 5.61 },
        end: { x: 1.8, y: 5.61 },
        layer: 'F.CrtYd',
        width: 0.05
      },
      {
        type: 'line',
        start: { x: 1.8, y: 5.61 },
        end: { x: 1.8, y: -5.61 },
        layer: 'F.CrtYd',
        width: 0.05
      },
      {
        type: 'line',
        start: { x: 1.8, y: -5.61 },
        end: { x: -1.8, y: -5.61 },
        layer: 'F.CrtYd',
        width: 0.05
      },
      {
        type: 'text',
        id: 'user',
        content: '%R',
        at: { x: 0, y: 0, angle: 90 },
        layer: 'F.Fab',
        effects: {
          font: {
            size: { x: 1, y: 1 },
            thickness: 0.15
          }
        }
      }
    ]
  },
  pads: [
    {
      type: 'thru_hole',
      shape: 'rect',
      at: { x: 0, y: -3.81 },
      size: { x: 1.7, y: 1.7 },
      drill: 1.0,
      layers: '*.Cu *.Paste *.Mask'
    },
    {
      type: 'thru_hole',
      shape: 'circle',
      at: { x: 0, y: -1.27 },
      size: { x: 1.7, y: 1.7 },
      drill: 1.0,
      layers: '*.Cu *.Paste *.Mask'
    },
    {
      type: 'thru_hole',
      shape: 'circle',
      at: { x: 0, y: 1.27 },
      size: { x: 1.7, y: 1.7 },
      drill: 1.0,
      layers: '*.Cu *.Paste *.Mask'
    },
    {
      type: 'thru_hole',
      shape: 'circle',
      at: { x: 0, y: 3.81 },
      size: { x: 1.7, y: 1.7 },
      drill: 1.0,
      layers: '*.Cu *.Paste *.Mask'
    }
  ],
  model: {
    path: 'Connector_PinHeader_2.54mm.3dshapes/PinHeader_1x04_P2.54mm_Vertical.wrl',
    at: { xyz: { x: 0, y: -3.81, z: 0 } },
    scale: { xyz: { x: 1, y: 1, z: 1 } },
    rotate: { xyz: { x: 0, y: 0, z: 0 } }
  }
}

module.exports = (module) => `
(module
  H4-2.54mm
  (layer F.Cu)
  (tedit 59FED5CC)
  (at ${module.at.x} ${module.at.y} ${module.at.angle || 0})
  (descr "Through hole straight pin header, 1x04, 2.54mm pitch, single row")
  (tags "Through hole pin header THT 1x04 2.54mm single row")
  (fp_text reference ${module.name} (at -2.3495 -0.3175 360) (layer F.SilkS)
    (effects (font (size 1 1) (thickness 0.15)))
  )
  (fp_text value H4-2.54mm (at 0 9.95) (layer F.Fab)
    (effects (font (size 1 1) (thickness 0.15)))
  )


  (fp_text user %R (at 0 0 90) (layer F.Fab)
    (effects (font (size 1 1) (thickness 0.15)))
  )
  (model ${KISYS3DMOD}/Connector_PinHeader_2.54mm.3dshapes/PinHeader_1x04_P2.54mm_Vertical.wrl
    (at (xyz 0 -3.81 0))
    (scale (xyz 1 1 1))
    (rotate (xyz 0 0 0))
  )
)
`

  /*
    (module
      PinHeader_1x04_P2.54mm_Vertical
      (layer F.Cu)
      (tedit 59FED5CC)
      (at ${module.at.x} ${module.at.y} ${module.at.angle})
      (descr "Through hole straight pin header, 1x04, 2.54mm pitch, single row")
      (tags "Through hole pin header THT 1x04 2.54mm single row")
      (fp_text reference REF** (at 0 -2.33) (layer F.SilkS)
        (effects (font (size 1 1) (thickness 0.15)))
      )
      (fp_text value PinHeader_1x04_P2.54mm_Vertical (at 0 9.95) (layer F.Fab)
        (effects (font (size 1 1) (thickness 0.15)))
      )
      (fp_line (start -0.635 -1.27) (end 1.27 -1.27) (layer F.Fab) (width 0.1))
      (fp_line (start 1.27 -1.27) (end 1.27 8.89) (layer F.Fab) (width 0.1))
      (fp_line (start 1.27 8.89) (end -1.27 8.89) (layer F.Fab) (width 0.1))
      (fp_line (start -1.27 8.89) (end -1.27 -0.635) (layer F.Fab) (width 0.1))
      (fp_line (start -1.27 -0.635) (end -0.635 -1.27) (layer F.Fab) (width 0.1))
      (fp_line (start -1.33 8.95) (end 1.33 8.95) (layer F.SilkS) (width 0.12))
      (fp_line (start -1.33 1.27) (end -1.33 8.95) (layer F.SilkS) (width 0.12))
      (fp_line (start 1.33 1.27) (end 1.33 8.95) (layer F.SilkS) (width 0.12))
      (fp_line (start -1.33 1.27) (end 1.33 1.27) (layer F.SilkS) (width 0.12))
      (fp_line (start -1.33 0) (end -1.33 -1.33) (layer F.SilkS) (width 0.12))
      (fp_line (start -1.33 -1.33) (end 0 -1.33) (layer F.SilkS) (width 0.12))
      (fp_line (start -1.8 -1.8) (end -1.8 9.4) (layer F.CrtYd) (width 0.05))
      (fp_line (start -1.8 9.4) (end 1.8 9.4) (layer F.CrtYd) (width 0.05))
      (fp_line (start 1.8 9.4) (end 1.8 -1.8) (layer F.CrtYd) (width 0.05))
      (fp_line (start 1.8 -1.8) (end -1.8 -1.8) (layer F.CrtYd) (width 0.05))
      (pad 1 thru_hole rect (at 0 0) (size 1.7 1.7) (drill 1.0)
        (layers *.Cu *.Mask)
        (net ${module.pads[0].net_index} ${module.pads[0].net})
      )
      (pad 2 thru_hole oval (at 0 2.54) (size 1.7 1.7) (drill 1.0)
        (layers *.Cu *.Mask)
        (net ${module.pads[1].net_index} ${module.pads[1].net})
      )
      (pad 3 thru_hole oval (at 0 5.08) (size 1.7 1.7) (drill 1.0)
        (layers *.Cu *.Mask)
        (net ${module.pads[2].net_index} ${module.pads[2].net})
      )
      (pad 4 thru_hole oval (at 0 7.62) (size 1.7 1.7) (drill 1.0)
        (layers *.Cu *.Mask)
        (net ${module.pads[3].net_index} ${module.pads[3].net})
      )
      (fp_text user %R (at 0 3.81 90) (layer F.Fab)
        (effects (font (size 1 1) (thickness 0.15)))
      )
      (model ${KISYS3DMOD}/Connector_PinHeader_2.54mm.3dshapes/PinHeader_1x04_P2.54mm_Vertical.wrl
        (at (xyz 0 0 0))
        (scale (xyz 1 1 1))
        (rotate (xyz 0 0 0))
      )
    )
*/

/*
(module H4-2.54 (layer F.Cu) (tedit 200000)
  (attr virtual)
  (fp_text reference >NAME (at -2.3495 -0.3175 90) (layer F.SilkS)
    (effects (font (size 0.889 0.889) (thickness 0.1016)))
  )
  (fp_text value >VALUE (at 2.0955 -0.762 90) (layer F.SilkS)
    (effects (font (size 0.889 0.889) (thickness 0.1016)))
  )
  (fp_line (start -1.27 5.08) (end 1.27 5.08) (layer F.SilkS) (width 0.06604))
  (fp_line (start 1.27 5.08) (end 1.27 -5.08) (layer F.SilkS) (width 0.06604))
  (fp_line (start -1.27 -5.08) (end 1.27 -5.08) (layer F.SilkS) (width 0.06604))
  (fp_line (start -1.27 5.08) (end -1.27 -5.08) (layer F.SilkS) (width 0.06604))
  (fp_line (start -1.27 -5.08) (end 1.27 -5.08) (layer F.SilkS) (width 0.127))
  (fp_line (start 1.27 -5.08) (end 1.27 5.08) (layer F.SilkS) (width 0.127))
  (fp_line (start 1.27 5.08) (end -1.27 5.08) (layer F.SilkS) (width 0.127))
  (fp_line (start -1.27 5.08) (end -1.27 -5.08) (layer F.SilkS) (width 0.127))
  (fp_line (start -1.27 -5.08) (end 1.27 -5.08) (layer F.SilkS) (width 0))
  (fp_line (start 1.27 -5.08) (end 1.27 5.08) (layer F.SilkS) (width 0))
  (fp_line (start 1.27 5.08) (end -1.27 5.08) (layer F.SilkS) (width 0))
  (fp_line (start -1.27 5.08) (end -1.27 -5.08) (layer F.SilkS) (width 0))
  (pad 1 thru_hole rect (at 0 -3.81) (size 1.651 1.651) (drill 0.889) (layers *.Cu *.Paste *.Mask))
  (pad 2 thru_hole circle (at 0 -1.27) (size 1.651 1.651) (drill 0.889) (layers *.Cu *.Paste *.Mask))
  (pad 3 thru_hole circle (at 0 1.27) (size 1.651 1.651) (drill 0.889) (layers *.Cu *.Paste *.Mask))
  (pad 4 thru_hole circle (at 0 3.81) (size 1.651 1.651) (drill 0.889) (layers *.Cu *.Paste *.Mask))
)
*/
