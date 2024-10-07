(set-option :produce-models true)

; Datatypes (items, stores)
(declare-datatypes () ((Item screwdriver saw hammer chips sweets cookie water juice coke)))
(declare-datatypes () ((Store store1 store2 store3 store4)))

; Predicates indicating whether an item is a tool, snack or beverage
(declare-fun Tool (Item) Bool)
(declare-fun Snack (Item) Bool)
(declare-fun Beverage (Item) Bool)

; Predicate indicating whether a store sells an item
(declare-fun Sells (Item Store) Bool)

; Define which items are tools, snacks, beverages
(assert (forall ((x Item)) (= (Tool x) (or (= x screwdriver) (= x saw) (= x hammer)))))
(assert (forall ((x Item)) (= (Snack x) (or (= x chips) (= x sweets) (= x cookie)))))
(assert (forall ((x Item)) (= (Beverage x) (or (= x water) (= x juice) (= x coke)))))



;; constraint 1
;; Any item is either a tool, a snack, or a beverage.
(echo "Any item is either a tool, a snack, or a beverage.")
(assert (forall ((item Item)) (or (Tool item) (Snack item) (Beverage item) ) ) )
(check-sat)


;; constraint 2
;; Store 1 and 4 sell saws and Store 3 sells sweets
(echo "Store 1 and 4 sell saws and Store 3 sells sweets")

(assert (Sells sweets store3))
(assert (Sells saw store1))
(assert (Sells saw store4))

(check-sat)

;; constraint 3
;; Every item is sold by at least one store.
(echo "Every item is sold by at least one store.")

(assert (not(exists ((item Item)) (not(exists( (store Store)) (Sells item store))) )) )
(check-sat)


;; constraint 4
;; Exactly one store has all 3 types of snacks.
(echo "Exactly one store has all 3 types of snacks.")

(assert (exists ((store Store)) (forall ((store_2 Store)) (= (forall((snacks Item)) (=>(Snack snacks) (Sells snacks store_2)))(= store store_2)) ) ) ) 
(check-sat)


;; constraint 5
;; There is no store that sells both water and saws.
(echo "There is no store that sells both water and saws.")

(assert  (forall ((store Store))(not(and (Sells water store)(Sells saw store))) )  )

(check-sat)


;; constraint 6
;; Any store that sells juice also sells another beverage
(echo "Any store that sells juice also sells another beverage")

(assert (forall ((store Store)) (=>(Sells juice store) (exists ((beverage Item)) (and (Sells beverage store)(Beverage beverage) (distinct beverage juice)))) ) )
(check-sat)


;; constraint 7
;; Store 1 sells (at least) one tool, one snack and one beverage.
(echo "Store 1 sells (at least) one tool, one snack and one beverage.")


(assert (exists ((tool Item)) (and (Tool tool) (Sells tool store1))))
(assert (exists ((beverage Item)) (and (Beverage beverage) (Sells beverage store1))))
(assert (exists ((snack Item)) (and (Snack snack) (Sells snack store1))))

(check-sat)



;; constraint 8
;; Store 2 has no beverages to offer
(echo "Store 2 has no beverages to offer")

(assert (forall ((beverage Item)) (not (and (Beverage beverage)(Sells beverage store2))))) 


(check-sat)


;; constraint 9
;; Every store sells exactly 3 different items.
(echo "Every store sells exactly 3 different items.")

(assert  (not (exists ((store Store)) (not(exists  ((item1 Item)(item2 Item)(item3 Item))
(and (distinct item1 item2 item3)(Sells item1 store)(Sells item2 store)(Sells item3 store)(forall((item Item))(=>(Sells item store)(or (= item item1)(= item item2)(= item item3)))))
))
)
)
)

(check-sat)


;; constraint 10
;; Exactly 3 items are sold by 2 or more (possibly different) stores and they are one
;; tool and two snacks. All others items are sold by a single store.
(echo "Exactly 3 items are sold by 2 or more (possibly different) stores and they are one
tool and two snacks. All others items are sold by a single store.")

(assert 
(exists 
((item1 Item)(item2 Item)(item3 Item))(and (distinct item1 item2 item3)(Tool item1)(Snack item2)(Snack item3)(forall ((item Item))(=(exists((s1 Store)(s2 Store))(and(distinct s1 s2)(Sells item s1)(Sells item s2)))(or(= item item1)(= item item2)(= item item3)))))
)
)

(check-sat) ; need to be satisfiable here

(echo "Tools are sold by store1:")
(get-value ((Sells screwdriver store1) (Sells saw store1) (Sells hammer store1)))
(echo "Tools are sold by store2:")
(get-value ((Sells screwdriver store2) (Sells saw store2) (Sells hammer store2)))
(echo "Tools are sold by store3:")
(get-value ((Sells screwdriver store3) (Sells saw store3) (Sells hammer store3)))
(echo "Tools are sold by store4:")
(get-value ((Sells screwdriver store4) (Sells saw store4) (Sells hammer store4)))
(echo "")
(echo "")
(echo "Snacks are sold by store1:")
(get-value ((Sells chips store1) (Sells sweets store1) (Sells cookie store1)))
(echo "Snacks are sold by store2:")
(get-value ((Sells chips store2) (Sells sweets store2) (Sells cookie store2)))
(echo "Snacks are sold by store3:")
(get-value ((Sells chips store3) (Sells sweets store3) (Sells cookie store3)))
(echo "Snacks are sold by store4:")
(get-value ((Sells chips store4) (Sells sweets store4) (Sells cookie store4)))
(echo "")
(echo "")
(echo "Beverage are sold by store1:")
(get-value ((Sells juice store1) (Sells water store1) (Sells coke store1)))
(echo "Beverage are sold by store2:")
(get-value ((Sells juice store2) (Sells water store2) (Sells coke store2)))
(echo "Beverage are sold by store3:")
(get-value ((Sells juice store3) (Sells water store3) (Sells coke store3)))
(echo "Beverage are sold by store4:")
(get-value ((Sells juice store4) (Sells water store4) (Sells coke store4)))

(echo "")
(echo "")


;; statements (a-c) to prove
(echo "Negation of (a) Store 1 sells coke")
(assert(not(Sells coke store1)))
(check-sat)
(echo "Negation of (b) there is (at least) one snack sold by both Store 2 and 3")
(assert(not(exists((i Item))(and(Snack i)(Sells i store2)(Sells i store3)))))
(check-sat)
(echo "Negation of (c) (at least) one store sells both juice and water")
(assert(not(forall((s Store))(= (Sells juice s)(Sells water s)))))
(check-sat) ; need to be unsatisfiable here

