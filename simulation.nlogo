breed [mouses mouse]
breed [cats cat]
breed [sunflowers sunflower]

cats-own [ energy ]
mouses-own [ energy ]
sunflowers-own [ countdown ]

;; Vytvori koloniu mysi a maciek
to setup
  clear-all

  ask patches [
    set pcolor brown
  ]

  create-cats init-cats [
    set shape "cat"
    set color black
    set size 1.5
    set energy random (2 * gain-from-mouse)
    setxy random-xcor random-ycor
  ]
  create-mouses init-mouses [
    set shape "mouse side"
    set color 8
    set size 1.5
    set energy random (2 * gain-from-sunflower)
    setxy random-xcor random-ycor
  ]
  create-sunflowers init-sunflowers [
    set shape "flower"
    set color 45
    set size 1.5
    set countdown random sunflower-regrowth-time
    setxy random-xcor random-ycor
  ]
  reset-ticks
end

;; Pohyb mysi a maciek
to go
  ; stop the model if there are no cats and no mouses
  if count mouses <= 1 or count cats <= 1 or not any? sunflowers [ stop ]
  if count mouses > max-mouses or count cats > max-cats or count sunflowers > max-sunflowers [ stop ]

  move-cats
  move-mouses
  grow-sunflowers
  tick
end

to move-cats
  ask cats [
    ifelse show-energy?
      [ set label energy ]
      [ set label "" ]

    ;; otocenie + pohyb
    move

    ;; uberie energiu
    set energy energy - 1

    ;; ak nema energiu zomiera
    death

    ;; skusi najst potravu
    eat-mouse

    ;; nahodna reprodukcia
    reproduce-cats
  ]
end

to move-mouses
  ask mouses [
    ifelse show-energy?
      [ set label energy ]
      [ set label "" ]

    ;; otocenie + pohyb
    move

    ;; uberie energiu
    set energy energy - 1

    ;; ak nema energiu zomiera
    death

    ;; skusi najst potravu
    eat-sunflower

    ;; nahodna reprodukcia
    reproduce-mouses
  ]
end

to move
  rt random-float 180
  lt random-float 180
  fd 1
end

to death
  ; Ak pride o vsetku energiu
  if energy < 0 [ die ]
end

;; Zivotny cyklus mysi
to reproduce-mouses
  if random-float 100 < (mouse-reproduce * neg_sigmoid(count mouses / max-mouses)) [
    let prey one-of other mouses-here   ; ak je v tomto patch uz ina mys
    if prey != nobody  [
      set energy (energy / 2)
      hatch 1 [
        rt random-float 360
        fd 1
        set energy random (2 * gain-from-sunflower)
      ]
    ]
  ]
end

to eat-sunflower
  let prey one-of sunflowers-here
  if prey != nobody  [
    ask prey [ die ]
    set energy energy + gain-from-sunflower
  ]
end

;; Zivotny cyklus macky
to reproduce-cats
  if random-float 100 < (cat-reproduce * neg_sigmoid(count cats / max-cats)) [
    let prey one-of other cats-here   ; ak je v tomto patch uz ina macka
    if prey != nobody  [
      set energy (energy / 2)
      hatch 1 [
        rt random-float 360
        fd 1
        set energy random (2 * gain-from-mouse)
      ]
    ]
  ]
end

to eat-mouse
  let prey one-of mouses-here
  if prey != nobody  [
    ask prey [ die ]
    set energy energy + gain-from-mouse
  ]
end

to grow-sunflowers
  ask sunflowers [
    ifelse countdown <= 0
      [
        hatch 2 [
          setxy random-xcor random-ycor
          set countdown sunflower-regrowth-time
        ]
        die
      ]
      [ set countdown countdown - (1 * neg_sigmoid(count sunflowers / max-sunflowers)) ]
  ]
end

to-report neg_sigmoid [x]
  report 1.0 - (1.0 / (1.0 + exp(-1.0 * x)))
end
@#$#@#$#@
GRAPHICS-WINDOW
420
24
1134
739
-1
-1
13.84314
1
10
1
1
1
0
1
1
1
-25
25
-25
25
1
1
1
ticks
20.0

BUTTON
30
60
96
93
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
117
61
180
94
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
14
114
186
147
cat-reproduce
cat-reproduce
0
100
8.0
1
1
%
HORIZONTAL

SLIDER
16
162
188
195
gain-from-mouse
gain-from-mouse
0
250
100.0
1
1
NIL
HORIZONTAL

SLIDER
1147
102
1325
135
mouse-reproduce
mouse-reproduce
0
100
48.0
1
1
%
HORIZONTAL

MONITOR
58
214
136
259
NIL
count cats
17
1
11

MONITOR
1191
193
1305
238
NIL
count mouses
17
1
11

PLOT
9
359
401
528
Count
Time
Count
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"cats" 1.0 0 -13840069 true "" "plot count cats"
"mouses" 1.0 0 -2674135 true "" "plot count mouses"
"sunflowers" 1.0 0 -1184463 true "" "plot count sunflowers"

SWITCH
20
275
164
308
show-energy?
show-energy?
1
1
-1000

SLIDER
1147
143
1326
176
gain-from-sunflower
gain-from-sunflower
0
250
250.0
1
1
NIL
HORIZONTAL

MONITOR
1193
260
1305
305
NIL
count sunflowers
17
1
11

SLIDER
1336
55
1508
88
init-mouses
init-mouses
0
250
50.0
1
1
NIL
HORIZONTAL

SLIDER
205
116
377
149
init-cats
init-cats
0
250
50.0
1
1
NIL
HORIZONTAL

SLIDER
1159
428
1331
461
init-sunflowers
init-sunflowers
0
250
100.0
1
1
NIL
HORIZONTAL

SLIDER
1148
56
1320
89
max-mouses
max-mouses
0
100000
30000.0
1
1
NIL
HORIZONTAL

SLIDER
1342
428
1573
461
sunflower-regrowth-time
sunflower-regrowth-time
0
250
50.0
1
1
NIL
HORIZONTAL

SLIDER
1158
472
1330
505
max-sunflowers
max-sunflowers
0
100000
30000.0
1
1
NIL
HORIZONTAL

SLIDER
215
169
387
202
max-cats
max-cats
0
100000
30000.0
1
1
NIL
HORIZONTAL

PLOT
9
537
401
739
Energy
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Cat's energy" 1.0 0 -11085214 true "" "plot mean [ energy ] of cats"
"Mouse's energy" 1.0 0 -2674135 true "" "plot mean [ energy ] of mouses"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

cat
false
0
Line -7500403 true 285 240 210 240
Line -7500403 true 195 300 165 255
Line -7500403 true 15 240 90 240
Line -7500403 true 285 285 195 240
Line -7500403 true 105 300 135 255
Line -16777216 false 150 270 150 285
Line -16777216 false 15 75 15 120
Polygon -7500403 true true 300 15 285 30 255 30 225 75 195 60 255 15
Polygon -7500403 true true 285 135 210 135 180 150 180 45 285 90
Polygon -7500403 true true 120 45 120 210 180 210 180 45
Polygon -7500403 true true 180 195 165 300 240 285 255 225 285 195
Polygon -7500403 true true 180 225 195 285 165 300 150 300 150 255 165 225
Polygon -7500403 true true 195 195 195 165 225 150 255 135 285 135 285 195
Polygon -7500403 true true 15 135 90 135 120 150 120 45 15 90
Polygon -7500403 true true 120 195 135 300 60 285 45 225 15 195
Polygon -7500403 true true 120 225 105 285 135 300 150 300 150 255 135 225
Polygon -7500403 true true 105 195 105 165 75 150 45 135 15 135 15 195
Polygon -7500403 true true 285 120 270 90 285 15 300 15
Line -7500403 true 15 285 105 240
Polygon -7500403 true true 15 120 30 90 15 15 0 15
Polygon -7500403 true true 0 15 15 30 45 30 75 75 105 60 45 15
Line -16777216 false 164 262 209 262
Line -16777216 false 223 231 208 261
Line -16777216 false 136 262 91 262
Line -16777216 false 77 231 92 261

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

mouse side
false
0
Polygon -7500403 true true 38 162 24 165 19 174 22 192 47 213 90 225 135 230 161 240 178 262 150 246 117 238 73 232 36 220 11 196 7 171 15 153 37 146 46 145
Polygon -7500403 true true 289 142 271 165 237 164 217 185 235 192 254 192 259 199 245 200 248 203 226 199 200 194 155 195 122 185 84 187 91 195 82 192 83 201 72 190 67 199 62 185 46 183 36 165 40 134 57 115 74 106 60 109 90 97 112 94 92 93 130 86 154 88 134 81 183 90 197 94 183 86 212 95 211 88 224 83 235 88 248 97 246 90 257 107 255 97 270 120
Polygon -16777216 true false 234 100 220 96 210 100 214 111 228 116 239 115
Circle -16777216 true false 246 117 20
Line -7500403 true 270 153 282 174
Line -7500403 true 272 153 255 173
Line -7500403 true 269 156 268 177

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="measure-stats" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5000"/>
    <metric>count mouses</metric>
    <metric>count cats</metric>
    <metric>count sunflowers</metric>
    <enumeratedValueSet variable="mouse-reproduce">
      <value value="48"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init-sunflowers">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="gain-from-mouse">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cat-reproduce">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init-cats">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="gain-from-sunflower">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sunflower-regrowth-time">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init-mouses">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-cats">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-mouses">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-sunflowers">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-energy?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="find-optimum" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5000"/>
    <steppedValueSet variable="mouse-reproduce" first="16" step="16" last="64"/>
    <steppedValueSet variable="init-sunflowers" first="0" step="50" last="200"/>
    <steppedValueSet variable="gain-from-mouse" first="0" step="50" last="250"/>
    <steppedValueSet variable="cat-reproduce" first="8" step="8" last="64"/>
    <steppedValueSet variable="init-cats" first="0" step="50" last="150"/>
    <steppedValueSet variable="gain-from-sunflower" first="0" step="50" last="250"/>
    <steppedValueSet variable="sunflower-regrowth-time" first="10" step="20" last="100"/>
    <steppedValueSet variable="init-mouses" first="0" step="50" last="200"/>
    <enumeratedValueSet variable="max-cats">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-mouses">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-sunflowers">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-energy?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
