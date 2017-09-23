module Attendance.Delete exposing (delete)

import Http
import Json.Decode exposing (..)
import Json.Encode as Encode exposing (encode)
import GraphQL exposing (apply, maybeEncode)
import Attendance.Model exposing (Attendance)
import Events.Model exposing (Event)
import Members.Model exposing (Member)
import Attendance.Decoders exposing (attendanceDecoder)


delete : String -> Event -> Member -> Http.Request Bool
delete token event member =
    let
        ( operationName, graphQLQuery, decoder ) =
                      ( "DeleteAttendance"
                , """mutation DeleteAttendance($input: DeleteAttendanceInput!) { deleteAttendance(input: $input) { clientMutationId } }"""
                , deleteAttendanceDecoder "deleteAttendance"
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


deleteAttendanceDecoder : String -> Decoder Bool
deleteAttendanceDecoder key = Json.Decode.succeed True
