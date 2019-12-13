;; (dribble-on "dribble.dp")
(watch facts)

;; (assert (today is Sunday))
;; (assert (weather is warm))
;; (facts)

;; (retract 1)
;; (facts)

;; (clear)
;; (facts)

(deffacts today 
    (today is Sunday)
    (weather is warm)    
)
(reset)

;(undeffacts today)
;(reset)

(defrule chores
    "Things to do on Sunday"
    (declare (salience 10))
    (today is Sunday)
    (weather is warm) 
    =>
    (assert (chore is carwash))
    (assert (chop wood))
)

;; (reset)
;; (run)
;; (facts)

(defrule fun
    "Better things to do on Sunday"
    (declare (salience 100))
    (today is Sunday)
    (weather is warm) 
    =>
    (assert (drink beer))
    (assert (play guitar))
)

(defrule pick-a-chore
    "Alocating chores to days"
    (today is ?day)
    (chore is ?job)
    =>
    (assert (do ?job on ?day))
)

(defrule drop-a-chore
    "Allocating chores to days"
    (today is ?day)
    ?chore <- (do ?job on ?day)
    =>
    (retract ?chore)
)

(defrule start
    (initial-fact)
    =>
    (printout t "hello, world" crlf)
)

(reset)

(run)

(deftemplate student "a student record"
    (slot name (type STRING))
    (slot age (type NUMBER) (default 18))
)

(deffacts students
    (student (name "Fred"))
    (student (name "Freda") (age 19))
)

(reset)

(deffunction hypotenuse (?a ?b)
    (printout t "sqrt: " (sqrt (+ (* ?a ?a) (* ?b ?b))) crlf)
)

(hypotenuse 2 4)

(deffunction init (?day)
    (reset)
    (assert (today is ?day))
)

(init "Вторник")

;; (dribble-off)
(exit)
