module Events.Model exposing
  ( Events
  , Event
  , Model
  , Filters
  , Route(..)
  , blank
  , initial
  )


type alias Event =
    { id : String
    , name : String
    , date : String
    }


type alias Events =
    List Event

type Route
  = Index
  | Add
  | Edit Event
  | Delete Event

type alias Filters =
    { name : String
    }


type alias Model =
    { events : Events
    , operation : Event
    , filters : Filters
    , route : Route
    }


blank : Event
blank =
    Event "" "" ""


initial : Model
initial =
    { events = []
    , filters = Filters ""
    , operation = blank
    , route = Index
    }
