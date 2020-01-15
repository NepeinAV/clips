; (watch facts)
; (watch activations)

(deftemplate in
    (field object (type SYMBOL))
    (field location (type SYMBOL))
)

(deftemplate robot (field location (type SYMBOL)))

(deffacts world
    (robot (location roomA))
    (in (object box) (location roomB))
    (in (object boxA) (location roomC))
    (in (object boxB) (location roomC))
    (in (object boxC) (location roomD))
    ; (goal roomB)
)

(defrule stop
    (declare (salience -1))
    (forall
        (goal ?r)
        (in (object ?x) (location ?r))
    )
    =>
    (halt)
)

(defrule push
    (goal ?r)
    ?object-position <- (in (object ?x) (location ?y&~?r))
    ?robot-position <- (robot (location ?y))
    => 
    (modify ?robot-position (location ?r))
    (modify ?object-position (location ?r))
)

(defrule move
    (goal ?r)
    (in (object ?x) (location ?y&~?r))
    ?robot-position <- (robot (location ?z&~?y))
    =>
    (modify ?robot-position (location ?y))
)

(defrule check-goal
    (not (goal ?r))
    =>
    (printout t "Write the name of the goal room: ")
    (bind ?answer (read))

    (if (> (str-length ?answer) 0) then
        (assert (goal ?answer))
    else
        (while (not (> (str-length ?answer) 0)) do
            (printout t "Write the name of the goal room: ")
            (bind ?answer (read))
            (if (> (str-length ?answer) 0) then
                (assert (goal ?answer))
            )
        )
    )
)

; (reset)
; (run)
