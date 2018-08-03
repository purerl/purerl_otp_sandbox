-- | Implementing gen_server via an external proxy which implements the actual behaviour,
-- | delegating to this module pretty much as-is. 
-- |
-- | State and request types are pretty much on a solid footing, init and call/cast reply types
-- | are a little "punnish", making (valid) assumptions as to the underlying representation.
-- | Callback functions are not here in Effect, but if they were, additional thunk forcing would be required
-- | in the proxy code.
module GenServerExternal where

import Prelude

import Data.Maybe (Maybe(..))

type State = Maybe Int

data InitResult = Ok State

data CallRequest = Fetch | FetchWithDefault Int
data CastRequest = Store Int | Clear

data Reply = Reply (Maybe Int) State
data NoReply = Noreply State

init :: forall a. a -> InitResult
init _ = Ok Nothing

handle_call :: forall a. CallRequest -> a -> State -> Reply
handle_call Fetch _ s = Reply s s
handle_call (FetchWithDefault n) _ s@Nothing = Reply (Just n) s
handle_call (FetchWithDefault _) _ s@(Just n) = Reply (Just n) s

handle_cast :: CastRequest -> State -> NoReply
handle_cast Clear _ = Noreply Nothing
handle_cast (Store n) _ = Noreply $ Just n
