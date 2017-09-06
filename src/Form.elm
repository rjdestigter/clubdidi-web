module Form exposing (memberForm)

import Members exposing (Member)
import Model exposing (Msg(..))
import Html exposing (Html, form, div, text, section, button)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import MDC exposing (textfield)


onChangeFirstName : Member -> String -> Msg
onChangeFirstName member value =
    OnEdit { member | firstName = value }


onChangeLastName : Member -> String -> Msg
onChangeLastName member value =
    OnEdit { member | lastName = value }


formField : Html Msg -> Html Msg
formField field =
    div [ class "mdc-form-field", style [ ( "display", "block" ) ] ] [ field ]


memberForm : Member -> Html Msg
memberForm member =
    form [ class "mdc-card", style [ ( "margin", "15px" ), ( "padding", "15px" ), ( "display", "inline-flex" ) ] ]
        [ textfield member.firstName "First Name" (onChangeFirstName member) |> formField
        , textfield member.lastName "Last Name" (onChangeLastName member) |> formField
        , section [ class "mdc-card__actions" ]
            [ button [ class "mdc-button mdc-button--raised", onClick OnSubmit ] [ text "Submit" ] ]
        ]
