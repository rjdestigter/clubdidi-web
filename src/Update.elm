port module Update exposing (update)

import Router.Model exposing (Route(..))
import Members.Update
import Events.Update
import Model exposing (..)
import Login exposing (..)


authenticatedUpdate : Model -> (String -> ( m, Cmd a )) -> Maybe ( m, Cmd a )
authenticatedUpdate model update =
    case model.user of
        Authenticated token ->
            Just (update token)

        _ ->
            Nothing


updateMembers action model =
    let
        next =
            Members.Update.update action model.members |> authenticatedUpdate model
    in
        case next of
            Just ( members, commands ) ->
                { model | route = MembersRoute, members = members } ! [ Cmd.map MembersApp commands ]

            Nothing ->
                model ! []

updateEvents action model =
    let
        next =
            Events.Update.update action model.events |> authenticatedUpdate model
    in
        case next of
            Just ( events, commands ) ->
                { model | route = EventsRoute, events = events } ! [ Cmd.map EventsApp commands ]

            Nothing ->
                model ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    let
        { members, flags, events } =
            model
    in
        case action of
            MembersApp membersAction ->
                updateMembers membersAction model

            EventsApp eventsAction ->
                updateEvents eventsAction model

            OnChangeDate date ->
              let
                action2 = case model.route of
                  MembersRoute -> Members.Update.onDate date |> MembersApp
                  EventsRoute -> Events.Update.onDate date |> EventsApp
              in
                update action2 model

            Login ->
                case model.user of
                    Authenticated _ ->
                        { model | user = User "" "" } ! []

                    User username password ->
                        model ! [ login username password ]

            ReceiveToken (Ok token) ->
                { model | user = Authenticated token }
                    ! [ tokenReceived token

                      -- , Members.members token
                      --       |> Http.send ReceiveMembers
                      ]

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

            -- OnRoute route ->
            --     case route of
            --         AddMember ->
            --             { model | route = route } ! [ openDatepicker "" ]
            --
            --         -- [ openDatepicker mutate.dateOfBirth ]
            --         EditMember maybeMember ->
            --             model ! []
            --
            --         -- case maybeMember of
            --         --     Just member ->
            --         --         { model | route = route, mutate = member } ! [ openDatepicker member.dateOfBirth ]
            --         --
            --         --     Nothing ->
            --         --         { model | route = route } ! [ openDatepicker mutate.dateOfBirth ]
            --         _ ->
            --             { model | route = MembersList } ! []

            UpdateUser user ->
                { model | user = user } ! []


port openDatepicker : String -> Cmd msg


port tokenReceived : String -> Cmd msg
