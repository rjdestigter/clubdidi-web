module Events.List exposing (render)

import Events.Model exposing (Model, Events, Event, Filters)
import Events.Actions exposing (EventsAction(..), FilterBy(..))

import Html exposing (Html, table, tr, td, text)
import Html.Attributes exposing (style, class, colspan)
import Date


cell : List (Html EventsAction) -> Html EventsAction
cell =
    td [ style [ ( "padding", "10px" ), ( "white-space", "nowrap" ) ] ]


date : String -> String
date value =
    case Date.fromString value of
        Ok date ->
            String.join "-" [ Date.day date |> toString, Date.month date |> toString, Date.year date |> toString ]

        _ ->
            ""


eventRow : Event -> Html EventsAction
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


render : Model -> Html EventsAction
render { events, filters } =
    events
        |> List.map eventRow
        |> \rows ->
            rows
                |> table [ style [ ( "width", "100%" ), ( "border-collapse", "collapse" ) ] ]
