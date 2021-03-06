let rec min_list inf l = match l with [] -> failwith "liste vide" |[x] -> x
                                      |x::y::[] -> if inf x y then x else y
                                      |x::y::r -> if inf x y then min_list inf (x::r) else min_list inf (y::r);;

let rec supprime x l = match l with [] -> l
                                    | [n] -> if n=x then [] else []
                                    |n::r -> if n=x then r else n::(supprime x r);;

let rec tri_selection_min inf l = match l with  [] -> []
                                                | [x] -> [x]
                                                |x::r -> (min_list inf l)::(tri_selection_min inf (supprime (min_list inf l) l));;

let rec partitionne_bis l i j  = match l with [] -> (i, j)
                                          |x::[] -> (i@[x], j)
                                          |x::y::r -> partitionne r (i@[x]) (j@[y]);;

let rec fusionne_bis inf l1 l2 l = match (l1,l2) with ([],_) -> l @ l2
                                                  | (_,[]) -> l @ l1
                                                  | (x1::r1,x2::r2) -> if inf x1 x2 then fusionne_bis inf r1 l2 (l@[x1]) else fusionne_bis inf l1 r2 (l@[x2]);;

let partitionne l = partitionne_bis l [] [];;

let fusionne l1 l2 = fusionne_bis l1 l2 [];;

let tri inf l = let (l1,l2) = partitionne l in (fusionne inf ( tri_selection_min inf l1 ) ( tri_selection_min inf l2));;

let rec suppr_doublons l = match l with [] -> l
                                        | [x] -> [x]
                                        |x::y::r -> if x = y then suppr_doublons (y::r) else x::( suppr_doublons (y::r));;

let rec separe_inf_eq_sup_bis comp  x l i m f  = match l with
    [] ->(i, m, f)
    |n::r ->  if comp n x then  separe_inf_eq_sup_bis comp x r (n::i) m f
              else if n=x then  separe_inf_eq_sup_bis comp x r i (n::m) f
                          else  separe_inf_eq_sup_bis comp x r i m (n::f);;

let  separe_inf_eq_sup comp x l =  separe_inf_eq_sup_bis comp x l [] [] [];;

let rec tri_pivot_bis infeq (i, m, f) = match (i,f) with
        ([], []) -> m
        | (ti::qi,tf::qf ) -> (tri_pivot_bis infeq (separe_inf_eq_sup infeq ti i))@m@(tri_pivot_bis infeq (separe_inf_eq_sup infeq tf f))
        | (ti::qi,[])->  (tri_pivot_bis infeq (separe_inf_eq_sup infeq ti i))@m
        | ([], tf::qf) ->  m@(tri_pivot_bis infeq (separe_inf_eq_sup infeq tf f));;

let tri_pivot infeq l = match l with
        [] -> l
        |x::r ->  tri_pivot_bis infeq (separe_inf_eq_sup infeq x l);;
