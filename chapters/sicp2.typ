#import "@preview/board-n-pieces:0.7.0": board, position

#let counter = counter("section2")
#std.counter("section2").update(1)

#show heading.where(level: 1): subprob => {
  counter.update(1)
  subprob
}

#let prob(body) = {
  context [ == Exercise #counter.step() #counter.display() ]
  block(
    width: 100%,
    inset: 1em,
    stroke:black,
    body
  )
}

#let answer(body) = {
  block(
    width: 100%,
    inset: 1em,
    fill: luma(240),
    body
  )
}

#let notes(body) = {
  block(
    width: 100%,
    inset: 1em,
    fill: luma(240),
    body
  )
}

#show heading.where(level: 1): it => {
  page([
    #align(center + horizon)[
      #set text(size: 26pt, weight: "bold")
      #it.body
    ]
  ])
}

= SECTION 2

#notes([
  say gex
])

#prob([
  Define a better version of
  `make-rat` that handles both positive and negative arguments.
  `Make-rat` should normalize the sign so that if the rational number is
  positive, both the numerator and denominator are positive, and if the rational
  number is negative, only the numerator is negative.
])

#answer([
  idk how........but uhhhhhh........this _automatically_ works in racket with.......definition as is
  ```lisp
(define (make-rat n d)
  (cond ((< d 0) (make-rat (- n) (- d)))
        (else (let ((g (gcd n d)))
                (cons (/ n g)
                      (/ d g))))))

(make-rat 4 12)
;'(1 . 3)
(make-rat 4 -12)
;'(1 . -3)
(make-rat -4 12)
;'(1 . -3)
(make-rat -4 -12)
;'(1 . 3)

  ```
])

#prob([
Consider the problem of
representing line segments in a plane.  Each segment is represented as a pair
of points: a starting point and an ending point.  Define a constructor
`make-segment` and selectors `start-segment` and `end-segment`
that define the representation of segments in terms of points.  Furthermore, a
point can be represented as a pair of numbers: the $x$ coordinate and the
$y$ coordinate.  Accordingly, specify a constructor `make-point` and
selectors `x-point` and `y-point` that define this representation.
Finally, using your selectors and constructors, define a procedure
`midpoint-segment` that takes a line segment as argument and returns its
midpoint (the point whose coordinates are the average of the coordinates of the
endpoints).  To try your procedures, you'll need a way to print points:

```lisp
(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))
```
])

#answer([
```lisp
(define (make-point x y)
  (cons x y))
(define (x-point p)
  (car p))
(define (y-point p)
  (cdr p))

(define (make-segment p1 p2)
  (cons p1 p2))
(define (start-segment s)
  (car s))
(define (end-segment s)
  (cdr s))

(define (midpoint-segment s)
  (define (mid-x x1 x2)
    (/ (+ x1 x2) 2))
  (define (mid-y y1 y2)
    (/ (+ y1 y2) 2))
  (define x1 (car (car s)))
  (define x2 (car (cdr s)))
  (define y1 (cdr (car s)))
  (define y2 (cdr (cdr s)))
  (cons (mid-x x1 x2) (mid-y y1 y2)))


(define (print-point p)
  (newline)
  (display "[")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display "]"))

(print-point (midpoint-segment (make-segment 
                                  (make-point 0 0) 
                                  (make-point 2 2))))
; [1,1]
  ```
])

#prob([
  Implement a representation for
  rectangles in a plane.  (Hint: You may want to make use of Exercise 2.2.)
  In terms of your constructors and selectors, create procedures that compute the
  perimeter and the area of a given rectangle.  Now implement a different
  representation for rectangles.  Can you design your system with suitable
  abstraction barriers, so that the same perimeter and area procedures will work
  using either representation?
])

#answer([
  ok so this is basically just asking us to make a rectangle given two points\
  god this is tedious

  ```lisp
(define (make-point x y)
  (cons x y))
(define (x-point p)
  (car p))
(define (y-point p)
  (cdr p))

(define (make-rect p1 p2)
  (define (height p1 p2)
    (abs (- (y-point p1) (y-point p2))))
  (define (width p1 p2)
    (abs (- (x-point p1) (x-point p2))))
  (cons (width p1 p2) (height p1 p2)))

(define (area r)
  (* (car r) (cdr r)))

(define (perimeter r)
  (* (abs (+ (car r) (cdr r))) 2))


(area (make-rect (make-point 0 0) (make-point 3 3)))
;9
(perimeter (make-rect (make-point 0 0) (make-point 3 3)))
;12
  ```
  ehhh idk? is this ok?

  now.......how tf are they asking me to make _implement a different representation for rectangles_ -w-
])

#prob([
  Here is an alternative procedural
  representation of pairs.  For this representation, verify that `(car (cons
  x y))` yields `x` for any objects `x` and `y`.

  ```lisp
  (define (cons x y) 
    (lambda (m) (m x y)))

  (define (car z) 
    (z (lambda (p q) p)))
  ```

  What is the corresponding definition of `cdr`? (Hint: To verify that this
  works, make use of the substitution model of 1.1.5.)
])

#answer([
```lisp
(define (cons x y) 
  (lambda (m) (m x y)))

(define (car z) 
  (z (lambda (p q) p)))

(car (cons 3 4))
; 3

(define (cdr z)
  (z (lambda (p q) q)))

(cdr (cons 3 4))
; 4
  ```
  first try ezz
])

#prob([
  Show that we can represent pairs of
  nonnegative integers using only numbers and arithmetic operations if we
  represent the pair $a$ and $b$ as the integer that is the product $2^a 3^b$.
  Give the corresponding definitions of the procedures `cons`, `car`, and `cdr`.
])

#answer([
  ```lisp
(define (log base n)
  (define (helper prod k)
    (if (eq? (gcd prod n)
             prod)
        (helper (* base prod)
                (+ k 1))
        k))
  (helper base 0))

(define (power n m)
  (if (< m 1)
      1
      (* (power n (- m 1))
         n)))

(define (my-cons a b)
  (* (power 2 a)
     (power 3 b)))
(define (my-car x)
  (log 2 x))
(define (my-cdr x)
  (log 3 x))
  ```

])

#prob([
In case representing pairs as
procedures wasn't mind-boggling enough, consider that, in a language that can
manipulate procedures, we can get by without numbers (at least insofar as
nonnegative integers are concerned) by implementing 0 and the operation of
adding 1 as

```lisp
(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))
```

This representation is known as Church numerals, after its inventor,
Alonzo Church, the logician who invented the $lambda$-calculus.

Define `one` and `two` directly (not in terms of `zero` and
`add-1`).  (Hint: Use substitution to evaluate `(add-1 zero)`).  Give
a direct definition of the addition procedure `+` (not in terms of
repeated application of `add-1`).
])

#answer([
applying add-1 to zero will give us the value of one
so lets do that
  ```lisp
(add-1 zero)
((λ (f)
   (λ (x)
     (f ((n f) x)))) zero)

(λ (f)
   (λ (x)
     (f ((zero f) x))))

(λ (f)
   (λ (x)
     (f (((λ (f)
           (λ (x) x)) f) x))))

(λ (f)
   (λ (x)
     (f ((λ (x) x) x))))

(λ (f)
   (λ (x)
     (f ((λ (x) x) x))))

(λ (f)
   (λ (x)
     (f x))) ; this is one (this sht was so fucking ass T-T)
  ```
  ok bruh i also need 2
  ```lisp
(define one (λ (f) (λ (x) (f x))))
(add-1 one)
((λ (f)
   (λ (x)
     (f ((n f) x)))) one)
(λ (f)
   (λ (x)
     (f ((one f) x))))
(λ (f)
   (λ (x)
     (f (((λ (f)
            (λ (x)
              (f x))) f) x))))
(λ (f)
   (λ (x)
     (f ((λ (x) (f x)) x))))
(λ (f)
   (λ (x)
     (f (f x))))
  ```
  now for '+' operation
  ```lisp
(define (plus a b)
  (λ (f)
    (λ (x)
      ((a f) ((b f) x)))))
  ```
])

#prob([
Alyssa's program is incomplete
because she has not specified the implementation of the interval abstraction.
Here is a definition of the interval constructor:

```lisp
(define (make-interval a b) (cons a b))
```

Define selectors `upper-bound` and `lower-bound` to complete the
implementation.
])

#answer([
  ```lisp
  (define (upper-bound i) (car i))
  (define (lower-bound i) (cdr i))
  ```
])

#prob([
Using reasoning analogous to
Alyssa's, describe how the difference of two intervals may be computed.  Define
a corresponding subtraction procedure, called `sub-interval`.
])

#answer([
  ```lisp
(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y))))
  ```
])

#prob([
  The width of an interval
  is half of the difference between its upper and lower bounds.  The width is a
  measure of the uncertainty of the number specified by the interval.  For some
  arithmetic operations the width of the result of combining two intervals is a
  function only of the widths of the argument intervals, whereas for others the
  width of the combination is not a function of the widths of the argument
  intervals.  Show that the width of the sum (or difference) of two intervals is
  a function only of the widths of the intervals being added (or subtracted).
  Give examples to show that this is not true for multiplication or division.
])

#answer([ optional TODO ])

#prob([
  Ben Bitdiddle, an expert systems
  programmer, looks over Alyssa's shoulder and comments that it is not clear what
  it means to divide by an interval that spans zero.  Modify Alyssa's code to
  check for this condition and to signal an error if it occurs.
])

#answer([ optional TODO ])

#prob([
  In passing, Ben also cryptically
  comments: 'By testing the signs of the endpoints of the intervals, it is
  possible to break `mul-interval` into nine cases, only one of which
  requires more than two multiplications.'  Rewrite this procedure using Ben's
  suggestion.
])

#answer([ optional TODO ])

#prob([
  Define a constructor
  `make-center-percent` that takes a center and a percentage tolerance and
  produces the desired interval.  You must also define a selector `percent`
  that produces the percentage tolerance for a given interval.  The `center`
  selector is the same as the one shown above.
])

#answer([ optional TODO ])

#prob([
  Show that under the assumption of
  small percentage tolerances there is a simple formula for the approximate
  percentage tolerance of the product of two intervals in terms of the tolerances
  of the factors.  You may simplify the problem by assuming that all numbers are
  positive.
])

#answer([ optional TODO ])

#prob([
Demonstrate that Lem is right.
Investigate the behavior of the system on a variety of arithmetic
expressions. Make some intervals $A$ and $B$, and use them in computing the
expressions $A / A$ and $A / B$.  You will get the most insight by
using intervals whose width is a small percentage of the center value. Examine
the results of the computation in center-percent form (see Exercise 2.12).
])

#answer([ optional TODO ])

#prob([
Eva Lu Ator, another user, has
also noticed the different intervals computed by different but algebraically
equivalent expressions. She says that a formula to compute with intervals using
Alyssa's system will produce tighter error bounds if it can be written in such
a form that no variable that represents an uncertain number is repeated.  Thus,
she says, `par2` is a better program for parallel resistances than
`par1`.  Is she right?  Why?
])

#answer([ optional TODO ])

#prob([
  Explain, in general, why
  equivalent algebraic expressions may lead to different answers.  Can you devise
  an interval-arithmetic package that does not have this shortcoming, or is this
  task impossible?  (Warning: This problem is very difficult.)
])

#answer([ optional TODO ])

#prob([
  Define a procedure
  `last-pair` that returns the list that contains only the last element of a
  given (nonempty) list:

  ```lisp
  (last-pair (list 23 72 149 34))
  (34)
  ```
])

#answer([
  ```lisp
(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(last-pair (list 1 23 4 5))
; '(5)
  ```
])

#prob([
Define a procedure `reverse`
that takes a list as argument and returns a list of the same elements in
reverse order:

```lisp
(reverse (list 1 4 9 16 25))
(25 16 9 4 1)
```
])

#answer([
  THE PROBLEM!!! THE ONE AND ONLY!!! THE INTERVIEW PROBLEM!!!!\
  ```lisp
(define (reverse l)
  (if (null? l)
      l
      (append (reverse (cdr l)) (cons (car l) null))))

(reverse (list 1 2 3 4))
; '(4 3 2 1)
  ```
  also an iterative one for good measure btw
  ```lisp
(define (reverse-iter l)
  (define (helper result l)
    (if (null? l) result
        (helper (cons (car l) result)
                (cdr l))))
  (helper null l))
  ```
])

#prob([
Consider the change-counting
program of 1.2.2.  It would be nice to be able to easily change
the currency used by the program, so that we could compute the number of ways
to change a British pound, for example.  As the program is written, the
knowledge of the currency is distributed partly into the procedure
`first-denomination` and partly into the procedure `count-change`
(which knows that there are five kinds of U.S. coins).  It would be nicer to be
able to supply a list of coins to be used for making change.

We want to rewrite the procedure `cc` so that its second argument is a
list of the values of the coins to use rather than an integer specifying which
coins to use.  We could then have lists that defined each kind of currency:

```lisp
(define us-coins 
  (list 50 25 10 5 1))

(define uk-coins 
  (list 100 50 20 10 5 2 1 0.5))
```

We could then call `cc` as follows:

```lisp
(cc 100 us-coins)
292
```

To do this will require changing the program `cc` somewhat.  It will still
have the same form, but it will access its second argument differently, as
follows:

```lisp
(define (cc amount coin-values)
  (cond ((= amount 0) 
         1)
        ((or (< amount 0) 
             (no-more? coin-values)) 
         0)
        (else
         (+ (cc 
             amount
             (except-first-denomination 
              coin-values))
            (cc 
             (- amount
                (first-denomination 
                 coin-values))
             coin-values)))))
```

Define the procedures `first-denomination`,
`except-first-denomination` and `no-more?` in terms of primitive
operations on list structures.  Does the order of the list `coin-values`
affect the answer produced by `cc`?  Why or why not?
])

#answer([
  ```lisp
  (define (no-more? x) (null? x))
  (define (except-first-denomination x) (cdr x))
  (define (first-denomination x) (car x))
  ```
  shrimple
])

#prob([
The procedures `+`,
`*`, and `list` take arbitrary numbers of arguments. One way to
define such procedures is to use `define` with dotted-tail notation.  
In a procedure definition, a parameter list that has a dot before
the last parameter name indicates that, when the procedure is called, the
initial parameters (if any) will have as values the initial arguments, as
usual, but the final parameter's value will be a list of any
remaining arguments.  For instance, given the definition

```lisp
(define (f x y . z) ⟨body⟩)
```

the procedure `f` can be called with two or more arguments.  If we
evaluate

```lisp
(f 1 2 3 4 5 6)
```


then in the body of `f`, `x` will be 1, `y` will be 2, and
`z` will be the list `(3 4 5 6)`.  Given the definition

```lisp
(define (g . w) ⟨body⟩)
```


the procedure `g` can be called with zero or more arguments.  If we
evaluate

```lisp
(g 1 2 3 4 5 6)
```


then in the body of `g`, `w` will be the list `(1 2 3 4 5
6)`.

Use this notation to write a procedure `same-parity` that takes one or
more integers and returns a list of all the arguments that have the same
even-odd parity as the first argument.  For example,

```lisp
(same-parity 1 2 3 4 5 6 7)
(1 3 5 7)

(same-parity 2 3 4 5 6 7)
(2 4 6)
```
])

#answer([
  ```lisp
(define (same-parity f . x)
  (cond ((or (null? f) (null? x)) null)
        ((even? f) (find-even x))
        ((odd? f) (find-odd x))))

(define (find-even x)
  (define (help result lst)
    (cond ((null? lst) result)
          ((odd? (car lst)) (help result (cdr lst)))
          ((even? (car lst)) (help (cons (car lst) result) (cdr lst)))))
  (help null x))

(define (find-odd x)
  (define (help result lst)
    (cond ((null? lst) result)
          ((even? (car lst)) (help result (cdr lst)))
          ((odd? (car lst)) (help (cons (car lst) result) (cdr lst)))))
  (help null x))

(same-parity 8 2 3 4 5 6)
; '(6 4 2)
  ```
  ok so this is giving the solution  in reverse, and i know the reason BUT idk how to make append such that it appends a pair and a "non-pair" without messing up the tree
])

#prob([
The procedure `square-list`
takes a list of numbers as argument and returns a list of the squares of those
numbers.

```lisp
(square-list (list 1 2 3 4))
(1 4 9 16)
```

Here are two different definitions of `square-list`.  Complete both of
them by filling in the missing expressions:

```lisp
(define (square-list items)
  (if (null? items)
      nil
      (cons ⟨??⟩ ⟨??⟩)))

(define (square-list items)
  (map ⟨??⟩ ⟨??⟩))
```
])

#answer([
  ```lisp
(define (square-list items)
  (if (null? items)
      null
      (cons (* (car items) (car items)) (square-list (cdr items)))))

(define (square-list-2 items)
  (map (lambda (x) (* x x)) items))
  ```
])

#prob([
Louis Reasoner tries to rewrite
the first `square-list` procedure of Exercise 2.21 so that it
evolves an iterative process:

```lisp
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items nil))
```

Unfortunately, defining `square-list` this way produces the answer list in
the reverse order of the one desired.  Why?

Louis then tries to fix his bug by interchanging the arguments to `cons`:

```lisp
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square 
                     (car things))))))
  (iter items nil))
```

This doesn't work either.  Explain.
])

#answer([
  ok this is the EXACT issue i had with `Exercise 2.20` and i understand that in the first one it is pretty obvious, you're appending the _new value_ to the _old value which already HAS a list of the squares of the previous elements_

  in the second one though we get
```lisp
(square-list (list 1 2 3 4))
;'((((() . 1) . 4) . 9) . 16)
```
  so this is clearly doing 
```lisp
(cons (cons (cons (cons null 1) 4) 9) 16)
```
])

#prob([
The procedure `for-each` is
similar to `map`.  It takes as arguments a procedure and a list of
elements.  However, rather than forming a list of the results, `for-each`
just applies the procedure to each of the elements in turn, from left to right.
The values returned by applying the procedure to the elements are not used at
all---`for-each` is used with procedures that perform an action, such as
printing.  For example,

```lisp
(for-each 
 (lambda (x) (newline) (display x))
 (list 57 321 88))

57
321
88
```

The value returned by the call to `for-each` (not illustrated above) can
be something arbitrary, such as true.  Give an implementation of
`for-each`.
])

#answer([
  ```lisp
(define (for-each proc items)
  (proc (car items))
  (if (null? (cdr items)) true
      (for-each proc (cdr items))))

(for-each (lambda (x) (newline)
                      (display x)
                      (display "->")
                      (display (square x))) (list 1 2 3 4 5))
; 1->1
; 2->4
; 3->9
; 4->16
; 5->25#t
  ```
])

#prob([
  Suppose we evaluate the
  expression `(list 1 (list 2 (list 3 4)))`.  Give the result printed by the
  interpreter, the corresponding box-and-pointer structure, and the
  interpretation of this as a tree (as in Figure 2.6).
])

#answer([
  #grid(
    align: center,
    columns: (auto, auto),    
    gutter: 10pt, [
  ```lisp
(list 1 (list 2 (list 3 4)))
; (1 (2 (3 4)))
  ```
  ], [ #image("../images/2-24.png", width: 60%) ])
])

#prob([
Give combinations of `car`s
and `cdr`s that will pick 7 from each of the following lists:

```lisp
(1 3 (5 7) 9)
((7))
(1 (2 (3 (4 (5 (6 7))))))
```
])

#answer([
  ```lisp
(define l1 (list 1 3 (list 5 7) 9))
(define l2 (list (list 7)))
(define l3 (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))
(car (cdr (car (cdr (cdr l1)))))
(car (car l2))
(car
  (cdr
    (car
      (cdr
        (car
          (cdr                            ; stairs :O
            (car
              (cdr
                (car
                  (cdr
                    (car
                      (cdr l3)))))))))))) ;(what even is this question bro XD)
  ```
])

#prob([
Suppose we define `x` and
`y` to be two lists:

```lisp
(define x (list 1 2 3))
(define y (list 4 5 6))
```

What result is printed by the interpreter in response to evaluating each of the
following expressions:

```lisp
(append x y)
(cons x y)
(list x y)
```
])

#answer([
  ```lisp
(append x y)
; '(1 2 3 4 5 6)
(cons x y)
; '((1 2 3) 4 5 6)
(list x y)
; '((1 2 3) (4 5 6))
  ```
])

#prob([
Modify your `reverse`
procedure of Exercise 2.18 to produce a `deep-reverse` procedure
that takes a list as argument and returns as its value the list with its
elements reversed and with all sublists deep-reversed as well.  For example,

```lisp
(define x 
  (list (list 1 2) (list 3 4)))

x
((1 2) (3 4))

(reverse x)
((3 4) (1 2))

(deep-reverse x)
((4 3) (2 1))
```
])

#answer([
```lisp
(define (reverse l)
  (define (helper result l)
    (if (null? l) result
        (helper (cons (car l) result)
                (cdr l))))
  (helper null l))

(define (deep-reverse x)
  (if (not (pair? x))
      x
      (reverse x)))
  ```
])

#prob([
Write a procedure `fringe`
that takes as argument a tree (represented as a list) and returns a list whose
elements are all the leaves of the tree arranged in left-to-right order.  For
example,

```lisp
(define x 
  (list (list 1 2) (list 3 4)))

(fringe x)
(1 2 3 4)

(fringe (list x x))
(1 2 3 4 1 2 3 4)
```
])

#answer([
ok so this one is wrong BUT it needs a _tiny_ bit of correction
```lisp
(define (fringe lst)
  (cond ((null? lst) null)
        ((not (pair? lst)) lst)
        (else (append (fringe (car lst))
                      (fringe (cdr lst))))))

(fringe '((1 2) (3 4) 9))
; append: contract violation
  ```
instead of returning the fringe as is _if not a pair_ we should return it by _making it a pair_
  ```lisp
(define (fringe lst)
  (cond ((null? lst) null)
        ((not (pair? lst)) (cons lst null))
        (else (append (fringe (car lst))
                      (fringe (cdr lst))))))

(fringe '((1 2) (3 4) 9))
; '(1 2 3 4 9)
  ```
  i basically copied the `count-leaves` program in the example
])

#prob([
A binary mobile consists of two
branches, a left branch and a right branch.  Each branch is a rod of a certain
length, from which hangs either a weight or another binary mobile.  We can
represent a binary mobile using compound data by constructing it from two
branches (for example, using `list`):

```lisp
(define (make-mobile left right)
  (list left right))
```

A branch is constructed from a `length` (which must be a number) together
with a `structure`, which may be either a number (representing a simple
weight) or another mobile:

```lisp
(define (make-branch length structure)
  (list length structure))
```

1. Write the corresponding selectors `left-branch` and `right-branch`,
which return the branches of a mobile, and `branch-length` and
`branch-structure`, which return the components of a branch.

2. Using your selectors, define a procedure `total-weight` that returns the
total weight of a mobile.

3. A mobile is said to be balanced if the torque applied by its top-left
branch is equal to that applied by its top-right branch (that is, if the length
of the left rod multiplied by the weight hanging from that rod is equal to the
corresponding product for the right side) and if each of the submobiles hanging
off its branches is balanced. Design a predicate that tests whether a binary
mobile is balanced.

4. Suppose we change the representation of mobiles so that the constructors are

```lisp
(define (make-mobile left right)
  (cons left right))

(define (make-branch length structure)
  (cons length structure))
```

How much do you need to change your programs to convert to the new
representation?
])

#answer([
  TODO (it's easy........i think)
])

#prob([
  Define a procedure
  `square-tree` analogous to the `square-list` procedure of
  Exercise 2.21.  That is, `square-tree` should behave as follows:

  ```lisp
  (square-tree
  (list 1
  (list 2 (list 3 4) 5)
  (list 6 7)))
  (1 (4 (9 16) 25) (36 49))
  ```

  Define `square-tree` both directly (i.e., without using any higher-order
  procedures) and also by using `map` and recursion.
])

#answer([
  ```lisp
(define (square-tree tree)
  (cond ((null? tree) null)
        ((not (pair? tree)) (square tree))
        (else (cons (square-tree (car tree))
                    (square-tree (cdr tree))))))

(define (square-tree-map tree)
  (define (sub-tree x)
    (if (not (pair? x))
        (square x)
        (square-tree-map x)))
  (map sub-tree tree))

(list 1 (list 2 (list 3 4) 5) (list 6 7))
; '(1 (2 (3 4) 5) (6 7))
(square-tree (list 1 (list 2 (list 3 4) 5) (list 6 7)))
; '(1 (4 (9 16) 25) (36 49))
(square-tree-map (list 1 (list 2 (list 3 4) 5) (list 6 7)))
; '(1 (4 (9 16) 25) (36 49))
  ```
])

#prob([
Abstract your answer to
Exercise 2.30 to produce a procedure `tree-map` with the property
that `square-tree` could be defined as

```lisp
(define (square-tree tree) 
  (tree-map square tree))
```
])

#answer([
  ```lisp
(define (tree-map proc tree)
  (cond ((null? tree) null)
        ((not (pair? tree)) (proc tree))
        (else (cons (tree-map proc (car tree))
                    (tree-map proc (cdr tree))))))

(define (sus x)
  (tree-map square x))

(sus (list 1 (list 2 (list 3 4) 5) (list 6 7)))
; '(1 (4 (9 16) 25) (36 49))
  ```
])

#prob([
We can represent a set as a list
of distinct elements, and we can represent the set of all subsets of the set as
a list of lists.  For example, if the set is `(1 2 3)`, then the set of
all subsets is `(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))`.  Complete the
following definition of a procedure that generates the set of subsets of a set
and give a clear explanation of why it works:

```lisp
(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map ⟨??⟩ rest)))))
```
])

#answer([
```lisp
(define (subsets s)
  (if (null? s)
      (list null)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (cons (car s) x)) rest)))))

(subsets (list 1 2 3))
; '(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))
  ```
])

#prob([
Fill in the missing expressions
to complete the following definitions of some basic list-manipulation
operations as accumulations:

```lisp
(define (map p sequence)
  (accumulate (lambda (x y) ⟨??⟩) 
              nil sequence))

(define (append seq1 seq2)
  (accumulate cons ⟨??⟩ ⟨??⟩))

(define (length sequence)
  (accumulate ⟨??⟩ 0 sequence))
```
])

#answer([
  ```lisp
(define (map-test p sequence)
  (accumulate (lambda (acc y) (cons (p y) acc))
              null sequence))

(define (append seq1 seq2)
  (accumulate cons seq1 seq2))

(define (length sequence)
  (accumulate (lambda (_ acc) (+ acc 1)) 0 sequence))
  ```
])

#prob([
Evaluating a polynomial in $x$
at a given value of $x$ can be formulated as an accumulation.  We evaluate
the polynomial

$ a_n x^n + a_(n-1) x^(n-1) + dots + a_1 x + a_0 $


using a well-known algorithm called Horner's rule, which structures
the computation as

$ (dots (a_n x + a_(n-1)) x + dots + a_1) x + a_0 $


In other words, we start with $a_n$, multiply by $x$, add
$a_(n-1)$, multiply by $x$, and so on, until we reach
$a_0$.

Fill in the following template to produce a procedure that evaluates a
polynomial using Horner's rule.  Assume that the coefficients of the polynomial
are arranged in a sequence, from $a_0$ through $a_n$.

```lisp
(define 
  (horner-eval x coefficient-sequence)
  (accumulate 
   (lambda (this-coeff higher-terms)
     ⟨??⟩)
   0
   coefficient-sequence))
```

For example, to compute $1 + 3x + 5x^3 + x^5$ at $x = 2$ you
would evaluate

```lisp
(horner-eval 2 (list 1 3 0 5 0 1))
```
])

#answer([
```lisp
(define (horner-eval x coefficient-sequence)
  (accumulate 
   (lambda (this-coeff higher-terms)
     (+ this-coeff (* higher-terms x)))
   0
   coefficient-sequence))
  ```
])

#prob([
Redefine `count-leaves` from
2.2.2 as an accumulation:

```lisp
(define (count-leaves t)
  (accumulate ⟨??⟩ ⟨??⟩ (map ⟨??⟩ ⟨??⟩)))
```
])

#answer([
  ```lisp
(define (count-leaves-test t)
  (accumulate (lambda (y x)
                (+ x y))
              0
              (map (lambda (x)
                     (if (not (pair? x))
                         1
                         (count-leaves-test x)))
                   t)))

(count-leaves-test (list (list 1 23) 1 2 3))
; 5
  ```
])

#prob([
The procedure `accumulate-n`
is similar to `accumulate` except that it takes as its third argument a
sequence of sequences, which are all assumed to have the same number of
elements.  It applies the designated accumulation procedure to combine all the
first elements of the sequences, all the second elements of the sequences, and
so on, and returns a sequence of the results.  For instance, if `s` is a
sequence containing four sequences, `((1 2 3) (4 5 6) (7 8 9) (10 11
12)),` then the value of `(accumulate-n + 0 s)` should be the sequence
`(22 26 30)`.  Fill in the missing expressions in the following definition
of `accumulate-n`:

```lisp
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init ⟨??⟩)
            (accumulate-n op init ⟨??⟩))))
```
])

#answer([
```lisp
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      null
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))
  ```
  this one i didn't think of,\
  i am still not getting used to the idea of thinking in a higher level of abstraction of map and acc i guess
])

#prob([
Suppose we represent vectors $v = (v_i)$ as sequences of numbers, and
matrices $m=(m_(i j))$ as sequences of vectors (the rows of the
matrix).  For example, the matrix

  $
  mat(
    1,2,3,4;
    4,5,6,6;
    6,7,8,9;
  )
  $


is represented as the sequence `((1 2 3 4) (4 5 6 6) (6 7 8 9))`.  With
this representation, we can use sequence operations to concisely express the
basic matrix and vector operations.  These operations (which are described in
any book on matrix algebra) are the following:
  #align(center)[
    (dot-product v w) returns $Sigma_i v_i w_i$\
    (matrix-\*-vector m v) returns the vector *t* where $t_i = Sigma_j m_(i j) w_i$\
    (matrix-\*-vector m n) returns the vector *p* where $p_(i j) = Sigma_k m_(i k) n_(k j)$\
    (transpose m) returns the vector *n* where $n_(i j) = m_(j i)$\
  ]

We can define the dot product as

```lisp
(define (dot-product v w)
  (accumulate + 0 (map * v w)))
```

Fill in the missing expressions in the following procedures for computing the
other matrix operations.  (The procedure `accumulate-n` is defined in
Exercise 2.36.)

```lisp
(define (matrix-*-vector m v)
  (map ⟨??⟩ m))

(define (transpose mat)
  (accumulate-n ⟨??⟩ ⟨??⟩ mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map ⟨??⟩ m)))
```
])

#answer([
  ```lisp
(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-vector m v)
  (map (lambda (x) (dot-product x v)) m))

(define (transpose mat)
  (accumulate-n cons null mat))

(define (matrix-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (row) (matrix-vector cols row)) m)))

(define m1 (list (list 1 2) (list 3 4)))
(define m2 (list (list 2 0) (list 1 2)))
(matrix-matrix m1 m2)
; '((4 4) (10 8))
  ```
])

#prob([
The `accumulate` procedure
is also known as `fold-right`, because it combines the first element of
the sequence with the result of combining all the elements to the right.  There
is also a `fold-left`, which is similar to `fold-right`, except that
it combines elements working in the opposite direction:

```lisp
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))
```

What are the values of

```lisp
(fold-right / 1 (list 1 2 3))
(fold-left  / 1 (list 1 2 3))
(fold-right list nil (list 1 2 3))
(fold-left  list nil (list 1 2 3))
```

Give a property that `op` should satisfy to guarantee that
`fold-right` and `fold-left` will produce the same values for any
sequence.
])

#answer([
  ```lisp
(fold-right / 1 (list 1 2 3))
(fold-left  / 1 (list 1 2 3))
(fold-right list nil (list 1 2 3))
(fold-left  list nil (list 1 2 3))
; 3/2
; 1/6
; '(1 (2 (3 ())))
; '(((() 1) 2) 3)
  ```
  ```lisp
(fold-right (lambda (y x) 
              (display x)
              (display " dividing ")
              (display y)
              (display " -> ")
              (/ y x)) 1 (list 1 2 3))
(fold-left (lambda (y x)
             (display x)
             (display " dividing ")
             (display y)
             (display " -> ")
             (/ y x)) 1 (list 1 2 3))
; 1 dividing 3 -> 3 dividing 2 -> 2/3 dividing 1 -> 3/2
; 1 dividing 1 -> 2 dividing 1 -> 3 dividing 1/2 -> 1/6
  ```
  we want it such that the _order_ of op does not matter on the result
  i.e\
  like in addition $(a+b)+c = a+(b+c)$\
  or multiplication $(a*b)*c = a*(b*c)$
  so we want it such that
  `(op (op a b) c) == (op a (op b c))`
])

#prob([
Complete the following
definitions of `reverse` (Exercise 2.18) in terms of
`fold-right` and `fold-left` from Exercise 2.38:

```lisp
(define (reverse sequence)
  (fold-right 
   (lambda (x y) ⟨??⟩) nil sequence))

(define (reverse sequence)
  (fold-left 
   (lambda (x y) ⟨??⟩) nil sequence))
```
])

#answer([
  ```lisp
(define (reverse-test sequence)
  (accumulate
   (lambda (x y) (append  y (list x))) null sequence))

(define (reverse2-test sequence)
  (fold-left
   (lambda (x y) (append (list y) x)) null sequence))

(reverse-test (list 1 2 3 4))
(reverse2-test (list 1 2 3 4))
; '(4 3 2 1)
; '(4 3 2 1)
  ```
])

#prob([
Define a procedure
`unique-pairs` that, given an integer $n$, generates the sequence of
pairs $(i, j)$ with $(1 < j < (i < n))$.  Use `unique-pairs`
to simplify the definition of `prime-sum-pairs` given above.
])

#answer([
  ```lisp
(define (unique-pairs n)
  (flatmap (lambda (i)
             (map (lambda (j) (list i j))
                  (enumerate-interval 1 (- i 1))))
           (enumerate-interval 1 n)))

(unique-pairs 4)
; '((2 1) (3 1) (3 2) (4 1) (4 2) (4 3))

(define (prime-sum-pairs n)
  (define (make-pair-sum pair)
    (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))
  (define (prime-sum? pair)
    (prime? (+ (car pair) (cadr pair))))
  (map make-pair-sum
       (filter prime-sum?
               (unique-pairs n))))

(prime-sum-pairs 5)
; '((2 1 3) (3 2 5) (4 1 5) (4 3 7) (5 2 7))
  ```
])

#prob([
Write a procedure to find all
ordered triples of distinct positive integers $i$, $j$, and $k$ less than
or equal to a given integer $n$ that sum to a given integer $s$.
])

#answer([
HOLY SHIT this one took a long while
(first time discovering leetcode three-sum)
  ```lisp
(define (unique-triplet n)
  (flatmap (lambda (i)
             (map (lambda (j)
                    (cons j i))
                  (enumerate-interval (+ 1 (car i)) n)))
           (unique-pairs n)))

(define (three-sum n s)
  (define (condition? t)
    (eq? s
         (+ (car t)
            (cadr t)
            (caddr t))))
  (filter condition? (unique-triplet n)))

(three-sum 10 15)
; '((10 3 2) (10 4 1) (9 4 2) (8 4 3) (9 5 1) (8 5 2) (7 5 3) (6 5 4) (8 6 1) (7 6 2))
  ```
])

#prob([
  The “eight queens puzzle” asks how to place eight queens on a
  chessboard so that no queeds is in check from any other
  (i.e., no two queems are in the same row, column,
  or diagonal). One possible solution is shown below.
  #align(center, [
    #board(
      square-size: 20pt,
      white-square-fill: rgb("#ffffff"),
      black-square-fill: rgb("#cdcdcd"),
      stroke: rgb("#cdcdcd"),
      position(
        ".....q..",
        "..q.....",
        "q.......",
        "......q.",
        "....q...",
        ".......q",
        ".q......",
        "...q....",
      ))
  ])
  One way to solve the puzzle is
  to work across the board, placing a queen in each column.  Once we have placed
  $k - 1$ queens, we must place the $k^(t h)$ queen in a position where it does
  not check any of the queens already on the board.  We can formulate this
  approach recursively: Assume that we have already generated the sequence of all
  possible ways to place $k - 1$ queens in the first $k - 1$ columns of the
  board.  For each of these ways, generate an extended set of positions by
  placing a queen in each row of the $k^(t h)$ column.  Now filter these, keeping
  only the positions for which the queen in the $k^(t h)$ column is safe with
  respect to the other queens.  This produces the sequence of all ways to place
  $k$ queens in the first $k$ columns.  By continuing this process, we will
  produce not only one solution, but all solutions to the puzzle.

  We implement this solution as a procedure `queens`, which returns a
  sequence of all solutions to the problem of placing $n$ queens on an
  $n times n$ chessboard.  `Queens` has an internal procedure
  `queen-cols` that returns the sequence of all ways to place queens in the
  first $k$ columns of the board.

  ```lisp
(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
          (lambda (positions) 
            (safe? k positions))
          (flatmap
            (lambda (rest-of-queens)
              (map (lambda (new-row)
                     (adjoin-position 
                       new-row 
                       k 
                       rest-of-queens))
                   (enumerate-interval 
                     1 
                     board-size)))
            (queen-cols (- k 1))))))
  (queen-cols board-size))
  ```

  In this procedure `rest-of-queens` is a way to place $k - 1$ queens in
  the first $k - 1$ columns, and `new-row` is a proposed row in which to
  place the queen for the $k^(t h)$ column.  Complete the program by implementing
  the representation for sets of board positions, including the procedure
  `adjoin-position`, which adjoins a new row-column position to a set of
  positions, and `empty-board`, which represents an empty set of positions.
  You must also write the procedure `safe?`, which determines for a set of
  positions, whether the queen in the $k^(t h)$ column is safe with respect to the
  others.  (Note that we need only check whether the new queen is safe---the
  other queens are already guaranteed safe with respect to each other.)
])

#answer([

])

#prob([
Louis Reasoner is having a
terrible time doing Exercise 2.42.  His `queens` procedure seems to
work, but it runs extremely slowly.  (Louis never does manage to wait long
enough for it to solve even the $6 times 6$ case.)  When Louis asks Eva Lu Ator for
help, she points out that he has interchanged the order of the nested mappings
in the `flatmap`, writing it as

```lisp
(flatmap
 (lambda (new-row)
   (map (lambda (rest-of-queens)
          (adjoin-position 
           new-row k rest-of-queens))
        (queen-cols (- k 1))))
 (enumerate-interval 1 board-size))
```

Explain why this interchange makes the program run slowly.  Estimate how long
it will take Louis's program to solve the eight-queens puzzle, assuming that
the program in Exercise 2.42 solves the puzzle in time $T$.
])

#answer([
  FUCK
])

#prob([
Define the procedure
`up-split` used by `corner-split`.  It is similar to
`right-split`, except that it switches the roles of `below` and
`beside`.
])

#answer([
])

#prob([
`Right-split` and
`up-split` can be expressed as instances of a general splitting operation.
Define a procedure `split` with the property that evaluating

```lisp
(define right-split (split beside below))
(define up-split (split below beside))
```

produces procedures `right-split` and `up-split` with the same
behaviors as the ones already defined.
])

#answer([
])

#prob([
A two-dimensional vector $v$
running from the origin to a point can be represented as a pair consisting of
an $x$-coordinate and a $y$-coordinate.  Implement a data abstraction for
vectors by giving a constructor `make-vect` and corresponding selectors
`xcor-vect` and `ycor-vect`.  In terms of your selectors and
constructor, implement procedures `add-vect`, `sub-vect`, and
`scale-vect` that perform the operations vector addition, vector
subtraction, and multiplying a vector by a scalar:

$
(x_1, y_1) + (x_2, y_2)  =  (x_1 + x_2, y_1 + y_2) \
(x_1, y_1) - (x_2, y_2)  =  (x_1 - x_2, y_1 - y_2) \
s dot (x, y) =  (s x, s y)
$
])

#answer([
])

#prob([
Here are two possible
constructors for frames:

```lisp
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
```

For each constructor supply the appropriate selectors to produce an
implementation for frames.
])

#answer([
])

#prob([
A directed line segment in the
plane can be represented as a pair of vectors---the vector running from the
origin to the start-point of the segment, and the vector running from the
origin to the end-point of the segment.  Use your vector representation from
Exercise 2.46 to define a representation for segments with a constructor
`make-segment` and selectors `start-segment` and `end-segment`.
])

#answer([
])

#prob([
Use `segments->painter`
to define the following primitive painters:

1. The painter that draws the outline of the designated frame.

2. The painter that draws an ``X'' by connecting opposite corners of the frame.

3. The painter that draws a diamond shape by connecting the midpoints of the sides
of the frame.

4. The `wave` painter.
])

#answer([
])

#prob([
Define the transformation
`flip-horiz`, which flips painters horizontally, and transformations that
rotate painters counterclockwise by 180 degrees and 270 degrees.
])

#answer([
])

#prob([
Define the `below` operation
for painters.  `Below` takes two painters as arguments.  The resulting
painter, given a frame, draws with the first painter in the bottom of the frame
and with the second painter in the top.  Define `below` in two different
ways---first by writing a procedure that is analogous to the `beside`
procedure given above, and again in terms of `beside` and suitable
rotation operations (from Exercise 2.50).
])

#answer([
])

#prob([
Make changes to the square limit
of `wave` shown in Figure 2.9 by working at each of the levels
described above.  In particular:

1. Add some segments to the primitive `wave` painter of Exercise 2.49
(to add a smile, for example).

2. Change the pattern constructed by `corner-split` (for example, by using
only one copy of the `up-split` and `right-split` images instead of
two).

3. Modify the version of `square-limit` that uses `square-of-four` so as
to assemble the corners in a different pattern.  (For example, you might make
the big Mr. Rogers look outward from each corner of the square.)
])

#answer([
])

#prob([
What would the interpreter print
in response to evaluating each of the following expressions?

```lisp
(list 'a 'b 'c)
(list (list 'george))
(cdr '((x1 x2) (y1 y2)))
(cadr '((x1 x2) (y1 y2)))
(pair? (car '(a short list)))
(memq 'red '((red shoes) (blue socks)))
(memq 'red '(red shoes blue socks))
```
])
#answer([
  expected:
  ```lisp
(list 'a 'b 'c)
;; '(a b c)
(list (list 'george))
;; '((george))
(cdr '((x1 x2) (y1 y2)))
;; '((y1 y2))
(cadr '((x1 x2) (y1 y2)))
;; '(y1 y2)
(pair? (car '(a short list)))
;; false
(memq 'red '((red shoes) (blue socks)))
;; false
(memq 'red '(red shoes blue socks))
;; '(red shoes blue socks)
  ```

  .....it is correct :>
])

#prob([
Two lists are said to be
`equal?` if they contain equal elements arranged in the same order.  For
example,

```lisp
(equal? '(this is a list) 
        '(this is a list))
```


is true, but

```lisp
(equal? '(this is a list) 
        '(this (is a) list))
```


is false.  To be more precise, we can define `equal?`  recursively in
terms of the basic `eq?` equality of symbols by saying that `a` and
`b` are `equal?` if they are both symbols and the symbols are
`eq?`, or if they are both lists such that `(car a)` is `equal?`
to `(car b)` and `(cdr a)` is `equal?` to `(cdr b)`.  Using
this idea, implement `equal?` as a procedure.
])

#answer([
  initially i did `(eq? (car a) (car b))` but then i remembered that
  `(my-equal? '(this (is a) list) '(this (is a) list)) ` exists
  ```lisp
(define (my-equal? a b)
  (cond ((and (null? a) (null? b)) true)
        ((or (null? a) (null? b)) false)
        ((and (not (pair? a)) 
              (not (pair? b)))
         (eq? a b))
        ((or (not (pair? a))
             (not (pair? b)))
         false)
        (else (and (my-equal? (car a) (car b))
                   (my-equal? (cdr a) (cdr b))))))
  ```
])

#prob([

Eva Lu Ator types to the interpreter the expression

```lisp
(car ''abracadabra)
```

To her surprise, the interpreter prints back `quote`.  Explain.
])

#answer([
  .......my interpreter printed
  `'quote`...........well L bozo get rekt :P.

  anyways this is actually doing
  ```lisp
  (car (quote (quote abracadabra)))
  ```
  and then evaluating the first quote gives
  ```lisp
  (car (list quote abracadabra))
  ```
  and the car of the list is quote so obviously
])

#prob([
Show how to extend the basic
differentiator to handle more kinds of expressions.  For instance, implement
the differentiation rule

  $
  d(u^n)/(d x) = n u^(n-1) (d u)/(d x)
  $

by adding a new clause to the `deriv` program and defining appropriate
procedures `exponentiation?`, `base`, `exponent`, and
`make-exponentiation`.  (You may use the symbol `**` to denote
exponentiation.)  Build in the rules that anything raised to the power 0 is 1
and anything raised to the power 1 is the thing itself.
])

#answer([
racket has `(expt power base)` for exponentiation so i'll be using that\
nvm i am stupid, i don't even need to exponentiate
  ```lisp

(define (make-exponentiation base pow)
  (cond ((eq? pow 1) base)
        ((eq? pow 0) 1)
        ((eq? base 1) 1)
        (else (list '** base pow))))

(define (exponentiation? x)
  (and (pair? x)
       (eq? (car x) '**)))
(define (base e) (cadr e))
(define (exponent e) (caddr e))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1
             0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        ((exponentiation? exp) ;; exponentiation rule
         (make-product (deriv (base exp) var)
                       (make-product (exponent exp)
                                     (make-exponentiation (base exp)
                                                          (- (exponent exp)
                                                             1)))))
        (else
          (error "unknown expression type: DERIV" exp))))

(deriv (make-exponentiation 'x 7) 'x)
; '(* 7 (** x 6))
  ```
])

#prob([
Extend the differentiation
program to handle sums and products of arbitrary numbers of (two or more)
terms.  Then the last example above could be expressed as

```lisp
(deriv '(* x y (+ x 3)) 'x)
```

Try to do this by changing only the representation for sums and products,
without changing the `deriv` procedure at all.  For example, the
`addend` of a sum would be the first term, and the `augend` would be
the sum of the rest of the terms.
])

#answer([
```lisp
(define (augend s)
  (if (null? (cdddr s))
      (caddr s)
      (cons '+ (cddr s))))

(define (multiplicand p)
  (if (null? (cdddr p))
      (caddr p)
      (cons '* (cddr p))))
  ```
  i did not come up with this solution i saw it on
  #underline([
    #link("https://www.inchmeal.io/sicp/ch-2/ex-2.57.html")[here]
  ])

  i was going for something like
  ```lisp
(define (multiplicand p)
  (accumulate * 1 (cddr p)))

(define (augend s)
  (accumulate + 0 (cddr s)))
  ```
  which just.......doesn't work because then it would need to accumulate
  nested expressions which don't work with accumulate
  (maybe something with flatmap......)
])

#prob([
Suppose we want to modify the
differentiation program so that it works with ordinary mathematical notation,
in which `+` and `*` are infix rather than prefix operators.  Since
the differentiation program is defined in terms of abstract data, we can modify
it to work with different representations of expressions solely by changing the
predicates, selectors, and constructors that define the representation of the
algebraic expressions on which the differentiator is to operate.

1. Show how to do this in order to differentiate algebraic expressions presented
in infix form, such as `(x + (3 * (x + (y + 2))))`.  To simplify the task,
assume that `+` and `*` always take two arguments and that
expressions are fully parenthesized.

2. The problem becomes substantially harder if we allow standard algebraic
notation, such as `(x + 3 * (x + y + 2))`, which drops unnecessary
parentheses and assumes that multiplication is done before addition.  Can you
design appropriate predicates, selectors, and constructors for this notation
such that our derivative program still works?
])

#answer([
  1.
  ```lisp
(define (product? x)
  (and (pair? x)
       (eq? (cadr x) '*)))
(define (multiplier p) (car p))
(define (multiplicand p) (cddr p)) ;

(define (sum? x)
  (and (pair? x)
       (eq? (cadr x) '+))) ;2nd element of list
(define (addend s) (car s)) ;1st element of list
(define (augend s) (cddr s)) ;rest of all elements

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2))
         (+ a1 a2))
        (else (list a1 '+ a2)))) ;changed to match notation
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2))
         (* m1 m2))
        (else (list m1 '* m2)))) ;changed to match notation
  ```

  2. NO I CAN'T DESIGN IT! FUCK YOU!..........this goes in TODO _sigh_
])

#prob([
Implement the `union-set`
operation for the unordered-list representation of sets.
])

#answer([
```lisp
(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        ((not (element-of-set? (car set1) set2))
         (cons (car set1) (union-set (cdr set1) set2)))
        (else (union-set (cdr set1) set2))))

(union-set '(a b (1 2) x) '(c d (1 2) b))
;; '(a x c d (1 2) b)
  ```
])

#prob([
We specified that a set would be
represented as a list with no duplicates.  Now suppose we allow duplicates.
For instance, the set $(1, 2, 3)$ could be represented as the list `(2 3 2 1
3 2 2)`.  Design procedures `element-of-set?`, `adjoin-set`,
`union-set`, and `intersection-set` that operate on this
representation.  How does the efficiency of each compare with the corresponding
procedure for the non-duplicate representation?  Are there applications for
which you would use this representation in preference to the non-duplicate one?
])

#answer([
  ```lisp
; no change it is just THETA(n)
(define (element-of-set-dup x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

; no check needed so THETA(1)
(define (adjoin-set-dup x set)
  (cons x set))

; remains unchanged and going over the set for
; element checking each time then going to the next element
; so complexity is THETA(n^2)
(define (intersection-set-dup set1 set2)
  (cond ((or (null? set1)
             (null? set2))
         null)
        ((element-of-set? (car set1) set2)
         (cons (car set1)
               (intersection-set-dup (cdr set1) set2)))
        (else (intersection-set-dup (cdr set1) set2))))

; literally append which is THETA(n)
(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else (cons (car set1)
                    (union-set (cdr set1) set2)))))
  ```
])

#prob([
Give an implementation of
`adjoin-set` using the ordered representation.  By analogy with
`element-of-set?` show how to take advantage of the ordering to produce a
procedure that requires on the average about half as many steps as with the
unordered representation.
])

#answer([
  ```lisp
(define (adjoin-set-order x set2)
  (if (element-of-set-order? x set2)
      set2
      (cons x set2)))
  ```
])

#prob([
Give a $Theta(n)$
implementation of `union-set` for sets represented as ordered lists.
])

#answer([
  ```lisp
(define (union-set-order set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else (let ((x (car set1))
                    (y (car set2)))
                (cond ((= x y)
                       (cons x (union-set-order (cdr set1)
                                                (cdr set2))))
                      ((< x y)
                       (cons x (union-set-order (cdr set1)
                                                set2)))
                      ((> x y)
                       (cons y (union-set-order set1
                                                (cdr set2)))))))))


(union-set-order (list 0 4 8 12) (list -4 -3 0 1 4))
; '(-4 -3 0 1 4 8 12)
  ```
])

#prob([
Each of the following two
procedures converts a binary tree to a list.

```lisp
(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append 
       (tree->list-1 
        (left-branch tree))
       (cons (entry tree)
             (tree->list-1 
              (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list 
         (left-branch tree)
         (cons (entry tree)
               (copy-to-list 
                (right-branch tree)
                result-list)))))
  (copy-to-list tree '()))
```

1. Do the two procedures produce the same result for every tree?  If not, how do
the results differ?  What lists do the two procedures produce for the trees in
Figure 2.16?

2. Do the two procedures have the same order of growth in the number of steps
required to convert a balanced tree with $n$ elements to a list?  If not,
which one grows more slowly?
])

#answer([
  1. yes both procedures produce the same result for every tree
])
