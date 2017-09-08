module Members.Encoders exposing (..)

import Json.Decode exposing (..)
import Date exposing (Date, Month(..))
import Json.Encode as Encode exposing (encode)
import Members.Utils exposing (roleToString)
import Members.Model exposing (Member, Roles, Role)


dateOfBirthEncoder : String -> Value
dateOfBirthEncoder dob =
    (if String.isEmpty dob |> not then
        let
            yyymmdd =
                dob |> String.split "/" |> List.reverse |> String.join "/"
        in
            case Date.fromString yyymmdd of
                Ok date ->
                    yyymmdd

                _ ->
                    ""
     else
        ""
    )
        |> Encode.string


rolesEncoder : List Role -> List Value
rolesEncoder roles =
    roles
        |> List.map roleToString
        |> List.map Encode.string
