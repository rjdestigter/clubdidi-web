module Events.List exposing (eventsView)

import Model exposing (..)
import Events.Model exposing (Events, Event)
import Html exposing (Html, table, tr, td, text)
import Html.Attributes exposing (style, class, colspan)
import Date


cell : List (Html Msg) -> Html Msg
cell =
    td [ style [ ( "padding", "10px" ), ( "white-space", "nowrap" ) ] ]


date : String -> String
date value =
    case Date.fromString value of
        Ok date ->
            String.join "-" [ Date.day date |> toString, Date.month date |> toString, Date.year date |> toString ]

        _ ->
            ""


eventRow : Event -> Html Msg
eventRow event =
    tr
        [ style
            [ ( "box-shadow", "0px 1px 1px rgba(0,0,0,0.1)" )
            , ( "padding", "15px" )
            , ( "border", "1px solid whitesmoke" )
            ]
        ]
        [ cell [ text event.name ]
        , cell [ event.date |> date |> text ]
        ]


eventsView : Events -> Filters -> Html Msg
eventsView events filters =
    events
        |> List.map eventRow
        |> \rows ->
            rows
                |> table [ style [ ( "width", "100%" ), ( "border-collapse", "collapse" ) ] ]
