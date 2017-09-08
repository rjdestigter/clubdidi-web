module SubmitMember exposing (submit)

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
    "http://localhost:8080/graphql"


dateOfBirthEncoder : String -> String
dateOfBirthEncoder dob =
    if String.isEmpty dob |> not then
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


dateToString : Date -> String
dateToString date =
    String.join "-" [ Date.year date |> toString, Date.month date |> monthToInt, Date.day date |> toString ]


rolesEncoder : List Role -> List Value
rolesEncoder roles =
    roles
        |> List.map roleToString
        |> List.map Encode.string


submit : String -> Date -> Member -> Http.Request Member
submit token date member =
    let
        isNew =
            String.isEmpty member.id

        ( operationName, graphQLQuery, decoder ) =
            case isNew of
                True ->
                    ( "CreateMember"
                    , """mutation CreateMember($input: CreateMemberInput!) { createMember(input: $input) { member { id firstName lastName email dateOfBirth payed volunteer roles } } }"""
                    , submitMemberDecoder "createMember"
                    )

                False ->
                    ( "UpdateMember"
                    , """mutation UpdateMember($input: UpdateMemberInput!) { updateMember(input: $input) { member { id firstName lastName email dateOfBirth payed volunteer roles } } }"""
                    , submitMemberDecoder "updateMember"
                    )
    in
        let
            encoders =
                [ ( "firstName", Encode.string member.firstName )
                , ( "lastName", Encode.string member.lastName )
                , ( "email", Encode.string member.email )
                , ( "volunteer", Encode.bool member.volunteer )
                , ( "dateOfBirth", Encode.string (dateOfBirthEncoder member.dateOfBirth) )
                , ( "payed", Encode.string (dateToString date) )
                , ( "roles", Encode.list (rolesEncoder member.roles) )
                ]

            graphQLParams =
                Encode.object
                    [ ( "input"
                      , Encode.object
                            (case isNew of
                                True ->
                                    encoders

                                False ->
                                    ( "id", Encode.string member.id ) :: encoders
                            )
                      )
                    ]
        in
            GraphQL.mutation endpointUrl token graphQLQuery operationName graphQLParams decoder


submitMemberDecoder : String -> Decoder Member
submitMemberDecoder key =
    at [ "data", key, "member" ] memberDecoder
