;;; Version 1.2
;;; 
;;; JRules Changes

;;; Reference Material
;;;
;;; http://www.angusj.com/sudoku/hints
;;; http://www.scanraid.com/BasicStrategies.htm
;;; http://www.sudokuoftheday.com/pages/techniques-overview
;;; http://www.sudokuonline.us/sudoku_solving_techniques
;;; http://www.sadmansoftware.com/sudoku/techniques.htm
;;; http://www.krazydad.com/blog/2005/09/29/an-index-of-sudoku-strategies/

;;; #######################
;;; DEFTEMPLATES & DEFFACTS
;;; #######################

(deftemplate possible
   (slot row)
   (slot column)
   (slot value)
   (slot group)
   (slot id))
   

;;; ###########
;;; SETUP RULES
;;; ###########
(deffunction is-diagonal
	(?c ?r)
	(or (= ?c ?r) (= (+ ?c ?r) 7))
)

(deffunction is-same-diagonal
	(?c ?r ?c1 ?r1)
	(or (and (= ?c ?r) (= ?r1 ?c1))
			 (and (= (+ ?c ?r) 7) (= (+ ?c1 ?r1) 7))
	)
)
;;; **********
;;; initialize
;;; **********

(defrule initialize

   =>

   (assert (phase grid-values))
)

;;; ****************
;;; expand-any-start
;;; ****************

(defrule guess-any

   (phase expand-any)
   
   ?f <- (possible (row ?r) (column ?c) (value any) (group ?g) (id ?id))
        
   =>
      
   (retract ?f)
   (assert (possible (row ?r) (column ?c) (value 1) (group ?g) (id ?id)))
	(assert (possible (row ?r) (column ?c) (value 2) (group ?g) (id ?id)))
	(assert (possible (row ?r) (column ?c) (value 3) (group ?g) (id ?id)))
	(assert (possible (row ?r) (column ?c) (value 4) (group ?g) (id ?id)))
	(assert (possible (row ?r) (column ?c) (value 5) (group ?g) (id ?id)))
	(assert (possible (row ?r) (column ?c) (value 6) (group ?g) (id ?id))))
   
;;; ###########
;;; PHASE RULES
;;; ###########

;;; ***************
;;; expand-any-done
;;; ***************

(defrule expand-any-done

   (declare (salience 10))

   ?f <- (phase expand-any)

   (not (possible (value any)))
   
   =>
   
   (retract ?f)
   
   (assert (phase guess))
   (assert (index 1)))
   