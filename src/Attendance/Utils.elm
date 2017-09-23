module Attendance.Utils exposing (..)

import Events.Model exposing (Event)
import Members.Model exposing (Member)
import Attendance.Model exposing (Model, Attendance)

match : Event -> Member -> Attendance -> Bool
match event member (eventId, memberId) =
    event.id == eventId && member.id == memberId

isAttending : Model -> Event -> Member -> Bool
isAttending model event member =
  let
    count = List.filter (match event member) model
    |> List.length
  in
    count > 0
