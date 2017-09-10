module Events.Actions exposing (EventsAction(..), FilterBy(..))

import Events.Model exposing (Events, Event, Route)
import Http


type FilterBy
    = ByName String


type EventsAction
    = ReceiveEvents (Result Http.Error Events)
    | ReceiveEvent (Result Http.Error Event)
    | OnFilter FilterBy
    | OnChange Event
    | OnChangeDate String
    | OnSubmit
    | OnRoute Route
