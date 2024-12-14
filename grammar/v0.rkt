#lang racket

(require (only-in (file "../engine.rkt") 恣 引))

(provide (except-out (all-from-out racket) #%module-begin)
         (rename-out [module-begin #%module-begin])
         恣)

(define-syntax-rule (module-begin 导入 表达式 ...)
  (#%module-begin (define 导入数据 (map (lambda (文件) (引 文件)) 导入))
                  (define 局部数据 (list 表达式 ...))
                  (define 数据 (remove-duplicates (append (append* 导入数据) 局部数据)))
                  (provide 数据)))
