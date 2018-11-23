module.exports = range

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

