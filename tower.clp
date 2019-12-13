(dribble-on "tower.dp")

(watch facts)

(set-strategy mea)

(deftemplate block
    (slot color (type SYMBOL))
    (slot size (type INTEGER))
    (slot place (type SYMBOL) (default heap))
)

(deftemplate on
    (slot upper (type SYMBOL))
    (slot lower (type SYMBOL))
    (slot place (type SYMBOL))
)

(deftemplate goal
    (field task (type SYMBOL))
)

(deffacts the-facts
    (block (color red) (size 10))
    (block (color yellow) (size 20))
    (block (color blue) (size 30))
)

(defrule begin
    (initial-fact)
    =>
    (assert (goal (task find)))
)

(defrule pick-up
    ?my-goal <- (goal (task find))
    ?my-block <- (block (size ?S1) (place heap))
    (not (block (color ?C2) (size ?S2&:(> ?S2 ?S1)) (place heap)))
    =>
    (modify ?my-block (place hand))
    (modify ?my-goal (task build))
)

(defrule place-first
    ?my-goal <- (goal (task build))
    ?my-block <- (block (place hand))
    (not (block (place tower)))
    =>
    (modify ?my-block (place tower))
    (modify ?my-goal (task find))
)

(defrule put-down
    ?my-goal <- (goal (task build))
    ?my-block <- (block (color ?C0) (place hand))
    (block (color ?C1) (place tower))
    (not (on (upper ?C2) (lower ?C1) (place tower)))
    =>
    (modify ?my-block (place tower))
    (assert (on (upper ?C0) (lower ?C1) (place tower)))
    (modify ?my-goal (task find))
)

(defrule stop
    ?my-goal <- (goal (task find))
    (not (block (place heap)))
    =>
    (retract ?my-goal)
)

(reset)

(run)
(facts)

(dribble-off)
(exit)
