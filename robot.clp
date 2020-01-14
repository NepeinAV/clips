(watch facts)
(watch activations)
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
    (goal (action push) (object box) (from roomB) (to roomA))
)

(defrule stop
    (goal (object ?x) (to ?y))
    (in (object ?x) (location ?y)) =>
    (halt)
)

(defrule move
    (goal (object ?x) (from ?y))
    (in (object ?x) (location ?y))
    ?robot-position <- (in (object robot) (location ?z&~?y)) 
    =>
    (modify ?robot-position (location ?y))
)

(defrule push 
    (goal (object ?x) (from ?y) (to ?z))
    (in (object ?x) (location ?y))
    ?object-position <- (in (object ?x) (location ?y))
    ?robot-position <- (in (object robot) (location ?y))
    => 
    (modify ?robot-position (location ?z))
    (modify ?object-position (location ?z))
)

(reset)
(run)
