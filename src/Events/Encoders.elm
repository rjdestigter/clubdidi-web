module Events.Encoders exposing (..)

import Json.Decode exposing (..)
import Date exposing (Date, Month(..))
import Json.Encode as Encode exposing (encode)

dateEncoder : String -> Value
dateEncoder date =
    (if String.isEmpty date |> not then
        let
            yyymmdd =
                date |> String.split "/" |> List.reverse |> String.join "/"
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
