module Attendance.Submit exposing (submit)

import Http
import Json.Decode exposing (..)
import Json.Encode as Encode exposing (encode)
import GraphQL exposing (apply, maybeEncode)
import Attendance.Model exposing (Attendance)
import Events.Model exposing (Event)
import Members.Model exposing (Member)
import Attendance.Decoders exposing (attendanceDecoder)


submit : String -> Event -> Member -> Http.Request (List Attendance)
submit token event member =
    let
        ( operationName, graphQLQuery, decoder ) =
                      ( "CreateAttendance"
                , """mutation CreateAttendance($input: CreateAttendanceInput!) { createAttendance(input: $input) { attendance { event member } } }"""
                , submitAttendanceDecoder "createAttendance"
                )
    in
        let
            encoders =
                [ ( "event", Encode.string event.id )
                , ( "member", Encode.string member.id )
                ]

            graphQLParams =
                Encode.object
                    [ ( "input"
                      , Encode.object
                            encoders
                      )
                    ]
        in
            GraphQL.mutation token graphQLQuery operationName graphQLParams decoder


submitAttendanceDecoder : String -> Decoder (List Attendance)
submitAttendanceDecoder key =
    at [ "data", key, "attendance" ] attendanceDecoder
    |> map List.singleton
