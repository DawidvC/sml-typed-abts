functor ShowAbt
  (structure Abt : ABT
   structure ShowMetavar : SHOW where type t = Abt.metavariable
   structure ShowVar : SHOW where type t = Abt.variable
   structure ShowSym : SHOW where type t = Abt.symbol) :> SHOW where type t = Abt.metacontext * Abt.abt =
struct
  open Abt infix $ $# infixr \
  type t = metacontext * abt

  structure Spine = Abt.Operator.Arity.Valence.Spine

  structure OShow = Operator.Show (Abt.Symbol.Show)

  fun toString (Omega, e) =
    case #2 (infer Omega e) of
         `x => ShowVar.toString x
       | (us, xs) \ e =>
           let
             val us' = Spine.pretty ShowSym.toString "," us
             val xs' = Spine.pretty ShowVar.toString "," xs
           in
             "{" ^ us' ^ "}[" ^ xs' ^ "]." ^ toString (Omega, e)
           end
       | theta $ es =>
           if Spine.isEmpty es then
             OShow.toString theta
           else
             OShow.toString theta
                ^ "(" ^ Spine.pretty (fn x => toString (Omega, x)) "; " es ^ ")"
       | mv $# (us, es) =>
           let
             val us' = Spine.pretty ShowSym.toString "," us
             val es' = Spine.pretty (fn x => toString (Omega, x)) "," es
           in
             ShowMetavar.toString mv ^ "{" ^ us' ^ "}[" ^ es' ^ "]"
           end
end

functor PlainShowAbt (Abt : ABT) =
  ShowAbt
    (structure Abt = Abt
     and ShowMetavar = Abt.Metavariable.Show
     and ShowVar = Abt.Variable.Show
     and ShowSym = Abt.Symbol.Show)

functor DebugShowAbt (Abt : ABT) =
  ShowAbt
    (structure Abt = Abt
     and ShowMetavar = Abt.Metavariable.DebugShow
     and ShowVar = Abt.Variable.DebugShow
     and ShowSym = Abt.Symbol.DebugShow)


