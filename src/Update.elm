port module Update exposing (update)

import Members.Update
import Members.Model exposing (Member, Members)
import Members.Actions exposing (MembersAction)
import Members
import Model exposing (..)
import Http
import Login exposing (..)
import Task
import Members.Submit
import Date


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
                { model | members = members } ! [ Cmd.map MembersRoute commands ]

            Nothing ->
                model ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    let
        { members, flags, events } =
            model
    in
        case action of
            MembersRoute membersAction ->
                updateMembers membersAction model

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

            OnRoute route ->
                case route of
                    AddMember ->
                        { model | route = route } ! [ openDatepicker "" ]

                    -- [ openDatepicker mutate.dateOfBirth ]
                    EditMember maybeMember ->
                        model ! []

                    -- case maybeMember of
                    --     Just member ->
                    --         { model | route = route, mutate = member } ! [ openDatepicker member.dateOfBirth ]
                    --
                    --     Nothing ->
                    --         { model | route = route } ! [ openDatepicker mutate.dateOfBirth ]
                    _ ->
                        { model | route = MembersList } ! []

            UpdateUser user ->
                { model | user = user } ! []


port openDatepicker : String -> Cmd msg


port tokenReceived : String -> Cmd msg
