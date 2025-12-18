#let counter = counter("section2")
#std.counter("section2").update(1)

#show heading.where(level: 1): subprob => {
  counter.update(1)
  subprob
}

#let prob(body) = {
  context [ == Exercise #counter.step() #counter.display() ]
  block(
    breakable: false,
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
  ok for this one i am totally blank tbh
  TODO
])

#prob([
In case representing pairs as
procedures wasn't mind-boggling enough, consider that, in a language that can
manipulate procedures, we can get by without numbers (at least insofar as
nonnegative integers are concerned) by implementing 0 and the operation of
adding 1 as

```rkt
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
  TODO
])

#prob([
Alyssa's program is incomplete
because she has not specified the implementation of the interval abstraction.
Here is a definition of the interval constructor:

```rkt
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

#answer([ optional ])

#prob([
  Ben Bitdiddle, an expert systems
  programmer, looks over Alyssa's shoulder and comments that it is not clear what
  it means to divide by an interval that spans zero.  Modify Alyssa's code to
  check for this condition and to signal an error if it occurs.
])

#answer([ optional ])

#prob([
  In passing, Ben also cryptically
  comments: 'By testing the signs of the endpoints of the intervals, it is
  possible to break `mul-interval` into nine cases, only one of which
  requires more than two multiplications.'  Rewrite this procedure using Ben's
  suggestion.
])

#answer([ optional ])

#prob([
  Define a constructor
  `make-center-percent` that takes a center and a percentage tolerance and
  produces the desired interval.  You must also define a selector `percent`
  that produces the percentage tolerance for a given interval.  The `center`
  selector is the same as the one shown above.
])

#answer([ optional ])

#prob([
  Show that under the assumption of
  small percentage tolerances there is a simple formula for the approximate
  percentage tolerance of the product of two intervals in terms of the tolerances
  of the factors.  You may simplify the problem by assuming that all numbers are
  positive.
])

#answer([ optional ])

#prob([
Demonstrate that Lem is right.
Investigate the behavior of the system on a variety of arithmetic
expressions. Make some intervals $A$ and $B$, and use them in computing the
expressions $A / A$ and $A / B$.  You will get the most insight by
using intervals whose width is a small percentage of the center value. Examine
the results of the computation in center-percent form (see Exercise 2.12).
])

#answer([ optional ])

#prob([
Eva Lu Ator, another user, has
also noticed the different intervals computed by different but algebraically
equivalent expressions. She says that a formula to compute with intervals using
Alyssa's system will produce tighter error bounds if it can be written in such
a form that no variable that represents an uncertain number is repeated.  Thus,
she says, `par2` is a better program for parallel resistances than
`par1`.  Is she right?  Why?
])

#answer([ optional ])

#prob([
  Explain, in general, why
  equivalent algebraic expressions may lead to different answers.  Can you devise
  an interval-arithmetic package that does not have this shortcoming, or is this
  task impossible?  (Warning: This problem is very difficult.)
])

#answer([ optional ])

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
])

