module Form exposing (memberForm)

import Members exposing (Member)
import Model exposing (Msg(..))
import Html exposing (Html, form, div, text, section, button, label, input)
import Html.Attributes exposing (class, style, type_, id, checked, for, name)
import Html.Events exposing (onClick)
import MDC exposing (textfield)


onChangeFirstName : Member -> String -> Msg
onChangeFirstName member value =
    OnEdit { member | firstName = value }


onChangeLastName : Member -> String -> Msg
onChangeLastName member value =
    OnEdit { member | lastName = value }


formField : List (Html msg) -> Html msg
formField children =
    div [ class "mdc-form-field", style [ ( "display", "block" ) ] ] children


radio : Html msg
radio =
    formField
        [ div
            [ class "mdc-radio" ]
            [ input
                [ class "mdc-radio__native-control", type_ "radio", id "radio-1", name "radios", checked False ]
                []
            , div
                [ class "mdc-radio__background" ]
                [ div
                    [ class "mdc-radio__outer-circle" ]
                    []
                , div
                    [ class "mdc-radio__inner-circle" ]
                    []
                ]
            ]
        , label
            [ id "radio-1-label", for "radio-1" ]
            [ text "Radio 1" ]
        ]


memberForm : Member -> Html Msg
memberForm member =
    form [ class "mdc-card", style [ ( "margin", "15px" ), ( "padding", "15px" ), ( "display", "inline-flex" ) ] ]
        [ textfield member.firstName "First Name" (onChangeFirstName member) |> List.singleton |> formField
        , textfield member.lastName "Last Name" (onChangeLastName member) |> List.singleton |> formField
        , radio
        , section [ class "mdc-card__actions" ]
            [ button [ class "mdc-button mdc-button--raised", type_ "button", onClick OnSubmit ] [ text "Submit" ] ]
        ]
