#lang racket

(require (file "../engine.rkt"))

(require (rename-in (file "../database/prop.rkt") [数据 命题逻辑]))

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
