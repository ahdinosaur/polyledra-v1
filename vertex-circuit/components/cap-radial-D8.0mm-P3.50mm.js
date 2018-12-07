module.exports = {
  name: 'CP_Radial_D8.0mm_P3.50mm',
  layer: 'F.Cu',
  tedit: '597BC7C2',
  description: 'CP, Radial series, Radial, pin pitch=3.50mm, , diameter=8mm, Electrolytic Capacitor',
  tags: 'CP Radial series Radial pin pitch 3.50mm  diameter 8mm Electrolytic Capacitor',
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
        content: 'REF**',
        at: {
          x: 1.75,
          y: -5.31
        },
        layer: 'F.SilkS',
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
        content: 'CP_Radial_D8.0mm_P3.50mm',
        at: {
          x: 1.75,
          y: 5.31
        },
        layer: 'F.Fab',
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
        id: 'user',
        content: '%R',
        at: {
          x: 1.75,
          y: 0
        },
        layer: 'F.Fab',
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
          x: 1.75,
          y: 0
        },
        end: {
          x: 5.75,
          y: 0
        },
        layer: 'F.Fab',
        width: 0.1
      },
      {
        type: 'circle',
        center: {
          x: 1.75,
          y: 0
        },
        end: {
          x: 5.84,
          y: 0
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: -2.2,
          y: 0
        },
        end: {
          x: -1,
          y: 0
        },
        layer: 'F.Fab',
        width: 0.1
      },
      {
        type: 'line',
        start: {
          x: -1.6,
          y: -0.65
        },
        end: {
          x: -1.6,
          y: 0.65
        },
        layer: 'F.Fab',
        width: 0.1
      },
      {
        type: 'line',
        start: {
          x: 1.75,
          y: -4.05
        },
        end: {
          x: 1.75,
          y: 4.05
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 1.79,
          y: -4.05
        },
        end: {
          x: 1.79,
          y: 4.05
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 1.83,
          y: -4.05
        },
        end: {
          x: 1.83,
          y: 4.05
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 1.87,
          y: -4.049
        },
        end: {
          x: 1.87,
          y: 4.049
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 1.91,
          y: -4.047
        },
        end: {
          x: 1.91,
          y: 4.047
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 1.95,
          y: -4.046
        },
        end: {
          x: 1.95,
          y: 4.046
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 1.99,
          y: -4.043
        },
        end: {
          x: 1.99,
          y: 4.043
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.03,
          y: -4.041
        },
        end: {
          x: 2.03,
          y: 4.041
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.07,
          y: -4.038
        },
        end: {
          x: 2.07,
          y: 4.038
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.11,
          y: -4.035
        },
        end: {
          x: 2.11,
          y: 4.035
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.15,
          y: -4.031
        },
        end: {
          x: 2.15,
          y: 4.031
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.19,
          y: -4.027
        },
        end: {
          x: 2.19,
          y: 4.027
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.23,
          y: -4.022
        },
        end: {
          x: 2.23,
          y: 4.022
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.27,
          y: -4.017
        },
        end: {
          x: 2.27,
          y: 4.017
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.31,
          y: -4.012
        },
        end: {
          x: 2.31,
          y: 4.012
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.35,
          y: -4.006
        },
        end: {
          x: 2.35,
          y: 4.006
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.39,
          y: -4
        },
        end: {
          x: 2.39,
          y: 4
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.43,
          y: -3.994
        },
        end: {
          x: 2.43,
          y: 3.994
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.471,
          y: -3.987
        },
        end: {
          x: 2.471,
          y: 3.987
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.511,
          y: -3.979
        },
        end: {
          x: 2.511,
          y: 3.979
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.551,
          y: -3.971
        },
        end: {
          x: 2.551,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.551,
          y: 0.98
        },
        end: {
          x: 2.551,
          y: 3.971
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.591,
          y: -3.963
        },
        end: {
          x: 2.591,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.591,
          y: 0.98
        },
        end: {
          x: 2.591,
          y: 3.963
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.631,
          y: -3.955
        },
        end: {
          x: 2.631,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.631,
          y: 0.98
        },
        end: {
          x: 2.631,
          y: 3.955
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.671,
          y: -3.946
        },
        end: {
          x: 2.671,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.671,
          y: 0.98
        },
        end: {
          x: 2.671,
          y: 3.946
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.711,
          y: -3.936
        },
        end: {
          x: 2.711,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.711,
          y: 0.98
        },
        end: {
          x: 2.711,
          y: 3.936
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.751,
          y: -3.926
        },
        end: {
          x: 2.751,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.751,
          y: 0.98
        },
        end: {
          x: 2.751,
          y: 3.926
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.791,
          y: -3.916
        },
        end: {
          x: 2.791,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.791,
          y: 0.98
        },
        end: {
          x: 2.791,
          y: 3.916
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.831,
          y: -3.905
        },
        end: {
          x: 2.831,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.831,
          y: 0.98
        },
        end: {
          x: 2.831,
          y: 3.905
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.871,
          y: -3.894
        },
        end: {
          x: 2.871,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.871,
          y: 0.98
        },
        end: {
          x: 2.871,
          y: 3.894
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.911,
          y: -3.883
        },
        end: {
          x: 2.911,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.911,
          y: 0.98
        },
        end: {
          x: 2.911,
          y: 3.883
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.951,
          y: -3.87
        },
        end: {
          x: 2.951,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.951,
          y: 0.98
        },
        end: {
          x: 2.951,
          y: 3.87
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.991,
          y: -3.858
        },
        end: {
          x: 2.991,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 2.991,
          y: 0.98
        },
        end: {
          x: 2.991,
          y: 3.858
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.031,
          y: -3.845
        },
        end: {
          x: 3.031,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.031,
          y: 0.98
        },
        end: {
          x: 3.031,
          y: 3.845
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.071,
          y: -3.832
        },
        end: {
          x: 3.071,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.071,
          y: 0.98
        },
        end: {
          x: 3.071,
          y: 3.832
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.111,
          y: -3.818
        },
        end: {
          x: 3.111,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.111,
          y: 0.98
        },
        end: {
          x: 3.111,
          y: 3.818
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.151,
          y: -3.803
        },
        end: {
          x: 3.151,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.151,
          y: 0.98
        },
        end: {
          x: 3.151,
          y: 3.803
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.191,
          y: -3.789
        },
        end: {
          x: 3.191,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.191,
          y: 0.98
        },
        end: {
          x: 3.191,
          y: 3.789
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.231,
          y: -3.773
        },
        end: {
          x: 3.231,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.231,
          y: 0.98
        },
        end: {
          x: 3.231,
          y: 3.773
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.271,
          y: -3.758
        },
        end: {
          x: 3.271,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.271,
          y: 0.98
        },
        end: {
          x: 3.271,
          y: 3.758
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.311,
          y: -3.741
        },
        end: {
          x: 3.311,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.311,
          y: 0.98
        },
        end: {
          x: 3.311,
          y: 3.741
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.351,
          y: -3.725
        },
        end: {
          x: 3.351,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.351,
          y: 0.98
        },
        end: {
          x: 3.351,
          y: 3.725
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.391,
          y: -3.707
        },
        end: {
          x: 3.391,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.391,
          y: 0.98
        },
        end: {
          x: 3.391,
          y: 3.707
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.431,
          y: -3.69
        },
        end: {
          x: 3.431,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.431,
          y: 0.98
        },
        end: {
          x: 3.431,
          y: 3.69
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.471,
          y: -3.671
        },
        end: {
          x: 3.471,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.471,
          y: 0.98
        },
        end: {
          x: 3.471,
          y: 3.671
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.511,
          y: -3.652
        },
        end: {
          x: 3.511,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.511,
          y: 0.98
        },
        end: {
          x: 3.511,
          y: 3.652
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.551,
          y: -3.633
        },
        end: {
          x: 3.551,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.551,
          y: 0.98
        },
        end: {
          x: 3.551,
          y: 3.633
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.591,
          y: -3.613
        },
        end: {
          x: 3.591,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.591,
          y: 0.98
        },
        end: {
          x: 3.591,
          y: 3.613
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.631,
          y: -3.593
        },
        end: {
          x: 3.631,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.631,
          y: 0.98
        },
        end: {
          x: 3.631,
          y: 3.593
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.671,
          y: -3.572
        },
        end: {
          x: 3.671,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.671,
          y: 0.98
        },
        end: {
          x: 3.671,
          y: 3.572
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.711,
          y: -3.55
        },
        end: {
          x: 3.711,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.711,
          y: 0.98
        },
        end: {
          x: 3.711,
          y: 3.55
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.751,
          y: -3.528
        },
        end: {
          x: 3.751,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.751,
          y: 0.98
        },
        end: {
          x: 3.751,
          y: 3.528
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.791,
          y: -3.505
        },
        end: {
          x: 3.791,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.791,
          y: 0.98
        },
        end: {
          x: 3.791,
          y: 3.505
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.831,
          y: -3.482
        },
        end: {
          x: 3.831,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.831,
          y: 0.98
        },
        end: {
          x: 3.831,
          y: 3.482
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.871,
          y: -3.458
        },
        end: {
          x: 3.871,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.871,
          y: 0.98
        },
        end: {
          x: 3.871,
          y: 3.458
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.911,
          y: -3.434
        },
        end: {
          x: 3.911,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.911,
          y: 0.98
        },
        end: {
          x: 3.911,
          y: 3.434
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.951,
          y: -3.408
        },
        end: {
          x: 3.951,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.951,
          y: 0.98
        },
        end: {
          x: 3.951,
          y: 3.408
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.991,
          y: -3.383
        },
        end: {
          x: 3.991,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 3.991,
          y: 0.98
        },
        end: {
          x: 3.991,
          y: 3.383
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.031,
          y: -3.356
        },
        end: {
          x: 4.031,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.031,
          y: 0.98
        },
        end: {
          x: 4.031,
          y: 3.356
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.071,
          y: -3.329
        },
        end: {
          x: 4.071,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.071,
          y: 0.98
        },
        end: {
          x: 4.071,
          y: 3.329
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.111,
          y: -3.301
        },
        end: {
          x: 4.111,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.111,
          y: 0.98
        },
        end: {
          x: 4.111,
          y: 3.301
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.151,
          y: -3.272
        },
        end: {
          x: 4.151,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.151,
          y: 0.98
        },
        end: {
          x: 4.151,
          y: 3.272
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.191,
          y: -3.243
        },
        end: {
          x: 4.191,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.191,
          y: 0.98
        },
        end: {
          x: 4.191,
          y: 3.243
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.231,
          y: -3.213
        },
        end: {
          x: 4.231,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.231,
          y: 0.98
        },
        end: {
          x: 4.231,
          y: 3.213
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.271,
          y: -3.182
        },
        end: {
          x: 4.271,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.271,
          y: 0.98
        },
        end: {
          x: 4.271,
          y: 3.182
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.311,
          y: -3.15
        },
        end: {
          x: 4.311,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.311,
          y: 0.98
        },
        end: {
          x: 4.311,
          y: 3.15
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.351,
          y: -3.118
        },
        end: {
          x: 4.351,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.351,
          y: 0.98
        },
        end: {
          x: 4.351,
          y: 3.118
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.391,
          y: -3.084
        },
        end: {
          x: 4.391,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.391,
          y: 0.98
        },
        end: {
          x: 4.391,
          y: 3.084
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.431,
          y: -3.05
        },
        end: {
          x: 4.431,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.431,
          y: 0.98
        },
        end: {
          x: 4.431,
          y: 3.05
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.471,
          y: -3.015
        },
        end: {
          x: 4.471,
          y: -0.98
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.471,
          y: 0.98
        },
        end: {
          x: 4.471,
          y: 3.015
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.511,
          y: -2.979
        },
        end: {
          x: 4.511,
          y: 2.979
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.551,
          y: -2.942
        },
        end: {
          x: 4.551,
          y: 2.942
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.591,
          y: -2.904
        },
        end: {
          x: 4.591,
          y: 2.904
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.631,
          y: -2.865
        },
        end: {
          x: 4.631,
          y: 2.865
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.671,
          y: -2.824
        },
        end: {
          x: 4.671,
          y: 2.824
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.711,
          y: -2.783
        },
        end: {
          x: 4.711,
          y: 2.783
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.751,
          y: -2.74
        },
        end: {
          x: 4.751,
          y: 2.74
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.791,
          y: -2.697
        },
        end: {
          x: 4.791,
          y: 2.697
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.831,
          y: -2.652
        },
        end: {
          x: 4.831,
          y: 2.652
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.871,
          y: -2.605
        },
        end: {
          x: 4.871,
          y: 2.605
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.911,
          y: -2.557
        },
        end: {
          x: 4.911,
          y: 2.557
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.951,
          y: -2.508
        },
        end: {
          x: 4.951,
          y: 2.508
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 4.991,
          y: -2.457
        },
        end: {
          x: 4.991,
          y: 2.457
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.031,
          y: -2.404
        },
        end: {
          x: 5.031,
          y: 2.404
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.071,
          y: -2.349
        },
        end: {
          x: 5.071,
          y: 2.349
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.111,
          y: -2.293
        },
        end: {
          x: 5.111,
          y: 2.293
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.151,
          y: -2.234
        },
        end: {
          x: 5.151,
          y: 2.234
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.191,
          y: -2.173
        },
        end: {
          x: 5.191,
          y: 2.173
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.231,
          y: -2.109
        },
        end: {
          x: 5.231,
          y: 2.109
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.271,
          y: -2.043
        },
        end: {
          x: 5.271,
          y: 2.043
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.311,
          y: -1.974
        },
        end: {
          x: 5.311,
          y: 1.974
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.351,
          y: -1.902
        },
        end: {
          x: 5.351,
          y: 1.902
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.391,
          y: -1.826
        },
        end: {
          x: 5.391,
          y: 1.826
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.431,
          y: -1.745
        },
        end: {
          x: 5.431,
          y: 1.745
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.471,
          y: -1.66
        },
        end: {
          x: 5.471,
          y: 1.66
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.511,
          y: -1.57
        },
        end: {
          x: 5.511,
          y: 1.57
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.551,
          y: -1.473
        },
        end: {
          x: 5.551,
          y: 1.473
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.591,
          y: -1.369
        },
        end: {
          x: 5.591,
          y: 1.369
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.631,
          y: -1.254
        },
        end: {
          x: 5.631,
          y: 1.254
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.671,
          y: -1.127
        },
        end: {
          x: 5.671,
          y: 1.127
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.711,
          y: -0.983
        },
        end: {
          x: 5.711,
          y: 0.983
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.751,
          y: -0.814
        },
        end: {
          x: 5.751,
          y: 0.814
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.791,
          y: -0.598
        },
        end: {
          x: 5.791,
          y: 0.598
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: 5.831,
          y: -0.246
        },
        end: {
          x: 5.831,
          y: 0.246
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: -2.2,
          y: 0
        },
        end: {
          x: -1,
          y: 0
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: -1.6,
          y: -0.65
        },
        end: {
          x: -1.6,
          y: 0.65
        },
        layer: 'F.SilkS',
        width: 0.12
      },
      {
        type: 'line',
        start: {
          x: -2.6,
          y: -4.35
        },
        end: {
          x: -2.6,
          y: 4.35
        },
        layer: 'F.CrtYd',
        width: 0.05
      },
      {
        type: 'line',
        start: {
          x: -2.6,
          y: 4.35
        },
        end: {
          x: 6.1,
          y: 4.35
        },
        layer: 'F.CrtYd',
        width: 0.05
      },
      {
        type: 'line',
        start: {
          x: 6.1,
          y: 4.35
        },
        end: {
          x: 6.1,
          y: -4.35
        },
        layer: 'F.CrtYd',
        width: 0.05
      },
      {
        type: 'line',
        start: {
          x: 6.1,
          y: -4.35
        },
        end: {
          x: -2.6,
          y: -4.35
        },
        layer: 'F.CrtYd',
        width: 0.05
      }
    ]
  },
  pads: [
    {
      type: 'thru_hole',
      shape: 'rect',
      at: {
        x: 0,
        y: 0
      },
      size: {
        x: 1.6,
        y: 1.6
      },
      drill: 0.8,
      layers: [
        '*.Cu',
        '*.Mask'
      ]
    },
    {
      type: 'thru_hole',
      shape: 'circle',
      at: {
        x: 3.5,
        y: 0
      },
      size: {
        x: 1.6,
        y: 1.6
      },
      drill: 0.8,
      layers: [
        '*.Cu',
        '*.Mask'
      ]
    }
  ],
  model: {
    path: '${KISYS3DMOD}/Capacitors_THT.3dshapes/CP_Radial_D8.0mm_P3.50mm.wrl',
    at: {
      xyz: {
        x: 0,
        y: 0,
        z: 0
      }
    },
    scale: {
      xyz: {
        x: 1,
        y: 1,
        z: 1
      }
    },
    rotate: {
      xyz: {
        x: 0,
        y: 0,
        z: 0
      }
    }
  }
}
