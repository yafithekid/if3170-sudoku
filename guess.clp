(defrule make-guessable
	(phase guess)
	?f <- (index ?id)
	(possible (value ?v) (id ?id))
	(possible (value ~?v) (id ?id))
	
	(not (guessable ?id))
=>
	(assert (guessable ?id))
	(retract ?f)
	(assert (index (+ ?id 1)))
)

(defrule pass-guessable
	(phase guess)
	?f <- (index ?id)
	(possible (value ?v) (id ?id))
	(not (possible (value ~?v) (id ?id)))
=>
	(retract ?f)
	(assert (index (+ ?id 1)))
)

(defrule end-guessable-making
	?f1 <- (phase guess)
	?f <- (index 37)
=>
	(retract ?f1)
	(retract ?f)
	(assert (phase make-guess))
)

(defrule make-guess
	(phase make-guess)
	(guessable ?id)
	?f <- (possible (row ?r) (column ?c) (value ?v) (group ?g) (id ?id))

=>
	(assert (guess ?r ?c ?g ?v ?id))
	(retract ?f)
)

(defrule delete-guessable
	(phase make-guess)
	?f <- (guessable ?id)
	(not (possible (id ?id)))

=>
	(retract ?f)
)

(defrule end-make-guess
	?f <- (phase make-guess)
	(not (guessable ?))
=>
	(retract ?f)
	(assert (phase guessing))
	(assert (index 1))
)

(defrule select-guess-not-diagonal
	(phase guessing)
	?f1 <- (guess ?r ?c&:(not (is-diagonal ?c ?r)) ?g ?v ?id)
	(not (possible (row ?r) (value ?v)))
	(not (possible (column ?c) (value ?v)))
	(not (possible (group ?g) (value ?v)))
	(not (current-guess ?r ? ? ?v ?))
	(not (current-guess ? ?c ? ?v ?))
	(not (current-guess ? ? ?g ?v ?))
	(not (current-guess ? ? ? ? ?id))
	?f <- (index ?id)
=>
	(retract ?f)
	(retract ?f1)
	(assert (index (+ ?id 1)))
	(assert (current-guess ?r ?c ?g ?v ?id))
)

(defrule select-guess-diagonal
	(phase guessing)
	?f1 <- (guess ?r ?c&:(is-diagonal ?c ?r) ?g ?v ?id)
	(not (possible (row ?r) (value ?v)))
	(not (possible (column ?c) (value ?v)))
	(not (possible (group ?g) (value ?v)))
	(not (current-guess ?r ? ? ?v ?))
	(not (current-guess ? ?c ? ?v ?))
	(not (current-guess ? ? ?g ?v ?))
	(not (current-guess ? ? ? ? ?id))
	(not (possible (row ?r1) (column ?c1&:(is-same-diagonal ?c ?r ?c1 ?r1)) (value ?v)))
	(not (current-guess ?r2 ?c2&:(is-same-diagonal ?c ?r ?c2 ?r2) ? ?v ?))
	?f <- (index ?id)
=>
	(retract ?f)
	(retract ?f1)
	(assert (index (+ ?id 1)))
	(assert (current-guess ?r ?c ?g ?v ?id))
)

(defrule dismiss-guess-row-current-guess
	(phase guessing)
	?f <- (guess ?r ?c ?g ?v ?id)
	(current-guess ?r ? ? ?v ~?id)
	(index ?id)
=>
	(retract ?f)
	(assert (dismiss-guess ?r ?c ?g ?v ?id))
)

(defrule dismiss-guess-column-current-guess
	(phase guessing)
	?f <- (guess ?r ?c ?g ?v ?id)
	(current-guess ? ?c ? ?v ~?id)
	(index ?id)
=>
	(retract ?f)
	(assert (dismiss-guess ?r ?c ?g ?v ?id))
)

(defrule dismiss-guess-group-current-guess
	(phase guessing)
	?f <- (guess ?r ?c ?g ?v ?id)
	(current-guess ? ? ?g ?v ~?id)
	(index ?id)
=>
	(retract ?f)
	(assert (dismiss-guess ?r ?c ?g ?v ?id))
)

(defrule dismiss-guess-diagonal-current-guess
	(phase guessing)
	?f <- (guess ?r ?c ?g ?v ?id)
	(current-guess ?r1 ?c1&:(is-same-diagonal ?c ?r ?c1 ?r1) ?g1 ?v ~?id)
	(index ?id)
=>
	(retract ?f)
	(assert (dismiss-guess ?r ?c ?g ?v ?id))
)

(defrule dismiss-guess-column-possible
	(phase guessing)
	?f <- (guess ?r ?c ?g ?v ?id)
	(possible (column ?c) (value ?v))
	(index ?id)
=>
	(retract ?f)
	(assert (dismiss-guess ?r ?c ?g ?v ?id))
)

(defrule dismiss-guess-group-possible
	(phase guessing)
	?f <- (guess ?r ?c ?g ?v ?id)
	(possible (group ?g) (value ?v))
	(index ?id)
=>
	(retract ?f)
	(assert (dismiss-guess ?r ?c ?g ?v ?id))
)

(defrule dismiss-guess-diagonal-possible
	(phase guessing)
	?f <- (guess ?r ?c ?g ?v ?id)
	(possible (row ?r2)(column ?c2&:(is-same-diagonal ?c ?r ?c2 ?r2)) (value ?v))
	(index ?id)
=>
	(retract ?f)
	(assert (dismiss-guess ?r ?c ?g ?v ?id))
)

(defrule dismiss-guess-row-possible
	(phase guessing)
	?f <- (guess ?r ?c ?g ?v ?id)
	(possible (row ?r) (value ?v))
	(index ?id)
=>
	(retract ?f)
	(assert (dismiss-guess ?r ?c ?g ?v ?id))
)

(defrule pass-truth
	(phase guessing)
	?f <- (index ?id)
	(possible (id ?id))
=>
	(retract ?f)
	(assert (index (+ ?id 1)))
)

(defrule need-to-backtrack
	(phase guessing)
	?f <- (index ?id)
	(dismiss-guess ? ? ? ? ?id)
	(not (guess ? ? ? ? ?id))
=>
	(retract ?f)
	(assert (rebuild ?id))
)

(defrule rebuild-guess
	(phase guessing)
	(rebuild ?id)
	?f <- (dismiss-guess ?r ?c ?g ?v ?id)
=>
	(retract ?f)
	(assert (guess ?r ?c ?g ?v ?id))
)

(defrule finish-rebuild
	(phase guessing)
	?f <- (rebuild ?id)
	(not (dismiss-guess ?r ?c ?g ?v ?id))
=>
	(retract ?f)
	(assert (backtrack (- ?id 1)))
)

(defrule pass-backtrack-possible
	(phase guessing)
	?f <- (backtrack ?id)
	(possible (id ?id))
=>
	(retract ?f)
	(assert (backtrack (- ?id 1)))
)

(defrule finish-backtrack
	(phase guessing)
	?f <- (backtrack ?id)
	?f1 <- (current-guess ?r ?c ?g ?v ?id)
=>
	(retract ?f)
	(assert (index ?id))
	(retract ?f1)
	(assert (dismiss-guess ?r ?c ?g ?v ?id))
)

(defrule impossible-to-solve-backtrack
	?f1 <- (phase guessing)
	?f <- (backtrack 0)
=>
	(retract ?f1)
	(retract ?f)
	(assert (phase revert-because-impossible-backtrack))
)

(defrule revert-because-impossible-backtrack
	(phase revert-because-impossible-backtrack)
	?f <- (guess ?r ?c ?g ?v ?id)
=>
	(assert (possible (row ?r) (column ?c) (group ?g) (value ?v) (id ?id)))
	(retract ?f)
)

(defrule end-revert-because-impossible-backtrack
	?f <- (phase revert-because-impossible-backtrack)
	(not (guess ?r ?c ?g ?v ?id))
=>
	(retract ?f)
   
   (assert (phase final-output))
   (assert (print-position 1 1)))

(defrule end-guessing
	?f <- (index 37)
	?f1 <- (phase guessing)
=>
	(retract ?f)
	(retract ?f1)
	(assert (phase transform-current-guess))
)

(defrule transform
	(phase transform-current-guess)
	?f <- (current-guess ?r ?c ?g ?v ?id)
=>
	(assert (possible (row ?r) (column ?c) (group ?g) (value ?v) (id ?id)))
	(retract ?f)
)

(defrule end-transform
	?f <- (phase transform-current-guess)
	(not (current-guess ?r ?c ?g ?v ?id))
=>
	(retract ?f)
   
   (assert (phase final-output))
   (assert (print-position 1 1)))