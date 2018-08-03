-- | Implementing gen_server directly via use of attribute generation in the purerl compiler backend.
-- |
-- | Very much like GenServerExternal but with the additional caveats that 
-- | 1. the representation of the init/handle_call/handle_cast functions matches the expected, in particular this will be a problem
-- |    if wanting to implement call/cast handler in Effect (i.e. currently require an unsafePerformEffect which is kind of fine as
-- |    thunking is already present, yet evil)
-- | 2. the generation of attributes may be removed from the compiler without warning.
module GenServerAttributeHACK where

import Prelude

import Attribute (Attribute(..), GenServerBehaviour)
import Data.Maybe (Maybe(..))
import Effect.Unsafe (unsafePerformEffect)
import Erl.Atom (Atom, atom)
import Erl.Data.List (nil)
import Otp.GenServer (GenServerResult, Module(..), ServerName(..), startLink)

_behaviour :: GenServerBehaviour
_behaviour = Attribute

type State = Maybe Int

data InitResult = Ok State

data CallRequest = Fetch | FetchWithDefault Int
data CastRequest = Store Int | Clear

data Reply = Reply (Maybe Int) State
data NoReply = Noreply State

thisModule :: Atom
thisModule = atom "genServerAttributeHACK@ps"

-- unsafePerformEffect meaning this value is unsafe to reference from PS at all! Must only be referenced directly to start this gen_server
start_link :: GenServerResult
start_link = unsafePerformEffect $ startLink (Local thisModule) (Module thisModule) unit nil

-- gen_server callbacks - not checked in PureScript in any way! attribute ensures their presence/arity is checked only

init :: forall a. a -> InitResult
init _ = Ok Nothing

handle_call :: forall a. CallRequest -> a -> State -> Reply
handle_call Fetch _ s = Reply s s
handle_call (FetchWithDefault n) _ s@Nothing = Reply (Just n) s
handle_call (FetchWithDefault _) _ s@(Just n) = Reply (Just n) s

handle_cast :: CastRequest -> State -> NoReply
handle_cast Clear _ = Noreply Nothing
handle_cast (Store n) _ = Noreply $ Just n
