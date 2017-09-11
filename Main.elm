port module Main exposing (..)

import Html as Html
import Html exposing (Html, node, div, header, section, a, span, ul, li, button, text, table, tr, td)
import Html.Attributes as Attr exposing (attribute, class, href, style)
import Members.Model
import Router.Model exposing(..)
import Members.Commands
import Events.Model
import MDC exposing (..)
import Model exposing (..)
import Members.View
import Events.View
import Login exposing (..)
import Update


main : Program { token : String } Model Msg
main =
    Html.programWithFlags { init = init, update = update, view = view, subscriptions = subscriptions }


subscriptions : Model -> Sub Msg
subscriptions model = onChangeDate OnChangeDate


initialModel : String -> Model
initialModel token =
    { members = Members.Model.initial
    , events = Events.Model.initial
    , attendance = []
    , flags =
        { menu = True
        }
    , route = MembersRoute
    , user =
        if String.isEmpty token then
            User "" ""
        else
            Authenticated token
    }


init : { token : String } -> ( Model, Cmd Msg )
init { token } =
    (initialModel token)
        ! case String.isEmpty token of
            True ->
                []

            False ->
                [ Cmd.map MembersApp (Members.Commands.fetch token) ]


toolbar : Html Msg
toolbar =
    MDC.toolbar "Club Didi" (OnToggleFlag Menu)


drawer : Bool -> Model -> Html Msg
drawer toggled model =
    List.concat
    [ Members.View.menuItems model.members |> List.map (Html.map MembersApp)
    , [ divider ]
    , Events.View.menuItems model.events |> List.map (Html.map EventsApp)
    , [ divider ]
    ]
     |> persistentDrawer toggled


routedView : Model -> Html Msg
routedView model =
    case model.route of
        MembersRoute ->
            Members.View.render model.members
                |> Html.map MembersApp

        EventsRoute ->
            Events.View.render model.events
                |> Html.map EventsApp


view : Model -> Html Msg
view model =
    case isAuthenticated model.user of
        True ->
            authenticatedView model

        False ->
            loginScreen model.user


authenticatedView : Model -> Html Msg
authenticatedView model =
    div
        [ class "mdc-theme--background mdc-typography mdc-typography--body1"
        , style
            [ ( "position", "absolute" )
            , ( "top", "0" )
            , ( "right", "0" )
            , ( "left", "0" )
            , ( "bottom", "0" )
            , ( "display", "flex" )
            ]
        ]
        [ drawer model.flags.menu model
        , div
            [ style [ ( "flex", "1 1 auto" ) ]
            ]
            [ toolbar, routedView model ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update =
    Update.update


port onChangeDate : (String -> msg) -> Sub msg
