module Otp.GenServer where

import Effect (Effect)
import Erl.Atom (Atom)
import Erl.Data.List (List)

-- Restriction on global/via options
data ServerName = Local Atom | Global Atom | Via Atom Atom
newtype Module = Module Atom

data Option

-- | Result of a start or start_link call - currently opaque provided primarily to pass on rather than introspect
foreign import data GenServerResult :: Type

foreign import start_ :: forall a. Module -> a -> List Option -> Effect GenServerResult
foreign import start :: forall a. ServerName -> Module -> a -> List Option -> Effect GenServerResult

foreign import startLink_ :: forall a. Module -> a -> List Option -> Effect GenServerResult
foreign import startLink :: forall a. ServerName -> Module -> a -> List Option -> Effect GenServerResult
