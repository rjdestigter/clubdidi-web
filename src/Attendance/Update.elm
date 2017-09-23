module Attendance.Update exposing (update)

import Http
import Attendance.Model exposing (Attendance, Model)
import Events.Model exposing (Event)
import Members.Model exposing (Member)
import Attendance.Actions exposing (AttendanceAction(..))
import Attendance.Utils as Utils
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

deletedAttendance : Event -> Member -> Result Http.Error (Bool) -> Model -> ( Model, Cmd AttendanceAction )
deletedAttendance event member response model =
    case response of
      Ok _ ->
        let
          match = Utils.match event member
        in
          (
            model
              |> List.filter (\attendance -> not (match attendance))
          ) ! []
      _ ->
        model ! []

update : AttendanceAction -> Model -> String -> ( Model, Cmd AttendanceAction )
update action model token =
    case action of
        ReceiveAttendance payload ->
            receiveAttendance payload model

        DeletedAttendance event member payload ->
            deletedAttendance event member payload model

        OnAttend event member ->
            model ! []
