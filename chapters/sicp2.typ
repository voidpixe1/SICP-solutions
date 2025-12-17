#let counter = counter("problem")

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

])

#answer([

])
