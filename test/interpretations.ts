# -*- coding: utf-8 -*-

Include "rules/TS2.ts".

# derive versions of some inference rules with simple types

Definition pi1 { ⊢ T U Type } ⊢ @[∏;_][T,U] Type ::= 

   T ⟼ U ⟼ (_, T' ⟼ U' ⟼ (∏_istype T (_ ⟼ U) CDR T' (_ ⟼ _ ⟼ U'))).

Definition lambda1 { ⊢ T U Type } { t : T ⊢ o : U } ⊢ @[λ][T,o] : @[∏;_][T,U] ::=

   T ⟼ U ⟼ o ⟼ ((@[λ] T o), T' ⟼ U' ⟼ (λ_hastype T (_ ⟼ U) o CDR T' (_ ⟼ _ ⟼ U'))).

Definition ev1 { ⊢ T U Type, f : @[∏;_][T,U], o : T } ⊢ @[ev;_][f,o,T,U] : U ::=

   T ⟼ U ⟼ f ⟼ o ⟼ 
   ((ev_hastype T (_ ⟼ U) f o CAR), T' ⟼ U' ⟼ (ev_hastype T (_ ⟼ U) f o CDR T' (_ ⟼ _ ⟼ U'))).

Theorem compose { |- T U V Type } : (T->U) -> (U->V) -> (T->V) ::= 
   T ⟼ U ⟼ V ⟼ 
   ((lambda1 (pi1 T U CAR) (pi1 (pi1 U V CAR) (pi1 T V CAR) CAR)
	     (f ⟼ (lambda1 (pi1 U V CAR) (pi1 T V CAR)
		      (g ⟼ (lambda1 T V 
				  (t ⟼ (ev1 U V g (ev1 T U f t CAR) CAR)) CAR)) CAR)) CAR), 
   dT ⟼ dU ⟼ dV ⟼ 
   (lambda1 (pi1 T U CAR)
	    (pi1 (pi1 U V CAR) (pi1 T V CAR) CAR)
	    (f ⟼ (lambda1 (pi1 U V CAR) (pi1 T V CAR)
		      (g ⟼ (lambda1 T V 
				  (t ⟼ (ev1 U V g (ev1 T U f t CAR) CAR)) CAR)) CAR)) CDR
	   (pi1 T U CDR dT dU)
	   (pi1 (pi1 U V CAR) (pi1 T V CAR) CDR (pi1 U V CDR dU dV) (pi1 T V CDR dT dV))
	   (f ⟼ df ⟼ (lambda1 
		      (pi1 U V CAR)
		      (pi1 T V CAR)
		      (g ⟼ (lambda1 T V 
				  (t ⟼ (ev1 U V g (ev1 T U f t CAR) CAR)) CAR)) CDR
				       (pi1 U V CDR dU dV)
				       (pi1 T V CDR dT dV)
		   (g ⟼ dg ⟼ (lambda1 T V 
				  (t ⟼ (ev1 U V g (ev1 T U f t CAR) CAR)) CDR dT dV 
				  (t ⟼ dt ⟼ (ev1 U V g
						 (ev1 T U f t CAR) CDR 
						 dU dV dg 
						 (ev1 T U f t CDR dT dU df dt))))))))).

   # Here's what the proof above looks like if we delete all the expression parts, keeping
   # only the judgment parts, from which the expression parts can be deduced.  Then it looks
   # as linear as in the intrinsic encoding.

   # T ⟼ U ⟼ V ⟼ 
   # (_, 
   # dT ⟼ dU ⟼ dV ⟼ 
   # (lambda1 _ _ _ CDR
   # 	   (pi1 _ _ CDR dT dU)
   # 	   (pi1 _ _ CDR (pi1 _ _ CDR dU dV) (pi1 _ _ CDR dT dV))
   # 	   (f ⟼ df ⟼ (lambda1 _ _ _ CDR
   # 				       (pi1 _ _ CDR dU dV)
   # 				       (pi1 _ _ CDR dT dV)
   # 		   (g ⟼ dg ⟼ (lambda1 _ _ _ CDR dT dV 
   # 				  (t ⟼ dt ⟼ (ev1 _ _ g _ CDR 
   # 						 dU dV dg 
   # 						 (ev1 _ _ f t CDR dT dU df dt))))))))).

Theorem compose' { |- T U V Type } : (T->U) -> (U->V) -> (T->V) ::= 
    # this time with micro-tactics (which don't help in pairs mode!)
    T ⟼ U ⟼ V ⟼ 
    ((@[λ] (@[∏] T (_ ⟼ U)) (f ⟼ (@[λ] (@[∏] U (_ ⟼ V)) (g ⟼ (@[λ] T (t ⟼ (@[ev] g (@[ev] f t T (_ ⟼ U)) U (_ ⟼ V))))))))
     # (lambda1 (pi1 T U CAR) (pi1 (pi1 U V CAR) (pi1 T V CAR) CAR)
     # 	          (f ⟼ (lambda1 (pi1 U V CAR) (pi1 T V CAR)
     # 			   (g ⟼ (lambda1 T V 
     # 			   	       (t ⟼ (ev1 U V g (ev1 T U f t CAR) CAR)) CAR)) CAR)) CAR)
											       , 
    _ ⟼ _ ⟼ _ ⟼ 
    (λ_hastype (pi1 T U CAR)
	 (_ ⟼ (pi1 (pi1 U V CAR) (pi1 T V CAR) CAR))
	 (f ⟼ (λ_hastype (pi1 U V CAR) (_ ⟼ (pi1 T V CAR))
		   (g ⟼ (λ_hastype T (_ ⟼ V) 
			       (t ⟼ (ev1 U V g (ev1 T U f t CAR) CAR)) CAR)) CAR)) CDR
	(pi1 T U CDR _ _)
	(_ ⟼ _ ⟼ (pi1 (pi1 U V CAR) (pi1 T V CAR) CDR (pi1 U V CDR _ _) (pi1 T V CDR _ _)))
	(f ⟼ _ ⟼ (λ_hastype
	       (pi1 U V CAR)
	       (_ ⟼ (pi1 T V CAR))
	       (g ⟼ (λ_hastype T (_ ⟼ V) 
			   (t ⟼ (ev1 U V g (ev1 T U f t CAR) CAR)) CAR)) CDR
				(pi1 U V CDR _ _)
				(_ ⟼ _ ⟼ (∏_istype T (_ ⟼ V) CDR _ _))
	       (g ⟼ _ ⟼ (λ_hastype T (_ ⟼ V)
			      (t ⟼ (ev1 U V g (ev1 T U f t CAR) CAR)) CDR _ _ 
			       (t ⟼ _ ⟼ (ev1 U V g (ev1 T U f t CAR) CDR 
					      _ _ _ (ev1 T U f t CDR _ _ _ _))))))))).

  # ev1 : (T:texp) ⟶ 
  #       (U:texp) ⟶ 
  #       (f:oexp) ⟶ 
  #       (o:oexp) ⟶ 
  #       (x:Singleton((@[ev] f o (_ ⟼ U)) : oexp)) × 
  #         istype T ⟶ 
  #         istype U ⟶ 
  #         hastype f (@[∏] T (_ ⟼ U)) ⟶ 
  #         hastype o T ⟶ 
  #         hastype x U

Definition barbara { |- T U V Type } ⊢ (T->U) -> (U->V) -> (T->V) Type ::=
    T ⟼ U ⟼ V ⟼ (_, $tscheck ).

End.							    # working on $tscheck

Theorem compose'' { |- T U V Type } : (T->U) -> (U->V) -> (T->V) ::= 
    T ⟼ U ⟼ V ⟼ (
     (@[λ] (@[∏] T (_ ⟼ U)) (f ⟼ (@[λ] (@[∏] U (_ ⟼ V)) (g ⟼ (@[λ] T (t ⟼ (@[ev] g (@[ev] f t T (_ ⟼ U)) U (_ ⟼ V)))))))),
     _ ⟼ _ ⟼ _ ⟼ $tscheck
     ).

#   Local Variables:
#   compile-command: "make -C .. interpretations DEBUG=no"
#   End:
