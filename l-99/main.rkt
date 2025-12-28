#lang racket

;; P01 (*) Find the last box of a list.                      
;;     Example:                                              
;;     * (my-last '(a b c d))                                
;;     (D)                                                   
(define (my-last l)
  (if (null? (cdr l))
      l
      (my-last (cdr l))))

;; (my-last '(1 2 3 4 5))

;; P02 (*) Find the last but one box of a list.              
;;     Example:                                              
;;     * (my-but-last '(a b c d))                            
;;     (C D)                                                 

(define (my-but-last l)
  (if (null? (cddr  l))
      l
      (my-but-last (cdr l))))

;; (my-but-last '(1 2 3 4 5))

;; P03 (*) Find the K'th element of a list.                  
;;     The first element in the list is number 1.            
;;     Example:                                              
;;     * (element-at '(a b c d e) 3)                         
;;     C                                                     

(define (element-at l n)
  (if (= n 1)
      (car l)
      (element-at (cdr l)
                  (- n 1))))

;; (element-at '(1 2 3 4 5) 2)

;; P04 (*) Find the number of elements of a list.            

(define (length l)
  (define (helper acc lst)
    (if (null? lst)
        acc
        (helper (+ acc 1) (cdr lst))))
  (helper 0 l))

;; (length '(1 2 3 4 5))

;; P05 (*) Reverse a list.                                   

(define (reverse l)
  (define (helper acc lst)
    (if (null? lst)
        acc
        (helper (cons (car lst) acc)
                (cdr lst))))
  (helper '() l))

;; (reverse '(1 2 3 4 5))

;; P06 (*) Find out whether a list is a palindrome.          
;;     A palindrome can be read forward or backward; e.g. (x 
;;     a m a x).                                             

(define (nth-cdr l n)
  (if (= n 1)
      l
      (nth-cdr (cdr l) (- n 1))))

(define (till-n l n)
  (let ((len (length l)))
    (if (= len n)
        l
        (till-n (cdr l) (+ n 1)))))

;; P07 (**) Flatten a nested list structure.                 
;;     Transform a list, possibly holding lists as elements  
;;     into a `flat' list by replacing each list with its    
;;     elements (recursively).                               
;;
;;     Example:                                              
;;     * (my-flatten '(a (b (c d) e)))                       
;;     (A B C D E)                                           
;;
;;     Hint: Use the predefined functions list and append.   

(define (flatten l)
  (cond ((null? l) null)
        ((not (pair? l)) (list l))
        (else
          (append (flatten (car l))
                  (flatten (cdr l))))))

;; (flatten '(1 2 (12 34) (1 8 2) 1 7))

;; P08 (**) Eliminate consecutive duplicates of list         
;; elements.                                                 
;;     If a list contains repeated elements they should be   
;;     replaced with a single copy of the element. The order 
;;     of the elements should not be changed.                
;;
;;     Example:                                              
;;     * (compress '(a a a a b c c a a d e e e e))           
;;     (A B C A D E)                                         

(define (compress l)
  (cond ((null? l) null)
        ((null? (cdr l)) l)
        ((= (car l) (cadr l))
         (compress (cdr l)))
        (else
          (cons (car l)
                (compress (cdr l))))))

;; (compress '(1
;;             2
;;             3 3 3
;;             2
;;             3 3 3 3
;;             4 4 4 4
;;             1 1 1 1))

;; P09 (**) Pack consecutive duplicates of list elements into
;; sublists.                                                 
;;     If a list contains repeated elements they should be   
;;     placed in separate sublists.                          
;;
;;     Example:                                              
;;     * (pack '(a a a a b c c a a d e e e e))               
;;     ((A A A A) (B) (C C) (A A) (D) (E E E E))             

(define (pack l)
  (if (not (null? (cdr l)))
      (let ((res (pack (cdr l))))
        (if (eq? (car l) (cadr l))
            (cons (cons (car l) (car res))
                  (cdr res))
            (cons (cons (car l) null)
                  res)))
      (if (not (null? l))
          (list l)
          null)))

;; (pack '(3 3 3 3 3 3 3
;;         4 4 4 4
;;         1 1 1 1))

;; P10 (*) Run-length encoding of a list.                    
;;     Use the result of problem P09 to implement the so-    
;;     called run-length encoding data compression method.   
;;     Consecutive duplicates of elements are encoded as     
;;     lists (N E) where N is the number of duplicates of the
;;     element E.                                            
;;
;;     Example:                                              
;;     * (encode '(a a a a b c c a a d e e e e))             
;;     ((4 A) (1 B) (2 C) (2 A) (1 D)(4 E))                  

(define (encode l)
  (define (helper x)
    (if (null? (cdr x))
        (cons 1 x)
        (list (length x) (car x))))
  (map helper (pack l)))

;; (encode '("g" "g" "g" "g" "g" "g" "g"
;;           "h" "h" "h" "h"
;;           "t" "t" "t" "t"
;;           "f"))

;; P11 (*) Modified run-length encoding.                     
;;     Modify the result of problem P10 in such a way that if
;;     an element has no duplicates it is simply copied into 
;;     the result list. Only elements with duplicates are    
;;     transferred as (N E) lists.                           
;;
;;     Example:                                              
;;     * (encode-modified '(a a a a b c c a a d e e e e))    
;;     ((4 A) B (2 C) (2 A) D (4 E))                         

(define (encode-modified l)
  (define (helper x)
    (if (null? (cdr x))
        x
        (list (length x) (car x))))
  (map helper (pack l)))

;; (encode-modified '("g" "g" "g" "g" "g" "g" "g"
;;                    "h" "h" "h" "h"
;;                    "t" "t" "t" "t"
;;                    "f"))

;; P12 (**) Decode a run-length encoded list.                
;;     Given a run-length code list generated as specified in
;;     problem P11. Construct its uncompressed version.      

(define (decode lst)
  (define (help n ex)
    (if (= n 1)
        (cons ex null)
        (cons ex (help (- n 1) ex))))
  (define (decode-el x)
    (let ((rep (car x))
          (el (cadr x)))
      (help rep el)))
  (map decode-el lst))

;; (decode '((7 "g") (4 "h") (4 "t") (1 "f")))

;; P13 (**) Run-length encoding of a list (direct solution). 
;;     Implement the so-called run-length encoding data      
;;     compression method directly. I.e. don't explicitly    
;;     create the sublists containing the duplicates, as in  
;;     problem P09, but only count them. As in problem P11,  
;;     simplify the result list by replacing the singleton   
;;     lists (1 X) by X.                                     
;;
;;     Example:                                              
;;     * (encode-direct '(a a a a b c c a a d e e e e))      
;;     ((4 A) B (2 C) (2 A) D (4 E))                         

;; (display "tf is this sht, i don't even understand\n")

;; P14 (*) Duplicate the elements of a list.                 
;;     Example:                                              
;;     * (dupli '(a b c c d))                                
;;     (A A B B C C C C D D)                                 

(define (dupli lst)
  (if (null? lst)
      lst
      (let ((el (car lst)))
        (cons el (cons el (dupli (cdr lst)))))))

;; (dupli '(1 2 3 3 7))

;; P15 (**) Replicate the elements of a list a given number  
;; of times.                                                 
;;     Example:                                              
;;     * (repli '(a b c) 3)                                  
;;     (A A A B B B C C C)                                   

(define (repli lst n)
  (define (helper-rep expr x)
    (if (= x 1)
        (cons expr null)
        (cons expr (helper-rep expr (- x 1)))))
  (if (null? lst)
      lst
      (let ((el (car lst)))
        (append (helper-rep el n)
                (repli (cdr lst) n)))))

;; (repli '(1 2 3) 3)

;; P16 (**) Drop every N'th element from a list.             
;;     Example:                                              
;;     * (drop '(a b c d e f g h i k) 3)                     
;;     (A B D E G H K)                                       

(define (drop lst n)
  (define (helper lst cnt)
    (cond ((null? lst) null)
          ((= cnt 1)
           (helper (cdr lst) n))
          (else (cons (car lst)
                      (helper (cdr lst)
                              (- cnt 1))))))
  (helper lst n))

;; (drop '(2 123 31 8 9 8 17 86) 3)

;; P17 (*) Split a list into two parts; the length of the    
;; first part is given.                                      
;;     Do not use any predefined functions.                  
;;
;;     Example:                                              
;;     * (split '(a b c d e f g h i k) 3)                    
;;     ( (A B C) (D E F G H I K))                            

(define (split lst n)
  (define (helper l cnt acc)
    (cond ((null? l) null)
          ((= cnt 0)
           (list (reverse acc) l))
          (else
            (helper (cdr l)
                    (- cnt 1)
                    (cons (car l) acc)))))
  (helper lst n null))

;; (split '(2 123 31 8 9 8 17 86) 3)

;; P18 (**) Extract a slice from a list.                     
;;     Given two indices, I and K, the slice is the list     
;;     containing the elements between the I'th and K'th     
;;     element of the original list (both limits included).  
;;     Start counting the elements with 1.                   
;;
;;     Example:                                              
;;     * (slice '(a b c d e f g h i k) 3 7)                  
;;     (C D E F G)                                           

(define (slice lst start end)
  (define (helper l cnt acc)
    (cond ((null? l) null)
          ((< cnt start)
           (helper (cdr l) (+ cnt 1) acc))
          ((> cnt end)
           acc)
          (else (helper
                  (cdr l)
                  (+ cnt 1)
                  (append acc
                          (list (car l)))))))
  (helper lst 0 null))

;; (slice '(2 123 31 8 9 8 17 86) 2 5)

;; P19 (**) Rotate a list N places to the left.              
;;     Examples:                                             
;;     * (rotate '(a b c d e f g h) 3)                       
;;     (D E F G H A B C)                                     
;;
;;     * (rotate '(a b c d e f g h) -2)                      
;;     (G H A B C D E F)                                     
;;
;;     Hint: Use the predefined functions length and append, 
;;     as well as the result of problem P17.                 

(define (rotate lst)
  (cond ((null? lst) null)
        (else
          (append (cdr (cdr (cdr lst)))
                  (list (car lst)
                        (car (cdr lst))
                        (car (cdr (cdr lst))))))))

(rotate '(2 123 31 8 9 8 17 86))

;; P20 (*) Remove the K'th element from a list.              
;;     Example:                                              
;;     * (remove-at '(a b c d) 2)                            
;;     (A C D)                                               

(define (remove-at lst n)
  (if (= n 1)
      (cdr lst)
      (cons (car lst)
            (remove-at (cdr lst) (- n 1)))))

;; P21 (*) Insert an element at a given position into a list.                                                            
;;     Example:                                                                                                          
;;     * (insert-at 'alfa '(a b c d) 2)                                                                                  
;;     (A ALFA B C D)                                                                                                    

(define (insert-at e l p)
  (define (helper acc lst ind)
    (cond ((= ind 1)
           (append (reverse acc) e lst))
          (else (helper
                  (cons (car lst)
                        acc)
                  (cdr lst)
                  (- ind 1)))))
  (helper null l p))

(insert-at '(696969) '(1 3 41 2 8) 3)

;; P22 (*) Create a list containing all integers within a given range.                                                   
;;     If first argument is smaller than second, produce a list in decreasing order.                                     
;;     Example:                                                                                                          
;;     * (range 4 9)                                                                                                     
;;     (4 5 6 7 8 9)                                                                                                     

(define (range start end)
  (define (helper acc s e)
    (if (> s e)
        (reverse acc)
        (helper (cons s acc)
                (+ s 1)
                e)))
  (helper null start end))
(range 2 9)

;; P23 (**) Extract a given number of randomly selected elements from a list.                                            
;;     The selected items shall be returned in a list.                                                                   
;;     Example:                                                                                                          
;;     * (rnd-select '(a b c d e f g h) 3)                                                                               
;;     (E D A)                                                                                                           

(define (rnd-select lst n)
  (define (helper acc ind)
    (if (= ind 0) acc
        (let ((x (+ 1 (random
                        (length lst)))))
          (helper (cons (element-at lst x)
                        acc)
                  (- ind 1)))))
  (helper null n))

;; (rnd-select '(12 3 12 92 3 47 18 26 8 1) 5)

;; P24 (*) Lotto: Draw N different random numbers from the set 1..M.  
;;     The selected numbers shall be returned in a list.              
;;     Example:                                                       
;;     * (lotto-select 6 49)                                          
;;     (23 1 17 33 21 37)                                             
;;
;;     Hint: Combine the solutions of problems P22 and P23.           

(define (lotto-select n rng)
  (define (helper acc ind)
    (if (= ind 0)
        acc
        (let ((x (random rng)))
          (helper (cons x acc)
                  (- ind 1)))))
  (helper null n))

(lotto-select 3 67)

;; P25 (*) Generate a random permutation of the elements of a list.   
;;     Example:                                                       
;;     * (rnd-permu '(a b c d e f))                                   
;;     (B A D C E F)                                                  

(define (rnd-permu lst)
  (rnd-select lst
              (length lst)))

(rnd-permu '(12 3 12 92 3 47 18 26 8 1))

;; P26 (**) Generate the combinations of K distinct objects chosen    
;; from the N elements of a list                                      
;;     In how many ways can a committee of 3 be chosen from a group   
;;     of 12 people? We all know that there are C(12,3) = 220         
;;     possibilities (C(N,K) denotes the well-known binomial          
;;     coefficients). For pure mathematicians, this result may be     
;;     great. But we want to really generate all the possibilities in 
;;     a list.                                                        
;;
;;     Example:                                                       
;;     * (combination 3 '(a b c d e f))                               
;;     ((A B C) (A B D) (A B E) ... )                                 

(define (combination n lst)
  (cond ((null? lst) null)
        ((= n 0) (list lst))
        ((= n 1) (map list lst))
        (else (append
                (combination n (cdr lst))
                (map (lambda (x)
                       (cons (car lst)
                             x))
                     (combination (- n 1)
                                  (cdr lst)))))))

(combination 2 '(18 26 8 9))

;; P27 (**) Group the elements of a set into disjoint subsets.                          
;;      a) In how many ways can a group of 9 people work in 3 disjoint subgroups of 2,  
;;      3 and 4 persons? Write a function that generates all the possibilities and      
;;      returns them in a list.                                                         
;;
;;      Example:                                                                        
;;      * (group3 '(aldo beat carla david evi flip gary hugo ida))                      
;;      ( ( (ALDO BEAT) (CARLA DAVID EVI) (FLIP GARY HUGO IDA) )                        
;;      ... )                                                                           
;;
;;      b) Generalize the above function in a way that we can specify a list of group   
;;      sizes and the function will return a list of groups.                            
;;
;;      Example:                                                                        
;;      * (group '(aldo beat carla david evi flip gary hugo ida) '(2 2 5))              
;;      ( ( (ALDO BEAT) (CARLA DAVID) (EVI FLIP GARY HUGO IDA) )                        
;;      ... )                                                                           
;;
;;      Note that we do not want permutations of the group members; i.e. ((ALDO BEAT)   
;;      ...) is the same solution as ((BEAT ALDO) ...). However, we make a difference   
;;      between ((ALDO BEAT) (CARLA DAVID) ...) and ((CARLA DAVID) (ALDO BEAT) ...).    
;;
;;      You may find more about this combinatorial problem in a good book on discrete   
;;      mathematics under the term "multinomial coefficients".                          

(define (group l num)
  (display "TODO\n"))

;; P28 (**) Sorting a list of lists according to length of sublists                          
;;    a) We suppose that a list contains elements that are lists themselves. The objective   
;;    is to sort the elements of this list according to their length. E.g. short lists       
;;    first, longer lists later, or vice versa.                                              
;;
;;    Example:                                                                               
;;    * (lsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))                           
;;    ((O) (D E) (D E) (M N) (A B C) (F G H) (I J K L))                                      
;;
;;    b) Again, we suppose that a list contains elements that are lists themselves. But this 
;;    time the objective is to sort the elements of this list according to their length      
;;    frequency; i.e., in the default, where sorting is done ascendingly, lists with rare    
;;    lengths are placed first, others with a more frequent length come later.               
;;
;;    Example:                                                                               
;;    * (lfsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))                          
;;    ((I J K L) (O) (A B C) (F G H) (D E) (D E) (M N))                                      
;;
;;    Note that in the above example, the first two lists in the result have length 4 and 1, 
;;    both lengths appear just once. The third and forth list have length 3 which appears    
;;    twice (there are two list of this length). And finally, the last three lists have      
;;    length 2. This is the most frequent length.                                            

;; (a)
(define (lsort lst)
  (sort lst (lambda (x y)
              (if (< (length x)
                     (length y))
                  true
                  false))))

(lsort '((1) (8 9 2) (23 4) (4 5 76)))

(define (freq lst item)
  (define (helper acc l)
    (if (null? l) acc
        (if (eq? (car l) item)
            (helper (+ 1 acc) (cdr l))
            (helper acc (cdr l)))))
  (helper 0 lst))

(define (length-list lst)
  (define (helper acc l)
    (if (null? l)
        (reverse acc)
        (helper (cons (length (car l))
                      acc)
                (cdr l))))
  (helper null lst))

(define (lfsort lst)
  (sort lst (lambda (x y)
              (if (< (freq (length-list lst)
                           (length y))
                     (freq (length-list lst)
                           (length x)))
                  true
                  false))))

(lfsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))

;; after this everything is SICP noooooo D:
