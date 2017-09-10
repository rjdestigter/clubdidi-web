module Model exposing (..)

import Members.Model
import Members.Actions exposing (MembersAction)
import Events.Model
import Events.Actions exposing (EventsAction)
import Router.Model exposing (Route)
import Http


type Flag
    = Menu


type Msg
    = MembersApp MembersAction
    | EventsApp EventsAction
    | OnToggleFlag Flag
    | UpdateUser User
    | Login
    | ReceiveToken (Result Http.Error String)
    | OnChangeDate String


type User
    = Authenticated String
    | User String String


type alias Model =
    { members : Members.Model.Model
    , events : Events.Model.Model
    , flags : { menu : Bool }
    , route : Route
    , user : User
    }
