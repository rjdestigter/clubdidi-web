module Events.Model exposing (Events, Event, Model, blank, initial)


type alias Event =
    { id : String
    , name : String
    , date : String
    }


type alias Events =
    List Event


type alias Filters =
    { name : String
    }


type alias Model =
    { events : List Events
    , operation : Event
    , filters : Filters
    }


blank : Event
blank =
    Event "" "" ""


initial : Model
initial =
    { events = []
    , filters = Filters ""
    , operation = blank
    }
