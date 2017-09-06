module Model exposing (..)

import Members exposing (Members, Member, Role)
import Http


type FilterBy
    = ByFirstName String
    | ByLastName String
    | ByRole Role
    | ByVolunteer Maybe Bool


type Flag
    = Menu


type Msg
    = ReceiveMembers (Result Http.Error Members)
    | ReceiveMember (Result Http.Error Member)
    | OnFilter FilterBy
    | OnToggleFlag Flag
    | OnEdit Member
    | OnRoute Route
    | OnSubmit


type alias Filters =
    { firstName : String
    , lastName : String
    , volunteer : Maybe Bool
    , roles : List Role
    }


type Route
    = MembersList
    | AddMember
    | EditMember (Maybe Member)
    | DeleteMember


type alias Model =
    { members : Members
    , filters : Filters
    , flags : { menu : Bool }
    , mutate : Member
    , route : Route
    }
