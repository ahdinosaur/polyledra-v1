module.exports = {
  name: 'M4',
  layer: 'F.Cu',
  tedit: '56D1B4CB',
  at: {
    x: 0,
    y: 0
  },
  description: 'Mounting Hole 4.3mm, no annular, M4',
  tags: 'mounting hole 4.3mm no annular m4',
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
          y: -5.3
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
          y: 5.3
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
          x: 4.55,
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
      type: 'thru_hole',
      shape: 'circle',
      at: {
        x: 0,
        y: 0
      },
      size: {
        x: 8.6,
        y: 8.6
      },
      drill: 4.3,
      layers: [
        '*.Cu',
        '*.Mask'
      ]
    }
  ]
}
