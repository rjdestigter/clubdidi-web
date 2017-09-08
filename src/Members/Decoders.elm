module Members.Decoders exposing (memberDecoder, membersDecoder, rolesDecoder)

import Json.Decode as Decode exposing (Decoder, field, string, bool, map, list, map8, at)
import Members.Model exposing (Member, Members, Roles)
import Members.Utils exposing (stringToRole)


rolesDecoder : Decoder Roles
rolesDecoder =
    list string |> map (List.map stringToRole)


memberDecoder : Decoder Member
memberDecoder =
    map8 Member
        (field "id" string)
        (field "firstName" string)
        (field "lastName" string)
        (field "email" string)
        (field "dateOfBirth" string)
        (field "payed" bool)
        (field "volunteer" bool)
        (field "roles" rolesDecoder)


membersDecoder : Decoder Members
membersDecoder =
    at [ "data", "members" ] (list memberDecoder)
