module MDC exposing (..)

import Html as H exposing (Html, aside, header, div, i, nav, a, text, section, span)
import Html.Attributes as A exposing (class, id, href, attribute)
import Html.Events as E exposing (onClick, onInput, onFocus)
import Svg as S
import Svg.Attributes as SA


-- toolbar : Html alias


ariaHidden : H.Attribute msg
ariaHidden =
    attribute "aria-hidden" "true"


textfield : String -> String -> (String -> msg) -> Html msg
textfield value label onChange =
    input "text" value label onChange


input : String -> String -> String -> (String -> msg) -> Html msg
input type_ value label onChange =
    div [ A.class "mdc-textfield mdc-textfield--fullwidth mdc-textfield--box", A.style [ ( "margin-bottom", "15px" ) ] ]
        [ H.input
            [ A.type_ type_
            , A.id label
            , A.placeholder label
            , A.value value
            , A.class "mdc-textfield__input"
            , E.onInput onChange
            ]
            []
        ]


datepicker : String -> String -> (String -> msg) -> Html msg
datepicker value label onChange =
    div [ A.class "mdc-textfield mdc-textfield--box", A.style [ ( "margin-bottom", "15px" ) ] ]
        [ H.input
            [ A.type_ "text"
            , A.id "date-input"
            , A.placeholder label
            , A.value value
            , A.class "mdc-textfield__input"
            , A.attribute "data-language" "en"
            , E.onInput onChange
            ]
            []
        ]


toolbar : String -> msg -> Html msg
toolbar title onToggle =
    header [ class "mdc-toolbar mdc-toolbar---theme-dark mdc-elevation--z1" ]
        [ div [ class "mdc-toolbar__row" ]
            [ section [ class "mdc-toolbar__section mdc-toolbar__section--align-start" ]
                [ a [ href "#", class "material-icons mdc-toolbar__icon--menu", onClick onToggle ]
                    [ text "menu" ]
                , span [ class "mdc-toolbar__title" ] [ text title ]
                ]
            ]
        ]


drawerItem : msg -> String -> Html msg -> Html msg
drawerItem msg icon child =
    a
        [ class "mdc-list-item mdc-persistent-drawer--selected", href "#", onClick msg ]
        [ i
            [ class "material-icons mdc-list-item__start-detail", ariaHidden ]
            [ text icon ]
        , child
        ]


persistentDrawer : Bool -> List (H.Html a) -> H.Html a
persistentDrawer toggled items =
    let
        classes =
            if toggled then
                class "mdc-persistent-drawer mdc-typography mdc-persistent-drawer--open"
            else
                class "mdc-persistent-drawer mdc-typography"
    in
        aside
            [ classes ]
            [ nav
                [ class "mdc-persistent-drawer__drawer" ]
                [ div
                    [ class "mdc-permanent-drawer__toolbar-spacer" ]
                    []
                , nav
                    [ id "icon-with-text-demo", class "mdc-persistent-drawer__content mdc-list" ]
                    items
                ]
            ]


formFields : List (Html msg) -> Html msg
formFields children =
    div [ class "mdc-form-field" ] children


formField : Html msg -> Html msg
formField child =
    child |> List.singleton |> formFields


checkbox : String -> Bool -> msg -> Html msg
checkbox label checked onToggle =
    formFields
        [ H.div
            [ A.class "mdc-checkbox", E.onClick onToggle ]
            [ H.input
                [ A.type_ "checkbox", A.id label, A.class "mdc-checkbox__native-control", A.checked checked ]
                []
            , H.div
                [ A.class "mdc-checkbox__background" ]
                [ S.svg
                    [ SA.class "mdc-checkbox__checkmark", SA.viewBox "0 0 24 24" ]
                    [ S.path
                        [ SA.class "mdc-checkbox__checkmark__path", SA.fill "none", SA.stroke "white", SA.d "M1.73,12.91 8.1,19.28 22.79,4.59" ]
                        []
                    ]
                , H.div
                    [ A.class "mdc-checkbox__mixedmark" ]
                    []
                ]
            ]
        , H.label
            [ A.for label ]
            [ H.text label ]
        ]


menu : Bool -> List (Html msg) -> Html msg
menu toggled items =
    let
        classes =
            class
                (if toggled then
                    "mdc-simple-menu mdc-simple-menu--open"
                 else
                    "mdc-simple-menu"
                )
    in
        H.div [ classes ]
            [ H.ul
                [ class "mdc-simple-menu__items mdc-list"
                , A.attribute "role" "menu"
                , ariaHidden
                ]
                (List.map
                    (\node ->
                        H.li
                            [ class "mdc-list-item"
                            , A.attribute "role" "menuitem"
                            , A.attribute "tabindex" "0"
                            ]
                            [ node ]
                    )
                    items
                )
            ]
