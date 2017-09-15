module Utils exposing (..)

import Date exposing (Date, Month(..))
import Regex


dateToString : Date -> String
dateToString date =
    String.join "-" [ Date.year date |> toString, Date.month date |> monthToInt, Date.day date |> toString ]

dateStringToString : String -> String
dateStringToString date =
  case Date.fromString date of
    Ok date -> dateToString date
    _ -> ""

test : String -> String -> Bool
test pattern input =
    String.isEmpty input
        || Regex.contains
            (pattern |> String.toLower |> Regex.regex)
            (String.toLower input)


monthToInt : Month -> String
monthToInt month =
    case month of
        Jan ->
            "01"

        Feb ->
            "02"

        Mar ->
            "03"

        Apr ->
            "04"

        May ->
            "05"

        Jun ->
            "06"

        Jul ->
            "07"

        Aug ->
            "08"

        Sep ->
            "09"

        Oct ->
            "10"

        Nov ->
            "11"

        Dec ->
            "12"
