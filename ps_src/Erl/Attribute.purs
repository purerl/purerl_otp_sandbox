module Attribute where

data Attribute (name :: Symbol) (content :: Symbol) = Attribute

type Behaviour = Attribute "behaviour"

type GenServerBehaviour = Behaviour "gen_server"
type GenStatemBehaviour = Behaviour "gen_statem"
type GenEventBehaviour = Behaviour "gen_event"
type GenSupervisorBehaviour = Behaviour "supervisor"