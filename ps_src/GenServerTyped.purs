module GenServerTyped (
  startLink  
) where
  
import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
import Erl.Atom (Atom, atom)
import Otp.GenServerF (GenServerResult, GenServerSpec, InitResult(..), NoReply(..), Reply(..), start)

-- Types

type State = Maybe Int
data CallRequest = Fetch | FetchWithDefault Int
data CastRequest = Store Int | Clear
type Response = State

-- Public API

serverName :: Atom
serverName = atom "gen_server_typed"

startLink :: GenServerResult
startLink = unsafePerformEffect $ start serverName spec unit

-- Internals

spec :: GenServerSpec Unit State CallRequest Response CastRequest 
spec = { init, handleCall, handleCast }

init :: forall a. a -> Effect (InitResult State)
init _ = pure $ Ok Nothing

handleCall :: CallRequest -> State -> Effect (Reply Response State)
handleCall Fetch s = pure $ Reply s s
handleCall (FetchWithDefault n) s@Nothing = pure $ Reply (Just n) s
handleCall (FetchWithDefault _) s@(Just n) = pure $ Reply (Just n) s

handleCast :: CastRequest -> State -> Effect (NoReply State)
handleCast Clear _ = pure $ Noreply Nothing
handleCast (Store n) _ = pure $ Noreply $ Just n
