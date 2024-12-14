#lang racket

(define (合并非 列表)
  (define (帮手 列表)
    (cond
      [(not (list? 列表)) 列表]
      [(null? 列表) 列表]
      [(equal? (car 列表) '!)
       (if (null? (cdr 列表))
           (list (list '!))
           (cons (list '非 (帮手 (cadr 列表))) (帮手 (cddr 列表))))]
      [else (cons (帮手 (car 列表)) (帮手 (cdr 列表)))]))
  (帮手 列表))

(define 中缀映射表 #hash([-> . 若] [<-> . 同] [&& . 且] [|| . 或] [= . 等]))

(define (中缀至前缀 表达式)
  (match 表达式
    [(list 左 算符 右)
     (if (hash-has-key? 中缀映射表 算符)
         (list (hash-ref 中缀映射表 算符) (中缀至前缀 左) (中缀至前缀 右))
         (list (中缀至前缀 左) (中缀至前缀) (中缀至前缀 右)))]
    [else
     (if (symbol? 表达式)
         表达式
         (map 中缀至前缀 表达式))]))

(define (中缀至前缀接口 表达式)
  (if (= (length 表达式) 1)
      (list-ref 表达式 0)
      (中缀至前缀 (合并非 表达式))))

(define-syntax-rule (恣 变量 身体 ...)
  (cons (list->set '变量) (中缀至前缀接口 (list '身体 ...))))

(require (only-in (file "../engine.rkt") 引))

(provide (except-out (all-from-out racket) #%module-begin)
         (rename-out [module-begin #%module-begin])
         恣)

(define-syntax-rule (module-begin 导入 表达式 ...)
  (#%module-begin (define 导入数据 (map (lambda (文件) (引 文件)) 导入))
                  (define 局部数据 (list 表达式 ...))
                  (define 数据 (remove-duplicates (append (append* 导入数据) 局部数据)))
                  (provide 数据)))
