module Members.Actions exposing (MembersAction(..), FilterBy(..))

import Members.Model exposing (Members, Member, Role)
import Http


type FilterBy
    = ByFirstName String
    | ByLastName String
    | ByRole Role
    | ByVolunteer Maybe Bool


type MembersAction
    = ReceiveMembers (Result Http.Error Members)
    | ReceiveMember (Result Http.Error Member)
    | OnFilter FilterBy
    | OnChange Member
    | OnSubmit
    | UpdateDateValue String
