#lang racket

;; 规则有两条，即演绎和推理，归纳法需要引入置信概率，暂不考虑。
;; 规则中内置一个特殊函数`若'，用于推理。

(define-syntax-rule (恣 变量 ... 身体)
  (cons (set '变量 ...) '身体))

(define (展示 事实)
  (format "~a ~a" (string-join (cons "恣" (set-map (car 事实) symbol->string)) " ") (cdr 事实)))

(define (演绎 新变量 替换表 事实)
  (define (替换变量 变量)
    (let ([原自由 (set-member? (car 事实) 变量)]
          [想替换 (hash-has-key? 替换表 变量)]
          [新自由 (set-member? 新变量 变量)]
          [结果 (hash-ref 替换表 变量 变量)])
      (match (list 原自由 想替换 新自由)
        [(list #f #f #f) 结果]
        [(list #f _ _) (raise (format "无法操作原非自由变量 ~e" 变量))]
        [else 结果])))

  (define (替换身体 身体)
    (cond
      [(symbol? 身体) (替换变量 身体)]
      [(list? 身体) (map 替换身体 身体)]
      [else (raise (format "身体中应只含有符号和列表，但是得到了: ~e" 身体))]))

  (define 新身体 (替换身体 (cdr 事实)))
  (cons (set-intersect (set-union (set-subtract (car 事实) (list->set (hash-keys 替换表))) 新变量)
                       (list->set (flatten 新身体)))
        新身体))

(define (推理 大前提 小前提)
  (match (cons 大前提 小前提)
    [(cons (cons 大变量 (list '若 前提 结论)) (cons 小变量 事实))
     (if (and (equal? 前提 事实) (subset? 小变量 大变量))
         (cons (set-intersect 大变量 (list->set (flatten 结论))) 结论)
         (raise (format "无法推理，大前提 ~e 条件与小前提 ~e 不同或大变量 ~e 不包含小变量 ~e" 大前提 小前提 大变量 小变量)))]
    [else (raise (format "无法推理，大前提 ~e 和小前提 ~e 无法匹配" 大前提 小前提))]))

;; 引入一些辅助函数用于引擎中。 因为大部分系统可以生成无限个结论，所以需要限制长度。
;; 对于推理，只需要两个事实匹配即可，但是演绎需要一个替换表。
;; 使用演绎的话，如果不是为了重命名，应该需要紧接着一次推理，所以应该通过匹配来获得替换表。

(define (长度 身体)
  (cond
    [(symbol? 身体) 1]
    [(list? 身体) (foldr + 0 (map 长度 身体))]
    [else (raise (format "身体中应只含有符号和列表，但是得到了: ~e" 身体))]))

(define (匹配 模式变量 模式 事实变量 事实 双变量从他)
  (cond
    [(set-member? 事实变量 事实)
     (if (and 双变量从他 (set-member? 模式变量 模式))
         (hash 模式 事实)
         (hash))]
    [(symbol? 模式)
     (cond
       [(set-member? 模式变量 模式) (hash 模式 事实)]
       [(equal? 模式 事实) (hash)]
       [else (raise (format "不匹配，模式 ~e 既不是自由变量，也和事实 ~e 不同" 模式 事实))])]
    [(list? 模式)
     (if (and (list? 事实) (equal? (length 模式) (length 事实)))
         (foldr (lambda (表一 表二)
                  (for/fold ([表 表一]) ([(k v2) (in-hash 表二)])
                    (hash-set 表
                              k
                              (if (hash-has-key? 表 k)
                                  (let ([v1 (hash-ref 表 k)])
                                    (if (equal? v1 v2)
                                        v2
                                        (raise (format "矛盾，模式 ~e 同时匹配到 ~e 和 ~e" k v1 v2))))
                                  v2))))
                (hash)
                (map (lambda (子模式 子事实) (匹配 模式变量 子模式 事实变量 子事实 双变量从他)) 模式 事实))
         (raise (format "不匹配，模式 ~e 是列表，但事实 ~e 不是列表或长度不同" 模式 事实)))]
    [else (raise (format "模式中应只含有符号和列表，但是得到了: ~e" 模式))]))

(define (正绎 事实 启发)
  (match (cons 事实 启发)
    [(cons (cons 事实变量 (list '若 事实前提 事实结论)) (cons 启发变量 启发身体)) (演绎 启发变量 (匹配 事实变量 事实前提 启发变量 启发身体 #t) 事实)]
    [else (raise (format "输入的事实 ~e 和启发 ~e 无法匹配，无法演绎" 事实 启发))]))

(define (反绎 事实 启发)
  (match (cons 事实 启发)
    [(cons (cons 事实变量 事实身体) (cons 启发变量 (list '若 启发前提 启发结论))) (演绎 启发变量 (匹配 事实变量 事实身体 启发变量 启发前提 #f) 事实)]
    [else (raise (format "输入的事实 ~e 和启发 ~e 无法匹配，无法演绎" 事实 启发))]))

(define (演化 理论)
  (filter (lambda (x) (not (eq? null x)))
          (append* (for/list ([a 理论])
                     (append* (for/list ([b 理论])
                                (list (with-handlers ([string? (lambda (_) null)])
                                        (正绎 a b))
                                      (with-handlers ([string? (lambda (_) null)])
                                        (反绎 a b))
                                      (with-handlers ([string? (lambda (_) null)])
                                        (推理 a b)))))))))

(define (多演 理论 迭代 截断 钩子)
  (define (单次 理论)
    (append 理论
            (钩子 (filter (lambda (事实) (and (< (长度 (cdr 事实)) 截断) (not (member 事实 理论))))
                        (remove-duplicates (演化 理论))))))
  (foldr (lambda (f x) (f x)) 理论 (make-list 迭代 单次)))

(provide 恣
         展示
         演绎
         推理
         演化
         多演)
