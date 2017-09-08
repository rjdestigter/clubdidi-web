port module Main exposing (..)

import Html as Html
import Html exposing (Html, node, div, header, section, a, span, ul, li, button, text, table, tr, td)
import Html.Attributes as Attr exposing (attribute, class, href, style)
import Http
import Members exposing (Member, Members, Role)
import Regex
import MDC exposing (..)
import Model exposing (..)
import MembersList exposing (membersView)
import Form exposing (memberForm)
import Debug
import SubmitMember
import Task
import Date
import Login exposing (..)

main : Program Never Model Msg
main =
    Html.program { init = init, update = update, view = view, subscriptions = subscriptions }


subscriptions : Model -> Sub Msg
subscriptions model =
    changeDateValue UpdateDateValue


blankMember : Member
blankMember =
    Member "" "" "" "" "" False False []


initialModel : Model
initialModel =
    { members = []
    , filters =
        { firstName = ""
        , lastName = ""
        , volunteer = Nothing
        , roles = []
        }
    , flags =
        { menu = True
        }
    , mutate = blankMember
    , route = MembersList
    , user = User "" ""
    }


init : ( Model, Cmd Msg )
init = initialModel ! []


toolbar : Html Msg
toolbar =
    MDC.toolbar "Club Didi" (OnToggleFlag Menu)


test : String -> String -> Bool
test pattern input =
    String.isEmpty input
        || Regex.contains
            (pattern |> String.toLower |> Regex.regex)
            (String.toLower input)


filterMembers : Filters -> Member -> Bool
filterMembers filters member =
    test filters.firstName member.firstName
        && test filters.lastName member.lastName


getMembers : Model -> Members
getMembers { members, filters } =
    members
        |> List.filter (filterMembers filters)


drawer : Bool -> Html Msg
drawer toggled =
    persistentDrawer toggled
        [ drawerItem (OnRoute MembersList) "view_list" (text "Home")
        , drawerItem (OnRoute AddMember) "person_add" (text "Add Member")
        , drawerItem (OnRoute (EditMember Nothing)) "mode_edit" (text "Edit Member")
        , drawerItem (OnRoute DeleteMember) "delete" (text "Delete Member")
        ]


routedView : Model -> Html Msg
routedView model =
    case model.route of
        MembersList ->
            membersView (getMembers model) model.filters

        EditMember _ ->
            memberForm model.mutate

        AddMember ->
            memberForm model.mutate

        _ ->
            text "WIP"

view : Model -> Html Msg
view model =
    case isAuthenticated model.user of
      True -> authenticatedView model
      False -> loginScreen model.user

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
update action model =
    let
        { members, filters, flags, mutate } =
            model
    in
        case action of
            ReceiveMembers (Ok res) ->
                ( { model | members = res }, Cmd.none )

            ReceiveMembers (Err e) ->
                let
                    foo =
                        Debug.log "Oops" e
                in
                    ( model, Cmd.none )

            ReceiveMember (Ok member) ->
                ( { model | members = member :: (List.filter (\{ id } -> id /= member.id) members) }, Cmd.none )

            ReceiveMember (Err e) ->
                let
                    foo =
                        Debug.log "Oops" e
                in
                    ( model, Cmd.none )

            Login ->
              case model.user of
                Authenticated _ ->
                  { model | user = User "" "" } ! []
                User username password ->
                  model ! [login username password]

            ReceiveToken (Ok token) ->
                { model | user = Authenticated token } ! [Members.members token
                    |> Http.send ReceiveMembers]

            ReceiveToken (Err e) ->
                let
                    foo =
                        Debug.log "Oops" e
                in
                    ( model, Cmd.none )

            OnToggleFlag flag ->
                case flag of
                    Menu ->
                        ( { model | flags = { flags | menu = not flags.menu } }, Cmd.none )

            OnFilter filterBy ->
                case filterBy of
                    ByFirstName value ->
                        ( { model | filters = { filters | firstName = value } }, Cmd.none )

                    ByLastName value ->
                        ( { model | filters = { filters | lastName = value } }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )

            OnEdit member ->
                { model | mutate = member, route = EditMember (Just member) } ! [ openDatepicker member.dateOfBirth ]

            OnChange member ->
                { model | mutate = member } ! []

            OnSubmit ->
                case model.user of
                  Authenticated token ->
                    model
                        ! [ let
                                httpTask =
                                    Task.andThen (\date -> SubmitMember.submit token date model.mutate |> Http.toTask) Date.now
                            in
                                Task.attempt ReceiveMember httpTask
                          ]
                  _ ->
                    model ! []

            OnRoute route ->
                case route of
                    AddMember ->
                        { model | route = route, mutate = blankMember } ! [ openDatepicker mutate.dateOfBirth ]

                    EditMember maybeMember ->
                        case maybeMember of
                            Just member ->
                                { model | route = route, mutate = member } ! [ openDatepicker member.dateOfBirth ]

                            Nothing ->
                                { model | route = route } ! [ openDatepicker mutate.dateOfBirth ]

                    _ ->
                        { model | route = MembersList } ! []

            OpenDatePicker date ->
                model ! [ openDatepicker date ]

            UpdateDateValue dateString ->
                { model | mutate = { mutate | dateOfBirth = dateString } } ! []

            UpdateUser user ->
                { model | user = user } ! []

port openDatepicker : String -> Cmd msg


port changeDateValue : (String -> msg) -> Sub msg
