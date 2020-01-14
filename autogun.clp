;; (watch all)
(watch facts)
(watch instances)
(watch activations)

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
    ;; (ppinstance)
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
        (return TRUE)
    else
        (dynamic-put slide back)
        (return FALSE)
    )
)

(defmessage-handler pistol fire ()
    (printout t "BANG!" crlf)
    (send [PPK] clear)
)

(definstances pistols (PPK of pistol (safety on) (slide forward) (hammer down) (chamber 0) (magazine out) (rounds 5)))

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
    ?T <- (range-test (fired no))
    (object (name [PPK]) (magazine in) (chamber 0))
    =>
    (if (eq (send [PPK] rack) FALSE) then
        (printout t "click" crlf)
        (modify ?T (fired yes))
    )
)

(defrule ready
    (range-test (fired no))
    (object (name [PPK]) (chamber 1) (safety on))
    =>
    (send [PPK] safety off)
)

(defrule fire
    (object (name [PPK]) (safety off) (chamber 1))
    ?T <- (range-test (fired no))
    =>
    (send [PPK] fire)
)

(defrule unready
    (range-test (fired yes))
    (object (name [PPK]) (safety off))
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

(exit)
