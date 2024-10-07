(declare-datatypes () ((Vertex A B C D E F G H)))
(declare-fun Edge (Vertex Vertex) Bool)
(declare-fun Reachable (Vertex Vertex) Bool)
(declare-fun Isolated (Vertex) Bool)

; 1. Fully specify the graph by providing the definition of the Edge relation

(assert (forall ((x Vertex)(y Vertex)) (= (Edge x y) (or (and (= x A) (= y B))  (and (= x A) (= y C))   
(and (= x D) (= y A)) (and (= x D) (= y E)) (and (= x B) (= y C)) (and (= x C) (= y E)) (and (= x C) (= y D)) (and (= x E) (= y E)) (and (= x F) (= y C)) (and (= x F) (= y G)) (and (= x H) (= y F))
))))



; 2. Every node can reach itself
; there is no node, which can not reach itself
(echo "Every node can reach itself")
(assert (not(exists ((vetrex Vertex)) (not(Reachable vetrex vetrex)))))
(check-sat)


; 3. If there is an edge from x to y and y can reach z then x can reach z
(echo "If there is an edge from x to y and y can reach z then x can reach z")
(assert (forall ((vetrex1 Vertex) (vetrex2 Vertex) (vetrex3 Vertex)) (=>  (and  (Reachable vetrex2 vetrex3) (Edge vetrex1 vetrex2)) (Reachable vetrex1 vetrex3))))
(check-sat)


; 4. A node is isolated if and only if there is no incoming or outgoing edge
; a node is not isolated if and only if there is icoming or outgoing edge
(echo "A node is isolated if and only if there is no incoming or outgoing edge")
(assert (forall ((vetrex1 Vertex))  (= (not(Isolated vetrex1))  (exists ((vetrex2 Vertex)) (or (Edge vetrex1 vetrex2)(Edge vetrex2 vetrex1))))))
(check-sat)

; 5. Show that vertex E is reachable from vertex A and
; that no vertex in the graph is isolated.

(echo "Is E not reachable from vertex A ?")
(assert (not(Reachable A E)))
(check-sat)
(echo "Is there a vertex in the graph is isolated ?")
(assert (not(forall ((vertex Vertex)) (not (Isolated vertex)))))
(check-sat)
(echo "Is E not reachable from vertex A and that there is vertex in the graph is isolated?")
(assert (= (and (Reachable A E) (forall ((vertex Vertex)) (not (Isolated vertex)))) false))
(check-sat)























