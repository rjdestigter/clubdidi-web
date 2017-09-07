module Form exposing (memberForm)

import Members exposing (Member)
import Model exposing (Msg(..))
import Html as H exposing (Html, form, div, text, section, button)
import Html.Attributes as A exposing (class, style, type_)
import Html.Events as E exposing (onClick)
import MDC exposing (textfield, input)


onChangeFirstName : Member -> String -> Msg
onChangeFirstName member value =
    OnEdit { member | firstName = value }


onChangeLastName : Member -> String -> Msg
onChangeLastName member value =
    OnEdit { member | lastName = value }

onChangeEmail : Member -> String -> Msg
onChangeEmail member value =
    OnEdit { member | email = value }

onChangeDOB : Member -> String -> Msg
onChangeDOB member value =
    OnEdit { member | dateOfBirth = value }

formFields : List (Html msg) -> Html msg
formFields children =
    div [ class "mdc-form-field", style [ ( "display", "block" ) ] ] children

formField : Html msg -> Html msg
formField child = child |> List.singleton |> formFields

strokedBtn : String -> Html msg
strokedBtn label = button [ class "mdc-button mdc-button--stroked mdc-button--dense mdc-button--primary" ] [ text label ]

months : List String
months =
  [ "Jan"
  , "Feb"
  , "Mar"
  , "Apr"
  , "May"
  , "Jun"
  , "Jul"
  , "Aug"
  , "Sep"
  , "Oct"
  , "Nov"
  , "Dec"
  ]

monthSelector : Html msg
monthSelector =
  List.map strokedBtn months |> formFields

memberForm : Member -> Html Msg
memberForm member =
    form [ class "mdc-card", style [ ("max-width", "500px"), ( "margin", "15px" ), ( "padding", "15px" ), ( "display", "inline-flex" ) ] ]
        [ textfield member.firstName "First Name" (onChangeFirstName member) |> formField
        , textfield member.lastName "Last Name" (onChangeLastName member) |> formField
        , textfield member.email "E-mail" (onChangeEmail member) |> formField
        , H.label [] [ text "Date of Birth"]
        , monthSelector
        , dialog
        , section [ class "mdc-card__actions" ]
            [ button [ class "mdc-button mdc-button--raised", onClick OnSubmit ] [ text "Submit" ] ]
        ]

dialog = H.aside
  [ A.id "my-mdc-dialog", class "mdc-dialog", A.attribute "role" "alertdialog" ]
  [ div
    [ class "mdc-dialog__surface" ]
    [ H.header
      [ class "mdc-dialog__header" ]
      [ H.h2
        [ class "mdc-dialog__header__title" ]
        [ text "Use Google's location service?" ]
      ]
    , section
      [ class "mdc-dialog__body" ]
      [ text "Let Google help apps determine location. This means sending anonymous location data to Google, even when no apps are running." ]
    , H.footer
      [ class "mdc-dialog__footer" ]
      [ button
        [ type_ "undefined", class "mdc-button mdc-dialog__footer__button mdc-dialog__footer__button--cancel" ]
        [ text "Decline" ]
      , button
        [ type_ "undefined", class "mdc-button mdc-dialog__footer__button mdc-dialog__footer__button--accept" ]
        [ text "Accept" ]
      ]
    ]
  , div
    [ class "mdc-dialog__backdrop" ]
    []
  ]
