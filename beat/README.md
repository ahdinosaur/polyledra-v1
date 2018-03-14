start jack server on microphone

```
jackd -r -dalsa -d hw:0,0
```

listen to jack using arecord

add [.asoundrc](https://superuser.com/questions/245312/virtual-microphone-file-microphone-application)

```
arecord --device=jack
```

annotate incoming aubio using [`aubionotes`](https://github.com/aubio/aubio/blob/master/doc/aubionotes.txt)

```
aubionotes -j
```

aubio-tools
