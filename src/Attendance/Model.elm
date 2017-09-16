module Attendance.Model exposing
  ( Attendance
  , Model
  , initial
  )

type alias Attendance = (String, String)

type alias Model = List Attendance

initial : Model
initial = []
