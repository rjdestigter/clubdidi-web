module Attendance.Decoders exposing (attendancesDecoder, attendanceDecoder)

import Attendance.Model exposing (Attendance(..))
import Json.Decode exposing (Decoder, map2, field, string, at, list)


attendanceDecoder : Decoder Attendance
attendanceDecoder =
    map2 Attendance
        (field "event" string)
        (field "member" string)


attendancesDecoder : Decoder (List Attendance)
attendancesDecoder =
    at [ "data", "attendance" ] (list attendanceDecoder)
