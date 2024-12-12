#lang racket

(require (file "../engine.rkt"))

(define 命题逻辑 (dynamic-require "../database/prop.rkt" '数据))

(define 这个世界 (append 命题逻辑 (list (恣 (非 (非 X))))))

(define 多演结果
  (多演 这个世界
      2
      (foldr max 0 (map (lambda (事实) (长度 (cdr 事实))) 这个世界))
      (lambda (x)
        (displayln "")
        (for ([结果 x])
          (displayln (展示 结果)))
        x)))
