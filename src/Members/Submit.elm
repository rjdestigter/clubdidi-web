module Members.Submit exposing (submit)

import Http
import Json.Decode exposing (..)
import Date exposing (Date, Month(..))
import Json.Encode as Encode exposing (encode)
import GraphQL exposing (apply, maybeEncode)
import Members.Model exposing (Member, Roles, Role)
import Members.Decoders exposing (memberDecoder)
import Members.Encoders exposing (rolesEncoder, dateOfBirthEncoder)


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
                , ( "dateOfBirth", dateOfBirthEncoder member.dateOfBirth )

                -- , ( "payed", Encode.string (dateToString date) )
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
            GraphQL.mutation token graphQLQuery operationName graphQLParams decoder


submitMemberDecoder : String -> Decoder Member
submitMemberDecoder key =
    at [ "data", key, "member" ] memberDecoder
