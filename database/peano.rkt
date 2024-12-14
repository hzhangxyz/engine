#lang s-exp "../grammar/v1.rkt"

(list "prop.rkt")

;; 0 is a natural number.
(恣 [] (自然数 零))

;; For every natural number x, x = x. That is, equality is reflexive.
(恣 [x] (自然数 x) -> (x = x))
;; For all natural numbers x and y, if x = y, then y = x. That is, equality is symmetric.
(恣 [x y] (自然数 x) -> ((自然数 y) -> ((x = y) -> (y = x))))
;; For all natural numbers x, y and z, if x = y and y = z, then x = z. That is, equality is transitive.
(恣 [x y z] (自然数 x) -> ((自然数 y) -> ((自然数 z) -> ((x = y) -> ((y = z) -> (x = z))))))
;; For all a and b, if b is a natural number and a = b, then a is also a natural number. That is, the natural numbers are closed under equality.
(恣 [a b] (自然数 b) -> ((a = b) -> (自然数 a)))

;; For every natural number n, S(n) is a natural number. That is, the natural numbers are closed under S.
(恣 [n] (自然数 n) -> (自然数 (后继 n)))
;; For all natural numbers m and n, if S(m) = S(n), then m = n. That is, S is an injection.
(恣 [m n] (自然数 m) -> ((自然数 n) -> (((后继 m) = (后继 n)) -> (m = n))))
;; For every natural number n, S(n) = 0 is false. That is, there is no natural number whose successor is 0.
(恣 [n] (自然数 n) -> (非 ((后继 n) = 零)))

;; If K is a set such that:
;; - 0 is in K, and
;; - for every natural number n, n being in K implies that S(n) is in K,
;; then K contains every natural number.
