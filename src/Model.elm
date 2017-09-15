module Model exposing (..)

import Members.Model
import Members.Actions exposing (MembersAction)
import Events.Model
import Attendance.Model
import Events.Actions exposing (EventsAction)
import Attendance.Actions exposing (AttendanceAction)
import Router.Model exposing (Route)
import Http


type Flag
    = Menu


type Msg
    = MembersApp MembersAction
    | EventsApp EventsAction
    | AttendanceApp AttendanceAction
    | OnToggleFlag Flag
    | UpdateUser User
    | Login
    | ReceiveToken (Result Http.Error String)
    | OnChangeDate String
    | OnSelectEvent Events.Model.Event


type User
    = Authenticated String
    | User String String


type alias Model =
    { members : Members.Model.Model
    , events : Events.Model.Model
    , attendance : Attendance.Model.Model
    , flags : { menu : Bool }
    , route : Route
    , user : User
    , event : Maybe Events.Model.Event
    }
