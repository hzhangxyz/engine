#lang s-exp "../grammar/v1.rkt"

(基)

(恣 p q (若 p (若 q p)))
(恣 p q r (若 (若 p (若 q r)) (若 (若 p q) (若 p r))))
(恣 p q (若 (若 (非 p) (非 q)) (若 q p)))
