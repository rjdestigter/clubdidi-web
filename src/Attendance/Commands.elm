module Attendance.Commands exposing (..)

import Http
import Task
import Date
import Attendance
import Attendance.Model exposing (Attendance)
import Events.Model exposing (Event)
import Members.Model exposing (Member)
import Attendance.Submit as Submit
import Attendance.Actions exposing (AttendanceAction(..))


fetch : String -> Cmd AttendanceAction
fetch token =
    Attendance.attendance token
        |> Http.send ReceiveAttendance


submit : String -> Event -> Member -> Cmd AttendanceAction
submit token event member =
    let
        httpTask = Submit.submit token event member |> Http.toTask
    in
        Task.attempt ReceiveAttendance httpTask
