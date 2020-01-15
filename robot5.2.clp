; (watch facts)
; (watch activations)

(deftemplate goal
    (field object (type SYMBOL))
    (field to (type SYMBOL))
)

(deftemplate robot
    (field location (type SYMBOL))
)

(deftemplate in
    (field object (type SYMBOL))
    (field location (type SYMBOL))
)

(deffacts world
    (robot (location roomC))
    (in (object box) (location roomB))
    (in (object boxA) (location roomC))
    (in (object boxB) (location roomC))
    (in (object boxC) (location roomD))
    (goal (object box) (to roomA))
    (goal (object boxA) (to roomB))
    (goal (object boxB) (to roomA))
    (goal (object boxC) (to roomD))
)

(defrule stop
    (forall 
        (goal (object ?x) (to ?y))
        (in (object ?x) (location ?y))
    )
    =>
    (halt)
)

(defrule push
    (goal (object ?x) (to ?r))
    ?object-position <- (in (object ?x) (location ?y&~?r))
    ?robot-position <- (robot (location ?y))
    => 
    (modify ?robot-position (location ?r))
    (modify ?object-position (location ?r))
)

(defrule move
    (goal (object ?x) (to ?r))
    (in (object ?x) (location ?y&~?r))
    ?robot-position <- (robot (location ?z&~?y))
    =>
    (modify ?robot-position (location ?y))
)

; (reset)
; (run)
