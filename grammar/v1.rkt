#lang racket

(require (file "../engine.rkt"))

(provide (except-out (all-from-out racket) #%module-begin)
         (rename-out [module-begin #%module-begin])
         恣)

(define-syntax-rule (module-begin 导入 表达式 ...)
  (#%module-begin (define-values (目录名 文件名 _)
                    (split-path (variable-reference->module-source (#%variable-reference))))
                  (define 导入数据 (map (lambda (文件) (dynamic-require (build-path 目录名 文件) '数据)) 导入))
                  (define 局部数据 (list 表达式 ...))
                  (define 数据 (remove-duplicates (append (append* 导入数据) 局部数据)))
                  (provide 数据)))
