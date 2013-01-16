# -*- coding: utf-8 -*-

#############################################################################

Mode Pairs.

Include "rules/TS2.ts".

# derive versions of some inference rules with simple types

Definition pi1 { ⊢ T U Type } ⊢ @[∏;_][T,U] Type ::= 
	   (T ⟼ U ⟼ (∏_istype₁ T (_⟼U)), T ⟼ U ⟼ (∏_istype₂ T (_⟼U₁,_⟼U))).

Definition lambda1 { ⊢ T U Type } { t : T ⊢ o : U } ⊢ @[λ][T,o] : @[∏;_][T,U] ::= 
	   (T ⟼ U ⟼ (λ_hastype₁ T (_⟼U)), T ⟼ U ⟼ (λ_hastype₂ T (_⟼U₁,_⟼U))).

Definition ev1 { ⊢ T U Type, f : @[∏;_][T,U], o : T } ⊢ @[ev;_][f,o,U] : U ::= 
	   (T ⟼ U ⟼ (ev_hastype₁ T (_⟼U)), T ⟼ U ⟼ (ev_hastype₂ T (_⟼U₁,_⟼U))).

Theorem modus_ponens { |- T U V Type } : (T->U) -> (U->V) -> (T->V) ::= 
	(
	T ⟼ U ⟼ V ⟼ (lambda1₁ (pi1₁ T U) (pi1₁ (pi1₁ U V) (pi1₁ T V))
			       (f ⟼ (lambda1₁ (pi1₁ U V) (pi1₁ T V) 
				    (g ⟼ (lambda1₁ T V 
					     (t ⟼ (ev1₁ U V g (ev1₁ T U f t)))))))),
	dT ⟼ dU ⟼ dV ⟼ (lambda1₂ (pi1₂ dT dU) (pi1₂ (pi1₂ dU dV) (pi1₂ dT dV))
			  ((f ⟼ (lambda1₁ (pi1₁ dU₁ dV₁) (pi1₁ dT₁ dV₁) 
				    (g ⟼ (lambda1₁ dT₁ dV₁ 
					     (t ⟼ (ev1₁ dU₁ dV₁ g (ev1₁ dT₁ dU₁ f t))))))),
			   (df ⟼ (lambda1₂ (pi1₂ dU dV) (pi1₂ dT dV) 
				    ((g ⟼ (lambda1₁ dT₁ dV₁ 
					     (t ⟼ (ev1₁ dU₁ dV₁ g (ev1₁ dT₁ dU₁ df₁ t))))),
				     (dg ⟼ (lambda1₂ dT dV 	
					    ((t ⟼ (ev1₁ dU₁ dV₁ dg₁ (ev1₁ dT₁ dU₁ df₁ t))),
					     (dt ⟼ (ev1₂ dU dV dg (ev1₂ dT dU df dt)))))))))))).

Clear.

#############################################################################

Mode Relative.

Include "rules/TS2.ts".

# derive versions of some inference rules with simple types

Definition pi1 { ⊢ T U Type } ⊢ @[∏;_][T,U] Type ::= 
	   T ⟼ U ⟼ (_, T' ⟼ U' ⟼ (∏_istype T (_ ⟼ U) CDR T' (_ ⟼ _ ⟼ U'))).

Definition lambda1 { ⊢ T U Type } { t : T ⊢ o : U } ⊢ @[λ][T,o] : @[∏;_][T,U] ::=
	   T ⟼ U ⟼ o ⟼ ((@[λ] T o), T' ⟼ U' ⟼ (λ_hastype T (_ ⟼ U) o CDR T' (_ ⟼ _ ⟼ U'))).

Definition ev1 { ⊢ T U Type, f : @[∏;_][T,U], o : T } ⊢ @[ev;_][f,o,U] : U ::=
	   T ⟼ U ⟼ f ⟼ o ⟼ ((ev_hastype T (_ ⟼ U) f o CAR), T' ⟼ U' ⟼ (ev_hastype T (_ ⟼ U) f o CDR T' (_ ⟼ _ ⟼ U'))).

Theorem modus_ponens { |- T U V Type } : (T->U) -> (U->V) -> (T->V) ::= 
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

Theorem modus_ponens' { |- T U V Type } : (T->U) -> (U->V) -> (T->V) ::= 
	# this time with tactics (tactics like these don't help in pairs mode)
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
		(pi1 T U CDR _ _)
		(pi1 (pi1 U V CAR) (pi1 T V CAR) CDR (pi1 U V CDR _ _) (pi1 T V CDR _ _))
		(f ⟼ df ⟼ (lambda1 
			   (pi1 U V CAR)
	       		   (pi1 T V CAR)
			   (g ⟼ (lambda1 T V 
			   	       (t ⟼ (ev1 U V g (ev1 T U f t CAR) CAR)) CAR)) CDR
 					    (pi1 U V CDR _ _)
 					    (pi1 T V CDR _ _)
			(g ⟼ dg ⟼ (lambda1 T V 
			   	       (t ⟼ (ev1 U V g (ev1 T U f t CAR) CAR)) CDR _ _ 
					(t ⟼ dt ⟼ (ev1 U V g (ev1 T U f t CAR) CDR 
					               _ _ _ (ev1 T U f t CDR _ _ _ _))))))))).

#   Local Variables:
#   compile-command: "make -C .. interpretations DEBUG=no"
#   End:
