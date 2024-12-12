#lang s-exp "../grammar/v1.rkt"

(list)

;; Modus Ponens
(恣 [p q] ((p -> q) && p) -> q)
;; Modus Tollens
(恣 [p q] ((p -> q) && ! q) -> ! p)
;; Hypothetical Syllogism
(恣 [p q r] ((p -> q) && (q -> r)) -> (p -> r))
;; Disjunctive Syllogism
(恣 [p q] ((p || q) && ! p) -> q)
;; Constructive Dilemma
(恣 [p q r s] ((p -> q) && ((r -> s) && (p || r))) -> (q || s))
;; Destructive Dilemma
(恣 [p q r] ((p -> q) && ((r -> s) && (! q || ! s))) -> (! p || ! r))
;; Bidirectional Dilemma
(恣 [p q r s] ((p -> q) && ((r -> s) && (p || ! s))) -> (q || ! r))
;; Simplification
(恣 [p q] (p && q) -> p)
;; Conjunction
(恣 [p q] p -> (q -> (p && q)))
;; Addition
(恣 [p q] p -> (p || q))
;; Composition
(恣 [p q r] ((p -> q) && (p -> r)) -> (p -> (q && r)))
;; De Morgan's Theorem
(恣 [p q] (! (p && q)) -> (! p || ! q))
(恣 [p q] (! p || ! q) -> (! (p && q)))
;; De Morgan's Theorem
(恣 [p q] (! (p || q)) -> (! p && ! q))
(恣 [p q] (! p && ! q) -> (! (p || q)))
;; Commutation
(恣 [p q] (p || q) -> (q || p))
(恣 [p q] (q || p) -> (p || q))
;; Commutation
(恣 [p q] (p && q) -> (q && p))
(恣 [p q] (q && p) -> (p && q))
;; Commutation
(恣 [p q] (p <-> q) -> (q <-> p))
(恣 [p q] (q <-> p) -> (p <-> q))
;; Association
(恣 [p q r] (p || (q || r)) -> ((p || q) || r))
(恣 [p q r] ((p || q) || r) -> (p || (q || r)))
;; Association
(恣 [p q r] (p && (q && r)) -> ((p && q) && r))
(恣 [p q r] ((p && q) && r) -> (p && (q && r)))
;; Distribution
(恣 [p q r] (p && (q || r)) -> ((p && q) || (p && r)))
(恣 [p q r] ((p && q) || (p && r)) -> (p && (q || r)))
;; Distribution
(恣 [p q r] (p || (q && r)) -> ((p || q) && (p || r)))
(恣 [p q r] ((p || q) && (p || r)) -> (p || (q && r)))
;; Double Negation
(恣 [p] p -> (非 (非 p)))
(恣 [p] (非 (非 p)) -> p)
;; Transposition
(恣 [p q] (p -> q) -> (! q -> ! p))
(恣 [p q] (! q -> ! p) -> (p -> q))
;; Material Implication
(恣 [p q] (p -> q) -> (! p || q))
(恣 [p q] (! p || q) -> (p -> q))
;; Material Equivalence
(恣 [p q] (p <-> q) -> ((p -> q) && (q -> p)))
(恣 [p q] ((p -> q) && (q -> p)) -> (p <-> q))
;; Material Equivalence
(恣 [p q] (p <-> q) -> ((p && q) || (! p && ! q)))
(恣 [p q] ((p && q) || (! p && ! q)) -> (p <-> q))
;; Material Equivalence
(恣 [p q] (p <-> q) -> ((p || ! q) && (! p || q)))
(恣 [p q] ((p || ! q) && (! p || q)) -> (p <-> q))
;; Exportation
(恣 [p q r] ((p && q) -> r) -> (p -> (q -> r)))
;; Importation
(恣 [p q r] (p -> (q -> r)) -> ((p && q) -> r))
;; Idempotence of disjunction
(恣 [p] p -> (p || p))
(恣 [p] (p || p) -> p)
;; Idempotence of conjunction
(恣 [p] p -> (p && p))
(恣 [p] (p && p) -> p)
;; Tertium non datur (Law of Excluded Middle)
(恣 [p] p || ! p)
;; Law of Non-Contradiction
(恣 [p] ! (p && ! p))
;; Explosion
(恣 [p q] (p && ! p) -> q)
