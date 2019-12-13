(dribble-on "gun.dp")
(watch facts)
(watch instances)

(defclass pistol
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot safety (type SYMBOL) (create-accessor read-write))
    (slot slide (type SYMBOL) (create-accessor read-write))
    (slot hammer (type SYMBOL) (create-accessor read-write))
    (slot chamber (type INTEGER) (create-accessor read-write))
    (slot magazine (type SYMBOL) (create-accessor read-write))
    (slot rounds (type INTEGER) (create-accessor read-write))
)

(defmessage-handler pistol clear () 
    (dynamic-put chamber 0)
    (ppinstance)
)

(defmessage-handler pistol safety (?on-off)
    (dynamic-put safety ?on-off)
    (if (eq ?on-off on) then
        (dynamic-put hammer down)
    )
)

(defmessage-handler pistol drop ()
    (dynamic-put magazine out)
)

(defmessage-handler pistol seat ()
    (dynamic-put magazine in)
)

(defmessage-handler pistol rack ()
    (if (> (dynamic-get rounds) 0) then 
        (dynamic-put chamber 1)
        (dynamic-put rounds (- (dynamic-get rounds) 1))
        (dynamic-put slide forward)
    else
        (dynamic-put chamber 0)
        (dynamic-put slide back)
    )
)

(defmessage-handler pistol fire ()
    if (and (eq (dynamic-get chamber) 1) (eq (dynamic-get safety) off)) then
        (printout t "BANG!" crlf)
        TRUE
    else
        (printout t "click" crlf)
        FALSE
)

(definstances pistols (PPK of pistol (safety on) (slide forward) (hammer down) (chamber 0) (magazine out) (rounds 6)))

(deftemplate range-test
    (slot check (type SYMBOL) (default no))
    (slot fired (type SYMBOL) (default no))
)

(defrule start
    (initial-fact)
    =>
    (assert (range-test))
)

(defrule check
    (object (name [PPK]) (safety on) (magazine out))
    ?T <- (range-test (check no))
    =>
    (send [PPK] clear)
    (modify ?T (check yes))
)

(defrule correct1
    (object (name [PPK]) (safety off))
    (range-test (check no))
    =>
    (send [PPK] safety on)
)

(defrule correct2
    (object (name [PPK]) (safety on) (magazine in))
    (range-test (check no))
    =>
    (send [PPK] drop)
)

(defrule mag-in
    (object (name [PPK]) (safety on) (magazine out))
    (range-test (fired no) (check yes))
    =>
    (send [PPK] seat)
)

(defrule load
    (object (name [PPK]) (magazine in) (chamber 0))
    =>
    (send [PPK] rack)
)

(defrule ready
    (object (name [PPK]) (chamber 1))
    =>
    (send [PPK] safety off)
)

(defrule fire
    (object (name [PPK]) (safety off))
    ?T <- (range-test (fired no))
    =>
    (if (eq (send [PPK] fire) TRUE) then
        (modify ?T (fired yes))
    )
)

(defrule unready
    (object (name [PPK]) (safety off))
    (range-test (fired yes))
    =>
    (send [PPK] safety on)
)

(defrule stop
    (object (name [PPK]) (safety on))
    (range-test (fired yes))
    =>
    (send [PPK] drop)
)

(defrule unload
    (object (name [PPK]) (safety on) (magazine out))
    (range-test (fired yes))
    =>
    (send [PPK] clear)
)

(reset)

(run)

;; (facts)

(dribble-off)
(exit)
