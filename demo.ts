# -*- coding: utf-8 -*-

# All the base judgments, and what would satisfy them as evidence.
# The binders are present in order to produce well-formed types.
# ( Here "with" means a satisfactory term would be a pair. )

Check : TS (T:texp) =>             [ T Type ].		# a proof that T is a type

Check : TS (T:texp) =>             |- T Type.		# T with a proof that T is a type

Check : TS (T:texp) => (t:oexp) => [ t : T ].		# a proof that t has type T

Check : TS (T:texp) => (t:oexp) => |- t : T.		# t with a proof that t has type T

Check : TS (T:texp) =>             : T.			# an o-expression with a proof that it has type T

Check : TS (T:texp) => (U:texp) => [ T = U ].		# a proof that T = U (type equality)

Check : TS (T:texp) => (t:oexp) 
                    => (u:oexp) => [ t = u : T ].	# a proof that t = u : T (object equality)

# Here are the base judgments again, but this time with binders for pairs.  For example,
# { |- T Type } denotes a parameter T whose value is a t-expression with a proof that it is a type.

Check : TS { |- T Type }        [ T Type ].		# T with a proof that T is a type

Check : TS { |- T Type }        |- T Type.		# T with a proof that T is a type

Check : TS { |- T Type, t:T }   [ t : T ].		# a proof that t has type T

Check : TS { |- T Type, t:T }   |- t : T.		# t with a proof that t has type T

Check : TS { |- T Type }        : T.			# an o-expression with a proof that it has type T

Check : TS { |- T U Type }      [ T = U ].		# a proof that T = U (type equality)

Check : TS { |- T Type, t u:T } [ t = u : T ].		# a proof that t = u : T (object equality)

# Here are the judgments involving ulevel equality:

Check : TS (t:oexp) => (u:oexp) => [ t ~ u ].		# ulevel equivalence for o-expressions
Check : TS (T:texp) => (U:texp) => [ T ~ U Type ].	# ulevel equivalence for t-expressions
Check : TS (u:uexp) => (v:uexp) => [ u ~ v Ulevel ].	# ulevel equivalence for u-expressions

Check : TS { |- T Type, t u:T } [ t ~ u ].		# ulevel equivalence for o-expressions
Check : TS { |- T U Type }      [ T ~ U Type ].		# ulevel equivalence for t-expressions
Check : TS { |- u v Ulevel }    [ u ~ v Ulevel ].	# ulevel equivalence for u-expressions

# Sample theorems demonstrating the syntax.

Theorem compose1  { ⊢ T Type, U Type, V Type, g:U⟶V, f:T⟶U, t:T } : V ;;
		T ⟼ U ⟼ V ⟼ g ⟼ f ⟼ t ⟼ 
		(ev_hastype U V g (ev_hastype T U f t)).

Theorem compose2 { ⊢ u Ulevel, T:[U](u), U:[U](u), V:[U](u), g:*U ⟶ *V, f:*T ⟶ *U, t:*T } : *V ;; 
		u ⟼ T ⟼ U ⟼ V ⟼ g ⟼ f ⟼ t ⟼ 
		(ev_hastype (El_istype u U)
			    (El_istype u V) 
			    g 
			    (ev_hastype 
			    	(El_istype u T) 
				(El_istype u U) 
				f 
				t)).

Theorem compose3 { |- u Ulevel, T U V : [U](u), g : *[∀;x](u,u,U,V), f : *[∀;x](u,u,T,U), t:*T } : *V ;;
		 u ⟼ T ⟼ U ⟼ V ⟼ g ⟼ f ⟼ t ⟼ 
		 (ev_hastype (El_istype u U) (El_istype u V) 
		 	(cast (El_istype u (forall u u U V)) 
			      (∏_istype (El_istype u U) (El_istype u V))
			      g 
			      (El_forall_reduction u u U V))
			(ev_hastype (El_istype u T) (El_istype u U) 
		 	(cast (El_istype u (forall u u T U)) 
			      (∏_istype (El_istype u T) (El_istype u U))
			      f
			      (El_forall_reduction u u T U))
			t)).

End.

#   Local Variables:
#   compile-command: "make demo "
#   End:
