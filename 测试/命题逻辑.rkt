#lang racket

(require (file "../引擎.rkt"))

;; 测试区域

(define 命题逻辑
  (list (恣 p q (若 p (若 q p)))
        (恣 p q r (若 (若 p (若 q r)) (若 (若 p q) (若 p r))))
        (恣 p q (若 (若 (非 p) (非 q)) (若 q p)))))

(define 这个世界 (list (恣 (非 (非 X)))))

(define 多演结果
  (多演 (append 命题逻辑 这个世界)
      8
      13
      (lambda (x)
        (displayln "")
        (for ([结果 x])
          (displayln (展示 结果)))
        x)))
