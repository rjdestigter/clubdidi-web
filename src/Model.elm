module Model exposing (..)

import Members.Model exposing (Member)
import Members.Actions exposing (MembersAction)
import Events.Model exposing (Event)
import Http


type Flag
    = Menu


type Msg
    = MembersRoute MembersAction
    | OnToggleFlag Flag
    | OnRoute Route
    | UpdateUser User
    | Login
    | ReceiveToken (Result Http.Error String)


type
    Route
    -- Members
    = MembersList
    | AddMember
    | EditMember Member
    | DeleteMember Member
      -- Events
    | EventsList
    | AddEvent
    | EditEvent Event
    | DeleteEvent Event


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
