;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prime Testing and Recursive Prime Generation - Base model
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (is-prime? n d)
  "Recursively checks if n is prime starting with divisor d. Returns #t if n is prime, #f otherwise."
  
  (cond
    ((< n 2) #f)                      ; Numbers under 2 arnt prime.
    ((> (* d d) n) #t)                ; If no divisor found until d^2 > n, then n is prime.
    ((= (modulo n d) 0) #f)            ; n is divisible by d, so n is composite.
    (else (is-prime? n (+ d 1)))))     ; Check with the next divisor.

(define (prime? n)
  "Wrapper to check if a number n is prime using the recursive method."
  (is-prime? n 2))


(define generate-primes-recursive
  (lambda (limit)
    "Generates a list of primes up to 'limit' using the recursive prime check."
    
    (letrec ((iter
              (lambda (n acc)
                (cond
                  ((> n limit) (reverse acc))
                  ((prime? n)   (iter (+ n 1) (cons n acc)))
                  (else         (iter (+ n 1) acc))))))
      (iter 2 '()))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sieve of Eratosthenes - upgrade 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (sieve-of-eratosthenes limit)
  "Generates a list of prime numbers up to 'limit' using the Sieve of Eratosthenes."
  
  (let ((sieve (make-list (+ limit 1) #t)))   ; Create a list of size limit+1 (assume all numbers are prime)
    
    ;; Mark 0 and 1 as non-prime.
    (when (>= limit 0) (list-set! sieve 0 #f))
    (when (>= limit 1) (list-set! sieve 1 #f))
    
    ;; Sieve: for each number starting at 2, mark its multiples.
    (let sieve-loop ((i 2))
      (when (<= (* i i) limit)
        (when (list-ref sieve i)          ; Only process i if it has not been marked as composite.
          (let mark-loop ((j (* i i)))
            (when (<= j limit)
              (list-set! sieve j #f)
              (mark-loop (+ j i)))))
        (sieve-loop (+ i 1))))
    
    ;; Build the list of primes by collecting indices still marked as #t.
    (let build-list ((i 0) (acc '()))
      (if (> i limit)
          (reverse acc)
          (if (list-ref sieve i)
              (build-list (+ i 1) (cons i acc))
              (build-list (+ i 1) acc))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optimized Sieve: Only Process Odd Numbers - upgrade 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (sieve-odd limit)
  "Generates a list of prime numbers up to 'limit', using a sieve that only processes odd numbers.
  The result includes 2 (if  limit >= 2) followed by odd primes from 3 up to 'limit'."
  (if (< limit 2)
      '()
      (let* ((primes-acc (if (>= limit 2) (list 2) '()))
             
             ;; Count odd numbers from 3 to limit.
             (lst-length (if (< limit 3) 0 (+ 1 (quotient (- limit 3) 2))))
             
             ;; Create a list representing the odd numbers:
             ;; index j corresponds to the odd number (2j + 3).
             (sieve (make-list lst-length #t)))
        
        ;; Sieve loop over list indices.
        (let sieve-loop ((j 0))
          (when (< j lst-length)
            (when (list-ref sieve j)
              (let ((p (+ (* 2 j) 3)))  ; Map index j to its corresponding odd number.
                (when (<= (* p p) limit)
                  (let loop-mark ((k (quotient (- (* p p) 3) 2)))
                    (when (< k lst-length)
                      (list-set! sieve k #f)
                      (loop-mark (+ k p)))))))
            (sieve-loop (+ j 1))))
        
        ;; Collect the odd primes from the sieve.
        (let collect ((j 0) (acc primes-acc))
          (if (>= j lst-length)
              (reverse acc)
              (let ((n (+ (* 2 j) 3)))  ; Compute the actual odd number.
                (if (list-ref sieve j)
                    (collect (+ j 1) (cons n acc))
                    (collect (+ j 1) acc))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Segmented Sieve (with Internal Segment Size) - upgrade 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (segmented-sieve limit)
  "Generates prime numbers up to 'limit' using a segmented sieve.
   The segment size is determined internally to optimize efficiency."
  (if (< limit 2)
      '()
      (let* ((base-limit (inexact->exact (floor (sqrt limit))))
             
             ;; Generate base primes up to sqrt limit using the Sieve of Eratosthenes.
             (base-primes (sieve-of-eratosthenes base-limit))
             (primes base-primes)
             
             ;; Define internal segment size based on limit (for small limits, one segment).
             (segment-size (if (< limit 1000000) limit 32768)))
        
        ;; Process segments from (base-limit + 1) to limit.
        (let loop-segments ((low (+ base-limit 1)))
          (when (<= low limit)
            (let* ((high (min limit (+ low segment-size -1)))
                   (current-size (+ (- high low) 1))
                   
                   ;; Create a list for current segment representing numbers from low to high.
                   (segment (make-list current-size #t)))
              
              ;; Mark composites in the current segment using each base prime.
              (for-each
               (lambda (p)
                 (let ((start (max (* p p)
                                   (if (zero? (remainder low p))
                                       low
                                       (+ low (- p (remainder low p)))))))
                   (do ((j start (+ j p)))
                       ((> j high))
                     (list-set! segment (- j low) #f))))
               base-primes)
              
              ;; Collect primes from the current segment.
              (let collect ((i 0) (seg-primes '()))
                (if (>= i current-size)
                    (set! primes (append primes (reverse seg-primes)))
                    (let ((n (+ low i)))
                      (if (list-ref segment i)
                          (collect (+ i 1) (cons n seg-primes))
                          (collect (+ i 1) seg-primes)))))
              (loop-segments (+ high 1)))))
        primes)))