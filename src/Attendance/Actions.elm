module Attendance.Actions exposing (AttendanceAction(..))

import Http
import Attendance.Model exposing (Attendance)
import Members.Model exposing (Member)
import Events.Model exposing (Event)

type AttendanceAction
    = ReceiveAttendance (Result Http.Error (List Attendance))
    | OnAttend Event Member
