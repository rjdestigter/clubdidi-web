module Attendance.Model exposing
  ( Attendance(..)
  , Model
  , initial
  )

type Attendance = Attendance String String

type alias Model = List Attendance

initial : Model
initial = []
