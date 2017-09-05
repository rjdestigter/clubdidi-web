module MDC exposing (..)

import Html as H exposing (Html, aside, header, div, i, nav, a, text, section, span)
import Html.Attributes as A exposing (class, id, href, attribute)
import Html.Events exposing (onClick, onInput)


-- toolbar : Html alias

ariaHidden : H.Attribute msg
ariaHidden = attribute "aria-hidden" "true"

textfield : String -> String -> (String -> msg) -> Html msg
textfield value label onChange =
  div [ class "mdc-textfield mdc-textfield--box" ]
    [ H.input
      [ A.type_ "text"
      , A.id label
      , A.placeholder label
      , A.value value
      , class "mdc-textfield__input"
      , onInput onChange
      ] []
    -- , H.label [ A.for "label", class "mdc-textfield__label"] [ text label ]
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

menu : Bool -> List (Html msg) -> Html msg
menu toggled items =
  let
    classes = class
      (if toggled
      then "mdc-simple-menu mdc-simple-menu--open"
      else "mdc-simple-menu")
  in
    div [ classes ]
      [ H.ul [ class "mdc-simple-menu__items mdc-list"
           , A.attribute "role" "menu"
           , ariaHidden
           ] (List.map (\node -> H.li
           [ class "mdc-list-item"
            , A.attribute "role" "menuitem"
            , A.attribute "tabindex" "0"
           ] [node]) items)
      ]
