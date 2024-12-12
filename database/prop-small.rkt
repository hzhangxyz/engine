#lang s-exp "../grammar/v1.rkt"

(list)

(恣 [p q] p -> (q -> p))
(恣 [p q r] (p -> (q -> r)) -> ((p -> q) -> (p -> r)))
(恣 [p q] (! p -> ! q) -> (q -> p))
