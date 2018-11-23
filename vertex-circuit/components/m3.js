module.exports = {
  name: 'M3',
  layer: 'F.Cu',
  tedit: '56D1B4CB',
  at: {
    x: 0,
    y: 0
  },
  description: 'Mounting Hole 3.2mm, no annular, M3',
  tags: 'mounting hole 3.2mm no annular m3',
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
        content: reference.content || 'REF**',
        at: reference.at || {
          x: 0,
          y: -4.2
        },
        layer: reference.layer || 'F.SilkS',
        effects: {
          font: {
            size: {
              x: 1,
              y: 1
            },
            thickness: 0.15
          }
        }
      },
      {
        type: 'text',
        id: 'value',
        content: value.content || 'VALUE**',
        at: value.at || {
          x: 0,
          y: 4.2
        },
        layer: value.layer || 'F.Fab',
        effects: {
          font: {
            size: {
              x: 1,
              y: 1
            },
            thickness: 0.15
          }
        }
      },
      {
        type: 'circle',
        center: {
          x: 0,
          y: 0
        },
        end: {
          x: 3.2,
          y: 0
        },
        layer: 'Cmts.User',
        width: 0.15
      },
      {
        type: 'circle',
        center: {
          x: 0,
          y: 0
        },
        end: {
          x: 3.45,
          y: 0
        },
        layer: 'F.CrtYd',
        width: 0.05
      }
    ]
  },
  pads: [
    {
      number: 1,
      type: 'np_thru_hole',
      shape: 'circle',
      at: {
        x: 0,
        y: 0
      },
      size: {
        x: 3.2,
        y: 3.2
      },
      drill: 3.2,
      layers: [
        '*.Cu',
        '*.Mask'
      ]
    }
  ]
}
