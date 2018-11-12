module.exports = {
  name: 'H4-2.54mm',
  description: 'Through hole straight pin header, 1x04, 2.54mm pitch, single row',
  tags: 'Through hole pin header THT 1x04 2.54mm single row',
  graphics: (module) => {
    const {
      graphics = {}
    } = module

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
        end: { x: -0.635, y: -5.08 },
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
      layers: ['*.Cu', '*.Paste', '*.Mask']
    },
    {
      type: 'thru_hole',
      shape: 'circle',
      at: { x: 0, y: -1.27 },
      size: { x: 1.7, y: 1.7 },
      drill: 1.0,
      layers: ['*.Cu', '*.Paste', '*.Mask']
    },
    {
      type: 'thru_hole',
      shape: 'circle',
      at: { x: 0, y: 1.27 },
      size: { x: 1.7, y: 1.7 },
      drill: 1.0,
      layers: ['*.Cu', '*.Paste', '*.Mask']
    },
    {
      type: 'thru_hole',
      shape: 'circle',
      at: { x: 0, y: 3.81 },
      size: { x: 1.7, y: 1.7 },
      drill: 1.0,
      layers: ['*.Cu', '*.Paste', '*.Mask']
    }
  ],
  model: {
    path: 'Connector_PinHeader_2.54mm.3dshapes/PinHeader_1x04_P2.54mm_Vertical.wrl',
    at: { xyz: { x: 0, y: -3.81, z: 0 } },
    scale: { xyz: { x: 1, y: 1, z: 1 } },
    rotate: { xyz: { x: 0, y: 0, z: 0 } }
  }
}
