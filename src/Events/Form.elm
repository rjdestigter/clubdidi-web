module Events.Form exposing (render)

import Events.Model exposing (Event)
import Events.Actions exposing (EventsAction(..))
import Html as H exposing (Html, form, div, text, section, button)
import Html.Attributes as A exposing (class, style, type_)
import Html.Events as E exposing (onClick)
import MDC exposing (..)


onChangeName : Event -> String -> EventsAction
onChangeName event value =
    OnChange { event | name = value }

onChangeDate : Event -> String -> EventsAction
onChangeDate event value =
    OnChange { event | date = value }

render : Event -> Html EventsAction
render event =
    form [ class "mdc-card", style [ ( "max-width", "800px" ), ( "margin", "15px" ), ( "padding", "15px" ) ] ]
        [ textfield event.name "Name" (onChangeName event) |> formField
        , datepicker event.date "Date" (onChangeDate event) |> formField
        , section [ class "mdc-card__actions" ]
            [ button [ class "mdc-button mdc-button--raised", type_ "button", onClick OnSubmit ] [ text "Submit" ] ]
        ]
