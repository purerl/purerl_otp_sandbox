module Otp.GenServerR where

import Data.Symbol
import Prelude
import Prim.Row as Row

import Data.Symbol (SProxy(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Erl.Atom (Atom, atom)
import Unsafe.Coerce (unsafeCoerce)
import Prim.RowList
import Prim.TypeError

foreign import data Handle :: Type -> Type 

type GenServerSpec args state (c :: #Type) = { init :: args -> Effect state, call :: Record c }

foreign import start_ :: forall call args state. IsCallRecord state call => GenServerSpec args state call -> args -> Effect (Handle (GenServerSpec args state call))
-- (GenServerSpec args state call)

data Result state a = Result state a
call :: forall r r' l a b s args state call. IsSymbol l => Row.Cons l (a -> s -> Result b s) r' call => SProxy l -> Handle (GenServerSpec args state call) -> a -> Effect b
call label spec arg = call_ (atom $ reflectSymbol label) spec arg
-- GenServerSpec 

foreign import call_ :: forall a b r args state call. Atom -> Handle (GenServerSpec args state call) -> a -> b

cast :: forall r r' l a b s args state call. IsSymbol l => Row.Cons l (a -> s -> Result b Unit) r' call => SProxy l -> Handle (GenServerSpec args state call) -> a -> Effect Unit
cast label spec arg = call_ (atom $ reflectSymbol label) spec arg
-- GenServerSpec 

foreign import cast_ :: forall a b r args state call. Atom -> Handle (GenServerSpec args state call) -> a -> Unit


class IsCallRecord state (callRecord :: #Type) | callRecord -> state

instance isCallRecord :: (RowToList callRecord call, CallRowList state call) => IsCallRecord state callRecord

class CallRowList s (call :: RowList) | call -> s

instance callRowListNil :: CallRowList s Nil

instance callRowListCons :: (CallRowList s tail, IsSymbol l) => CallRowList s (Cons l (a -> s -> Result b s) tail)
-- TODO: This instance doesn't get selected, is there a way of doing this?
else instance callRowListConsStateError :: (Fail (Text "State type mismatch"), IsSymbol l) => CallRowList s1 (Cons l (a -> s -> Result b s2) tail)
else instance callRowListConsBadTypeError :: (Fail 
  (Beside (Text "Call function ") 
    (Beside (Text l) (Text " has the wrong shape"))),
  CallRowList s tail,
  IsSymbol l) =>
  CallRowList s1 (Cons l z tail)

spec = { call: {

            bar: \(z :: Number) (s :: Unit) -> Result 42 s
            , foo: \(x:: Int) (s :: Unit) -> Result x s
            , foo2: \(x:: Int) (s :: Unit) -> Result x s
            -- , blah : \z -> 42
            -- unused: 42
         },
         init: \_ -> pure unit
       }
f = do
  server <- start_ spec unit
  call (SProxy :: SProxy "foo") server 42
