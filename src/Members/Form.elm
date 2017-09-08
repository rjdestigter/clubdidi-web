module Members.Form exposing (memberForm)

import Members.Model exposing (Member, Role(..))
import Members.Actions exposing (MembersAction(..))
import Html as H exposing (Html, form, div, text, section, button)
import Html.Attributes as A exposing (class, style, type_)
import Html.Events as E exposing (onClick)
import MDC exposing (..)


onChangeFirstName : Member -> String -> MembersAction
onChangeFirstName member value =
    OnChange { member | firstName = value }


onChangeLastName : Member -> String -> MembersAction
onChangeLastName member value =
    OnChange { member | lastName = value }


onChangeEmail : Member -> String -> MembersAction
onChangeEmail member value =
    OnChange { member | email = value }


onChangeDOB : Member -> String -> MembersAction
onChangeDOB member value =
    OnChange { member | dateOfBirth = value }


onToggleRole : Role -> Member -> MembersAction
onToggleRole role member =
    let
        nextRoles =
            case List.member role member.roles of
                True ->
                    List.filter (\r -> r /= role) member.roles

                False ->
                    role :: member.roles
    in
        OnChange { member | roles = nextRoles }


strokedBtn : String -> Html msg
strokedBtn label =
    button [ class "mdc-button mdc-button--stroked mdc-button--dense mdc-button--primary" ] [ text label ]


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


radio : String -> Bool -> Html msg
radio label checked =
    formFields
        [ H.div
            [ class "mdc-radio" ]
            [ H.input
                [ class "mdc-radio__native-control", A.type_ "radio", A.id "radio-1", A.name "radios", A.checked checked ]
                []
            , H.div
                [ class "mdc-radio__background" ]
                [ H.div
                    [ class "mdc-radio__outer-circle" ]
                    []
                , H.div
                    [ class "mdc-radio__inner-circle" ]
                    []
                ]
            ]
        , H.label
            [ A.id label, A.for label ]
            [ H.text label ]
        ]


memberForm : Member -> Html MembersAction
memberForm member =
    form [ class "mdc-card", style [ ( "max-width", "800px" ), ( "margin", "15px" ), ( "padding", "15px" ) ] ]
        [ textfield member.firstName "First Name" (onChangeFirstName member) |> formField
        , textfield member.lastName "Last Name" (onChangeLastName member) |> formField
        , textfield member.email "E-mail" (onChangeEmail member) |> formField
        , datepicker member.dateOfBirth "Date of Birth" (onChangeDOB member) |> formField
        , div []
            [ H.label [] [ text "Volunteer" ]
            , div [] [ checkbox "Front of House" (List.member FrontOfHouse member.roles) (onToggleRole FrontOfHouse member) ]
            , div [] [ checkbox "Bar Tending" (List.member BarTending member.roles) (onToggleRole BarTending member) ]
            , div [] [ checkbox "Security" (List.member Security member.roles) (onToggleRole Security member) ]
            , div [] [ checkbox "Floating" (List.member Floating member.roles) (onToggleRole Floating member) ]
            , div [] [ checkbox "Set-up" (List.member SetUp member.roles) (onToggleRole SetUp member) ]
            , div [] [ checkbox "Tech" (List.member Tech member.roles) (onToggleRole Tech member) ]
            , div [] [ checkbox "Maintenance" (List.member Maintenance member.roles) (onToggleRole Maintenance member) ]
            , div [] [ checkbox "Cleaning" (List.member Cleaning member.roles) (onToggleRole Cleaning member) ]
            , div [] [ checkbox "Whatever Mama needs" (List.member WhateverMamaNeeds member.roles) (onToggleRole WhateverMamaNeeds member) ]
            ]
        , section [ class "mdc-card__actions" ]
            [ button [ class "mdc-button mdc-button--raised", type_ "button", onClick OnSubmit ] [ icon "save" ] ]
        ]
