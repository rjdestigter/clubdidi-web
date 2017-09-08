port module Main exposing (..)

import Html as Html
import Html exposing (Html, node, div, header, section, a, span, ul, li, button, text, table, tr, td)
import Html.Attributes as Attr exposing (attribute, class, href, style)
import Members.Model exposing (Member, Members, Role)
import Members.Commands
import Events.Model
import MDC exposing (..)
import Model exposing (..)
import Members.List exposing (membersView)
import Members.Form exposing (memberForm)
import Login exposing (..)
import Update


main : Program { token : String } Model Msg
main =
    Html.programWithFlags { init = init, update = update, view = view, subscriptions = subscriptions }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- changeDateValue UpdateDateValue


initialModel : String -> Model
initialModel token =
    { members = Members.Model.initial
    , events = Events.Model.initial
    , flags =
        { menu = True
        }
    , route = MembersList
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
                [ Cmd.map MembersRoute (Members.Commands.fetch token) ]


toolbar : Html Msg
toolbar =
    MDC.toolbar "Club Didi" (OnToggleFlag Menu)


drawer : Bool -> Html Msg
drawer toggled =
    persistentDrawer toggled
        [ drawerItem (OnRoute MembersList) "view_list" (text "Members")
        , drawerItem (OnRoute AddMember) "person_add" (text "Add Member")

        -- , drawerItem (OnRoute (EditMember Nothing)) "mode_edit" (text "Edit Member")
        -- , drawerItem (OnRoute DeleteMember) "delete" (text "Delete Member")
        , divider
        , drawerItem (OnRoute EventsList) "event" (text "Events")
        ]


routedView : Model -> Html Msg
routedView model =
    case model.route of
        MembersList ->
            membersView model.members
                |> Html.map MembersRoute

        EditMember _ ->
            memberForm model.members.operation |> Html.map MembersRoute

        AddMember ->
            memberForm model.members.operation |> Html.map MembersRoute

        _ ->
            text "WIP"


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
        [ drawer model.flags.menu
        , div
            [ style [ ( "flex", "1 1 auto" ) ]
            ]
            [ toolbar, routedView model ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update =
    Update.update


port changeDateValue : (String -> msg) -> Sub msg
