module Attendance.Update exposing (update)

import Http
import Attendance.Model exposing (Attendance, Model)
import Attendance.Actions exposing (AttendanceAction(..))
import Debug

updateAttendance : Model -> Result Http.Error (List Attendance) -> Model
updateAttendance model response =
    case response of
        Ok attendance ->
            List.concat [attendance, model]

        Err e ->
          let
            foo = Debug.log "error" e
          in
            model

receiveAttendance : Result Http.Error (List Attendance) -> Model -> ( Model, Cmd AttendanceAction )
receiveAttendance response model =
    updateAttendance model response ! []

update : AttendanceAction -> Model -> String -> ( Model, Cmd AttendanceAction )
update action model token =
    case action of
        ReceiveAttendance payload ->
            receiveAttendance payload model

        OnAttend event member ->
            model ! []
