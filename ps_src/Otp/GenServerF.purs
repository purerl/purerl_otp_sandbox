-- | Typed gen_server wrapper via record of funs
-- |
-- | Translation into some StateT is left as an exercise for the reader.
-- |
-- | Downside: * code replacement isn't going to work (all gen servers are this module using a state of funs)
-- | * Inefficient thunks+curried form of call/cast funs
module Otp.GenServerF where

import Prelude

import Effect (Effect)
import Erl.Atom (Atom)

newtype TypedPid spec = TypedPid Pid
foreign import data Pid :: Type


data Moniker spec = Pid (TypedPid spec)
                  | LocalName Atom


data InitResult state = Ok state
data Reply reply state = Reply reply state
data NoReply state = Noreply state

type GenServerSpec args state call callReply cast = 
    { init :: args -> Effect (InitResult state)
    , handleCall :: call -> state -> Effect (Reply callReply state)
    , handleCast :: cast -> state -> Effect (NoReply state)
    }

-- | Result of a start or start_link call - currently opaque provided primarily to pass on rather than introspect
foreign import data GenServerResult :: Type

foreign import start_ :: forall args state call callReply cast.
    GenServerSpec args state call callReply cast -> args -> Effect GenServerResult
foreign import start :: forall args state call callReply cast.
    Atom -> GenServerSpec args state call callReply cast -> args -> Effect GenServerResult

foreign import startLink_ :: forall args state call callReply cast.
    GenServerSpec args state call callReply cast -> args -> Effect GenServerResult
foreign import startLink :: forall args state call callReply cast.
    Atom -> GenServerSpec args state call callReply cast -> args -> Effect GenServerResult

-- call :: forall args state call callReply cast. Moniker (GenServerSpec args state call callReply cast) -> call -> Effect callReply
-- call (Pid (TypedPid pid)) message =
--   callByPid pid message
-- call (LocalName localName) message =
--   callByLocalName localName message

-- cast :: forall args state call callReply cast. Moniker (GenServerSpec args state call callReply cast) -> cast -> Effect Unit
-- cast (Pid (TypedPid pid)) message =
--   castByPid pid message
-- cast (LocalName localName) message =
--   castByLocalName localName message

-- foreign import callByPid :: forall message response. Pid -> message -> Effect response

-- foreign import callByLocalName :: forall message response. Atom -> message -> Effect response

-- foreign import castByPid :: forall message. Pid -> message -> Effect Unit

-- foreign import castByLocalName :: forall message. Atom -> message -> Effect Unit
