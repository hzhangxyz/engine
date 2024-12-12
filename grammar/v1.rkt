#lang racket

(require (file "../engine.rkt"))

(provide (except-out (all-from-out racket) #%module-begin)
         (rename-out [module-begin #%module-begin])
         恣
         基)

(define (基 . 文件)
  (map (lambda (文件) (dynamic-require 文件 '数据)) 文件))

(define-syntax-rule (module-begin 导入 表达式 ...)
  (#%module-begin (define 导入数据 导入)
                  (define 局部数据 (list 表达式 ...))
                  (define 数据 (remove-duplicates (append (append* 导入数据) 局部数据)))
                  (displayln "")
                  (for ([事实 数据])
                    (displayln (展示 事实)))
                  (provide 数据)))
