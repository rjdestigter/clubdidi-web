{-
   This file was automatically generated by elm-graphql.
-}


module UpdateMember exposing (UpdateMember, updateMember)

import GraphQL exposing (apply, maybeEncode)
import Http
import Json.Decode exposing (..)
import Json.Encode as Encode exposing (encode)
import Members exposing (Member, Roles, Role, roleToString, memberDecoder)
import Date exposing (Date, Month(..))


monthToInt : Month -> String
monthToInt month =
    case month of
        Jan ->
            "01"

        Feb ->
            "02"

        Mar ->
            "03"

        Apr ->
            "04"

        May ->
            "05"

        Jun ->
            "06"

        Jul ->
            "07"

        Aug ->
            "08"

        Sep ->
            "09"

        Oct ->
            "10"

        Nov ->
            "11"

        Dec ->
            "12"


endpointUrl : String
endpointUrl =
    "http://138.197.161.149:8080/graphql"


type alias UpdateMember =
    { updateMember :
        Maybe
            { member :
                Maybe
                    { id : String
                    , firstName : Maybe String
                    , lastName : Maybe String
                    , email : Maybe String
                    , dateOfBirth : Maybe String
                    , payed : Maybe Bool
                    , volunteer : Maybe Bool
                    }
            }
    }


dateOfBirthEncoder : String -> String
dateOfBirthEncoder dob =
    case Date.fromString dob of
        Ok date ->
            String.join "-" [ Date.year date |> toString, Date.month date |> monthToInt, Date.day date |> toString ]

        _ ->
            ""


dateToString : Date -> String
dateToString date =
    String.join "-" [ Date.year date |> toString, Date.month date |> monthToInt, Date.day date |> toString ]


updateMember : Date -> Member -> Http.Request Member
updateMember date member =
    let
        graphQLQuery =
            """mutation UpdateMember($input: UpdateMemberInput!) { updateMember(input: $input) { member { id firstName lastName email dateOfBirth payed volunteer roles } } }"""
    in
        let
            graphQLParams =
                Encode.object
                    [ ( "input"
                      , Encode.object
                            [ ( "id", Encode.string member.id )
                            , ( "firstName", Encode.string member.firstName )
                            , ( "lastName", Encode.string member.lastName )
                            , ( "email", Encode.string member.email )
                            , ( "volunteer", Encode.bool member.volunteer )
                            , ( "dateOfBirth", Encode.string (dateOfBirthEncoder member.dateOfBirth) )
                            , ( "payed", Encode.string (dateToString date) )
                            ]
                      )
                    ]
        in
            GraphQL.mutation endpointUrl graphQLQuery "UpdateMember" graphQLParams updateMemberDecoder


updateMemberDecoder : Decoder Member
updateMemberDecoder =
    at [ "data", "updateMember", "member" ] memberDecoder
