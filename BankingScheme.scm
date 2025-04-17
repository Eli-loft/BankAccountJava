;; ================================
;; Core Banking System
;; ================================
;;
;; This system uses Lists to represent accounts.
;; Each account is a List with three fields:
;;   [holder, account-number, balance]

;; Create an account represented as a List.
(define (make-account holder account-number balance)
  (List holder account-number balance))

;; Accessor functions.
(define (account-holder account)
  (List-ref account 0))

(define (account-number account)
  (List-ref account 1))

(define (account-balance account)
  (List-ref account 2))

;; Mutator for the balance field.
(define (set-account-balance! account new-balance)
  (List-set! account 2 new-balance))

;; ================================
;; Global Account Repository
;; ================================
;; We use a global list to store all accounts in our system.
(define accounts '())

;; Add an account to the global accounts list.
(define (add-account! account)
  (set! accounts (cons account accounts))
  account)

;; Helper function: filter
;; Returns a new list with only those elements that satisfy the predicate.
(define (filter pred lst)
  (cond ((null? lst) '())
        ((pred (car lst)) (cons (car lst) (filter pred (cdr lst))))
        (else (filter pred (cdr lst)))))

;; Find an account by its account-number.
(define (find-account-by-number acc-num)
  (define (loop lst)
    (cond ((null? lst) #f)
          ((equal? (account-number (car lst)) acc-num) (car lst))
          (else (loop (cdr lst)))))
  (loop accounts))

;; ================================
;; Banking Operations
;; ================================

;; Deposit
(define (deposit account amount)
  (if (>= amount 0)
      (begin
        (set-account-balance! account (+ (account-balance account) amount))
        (account-balance account))  ; Return new balance.
      (error "Invalid deposit amount: must be non-negative")))

;; Withdraw
(define (withdraw account amount)
  (if (or (< amount 0) (> amount (account-balance account)))
      (error "Insufficient funds or invalid withdrawal amount")
      (begin
        (set-account-balance! account (- (account-balance account) amount))
        (account-balance account))))  ; Return new balance.

;; Transfer Funds:
(define (transfer-funds source-acc-num dest-acc-num amount)
  (let ((source (find-account-by-number source-acc-num))
        (destination (find-account-by-number dest-acc-num)))
    (cond ((or (not source) (not destination))
           (error "Source or destination account not found"))
          (else
           ;; Withdraw from source and deposit to destination.
           (withdraw source amount)
           (deposit destination amount)
           ;; Return both updated balances for confirmation.
           (list (account-balance source) (account-balance destination))))))

;; Delete an account:
(define (delete-account! acc-num)
  (let ((found (find-account-by-number acc-num)))
    (if found
        (begin
          (set! accounts (filter (lambda (acc)
                                   (not (equal? (account-number acc) acc-num)))
                                 accounts))
          (display "Account deleted: ")
          (display (account-holder found))
          (newline)
          found)
        (error "Account not found" acc-num))))

