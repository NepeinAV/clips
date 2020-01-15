; (watch facts)
; (watch activations)

(deftemplate goal
    (field action (type SYMBOL))
    (field object (type SYMBOL))
    (field from (type SYMBOL))
    (field to (type SYMBOL))
)

(deftemplate in
    (field object (type SYMBOL))
    (field location (type SYMBOL))
)

(deffacts world
    (in (object robot) (location roomA))
    (in (object box) (location roomB))
    (in (object boxA) (location roomC))
    (in (object boxB) (location roomC))
    (in (object boxC) (location roomD))
    (goal (action push) (object box) (from roomB) (to roomA))
    (goal (action push) (object boxA) (from roomC) (to roomB))
    (goal (action push) (object boxB) (from roomC) (to roomA))
    (goal (action push) (object boxC) (from roomD) (to roomD))
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
    (goal (object ?x) (from ?y) (to ?z))
    (in (object ?x) (location ?y&~?z))
    ?object-position <- (in (object ?x) (location ?y))
    ?robot-position <- (in (object robot) (location ?y))
    => 
    (modify ?robot-position (location ?z))
    (modify ?object-position (location ?z))
)

(defrule move
    (goal (object ?x) (from ?y))
    (in (object ?x) (location ?y))
    ?robot-position <- (in (object robot) (location ?z&~?y))
    =>
    (modify ?robot-position (location ?y))
)

; (reset)
; (run)
