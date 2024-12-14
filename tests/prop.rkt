#! /usr/bin/env racket
#lang racket

(require ansi-color)
(require (file "../engine.rkt"))

(define 命题逻辑 (引 "../database/prop.rkt"))
(define 这个世界 (append 命题逻辑 (list (恣 (非 (非 X))))))

(define 目标 (恣 X))

(call/cc (lambda (cc)
           (多演 这个世界
               (lambda (理论)
                 (define 世界最大长度 (foldr max 0 (map (lambda (事实) (长度 (cdr 事实))) 这个世界)))
                 (displayln "")
                 (filter (lambda (事实)
                           (if (< (长度 (cdr 事实)) 世界最大长度)
                               (begin0 #t
                                 (if (equal? 事实 目标)
                                     (begin
                                       (parameterize ([foreground-color 'red])
                                         (color-displayln (示 事实)))
                                       (cc))
                                     (parameterize ([foreground-color 'white])
                                       (color-displayln (示 事实)))))
                               (begin0 #f
                                 (parameterize ([foreground-color 'blue])
                                   (color-displayln (示 事实))))))
                         理论)))))
