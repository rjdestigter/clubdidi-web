module Attendance exposing (attendance)

import GraphQL exposing (apply, maybeEncode)
import Http
import Json.Encode exposing (encode)
import Attendance.Model exposing (Attendance(..))
import Attendance.Decoders exposing (attendancesDecoder)


attendance : String -> Http.Request (List Attendance)
attendance token =
    let
        graphQLQuery =
            """query attendance { attendance { event member } }"""
    in
        let
            graphQLParams =
                Json.Encode.object
                    []
        in
            GraphQL.query "GET" token graphQLQuery "attendance" graphQLParams attendancesDecoder
