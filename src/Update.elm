port module Update exposing (update)

import Router.Model exposing (Route(..))
import Members.Update
import Events.Update
import Attendance.Update
import Model exposing (..)
import Login exposing (..)
import Members.Actions exposing (MembersAction(..))
import Events.Actions exposing (EventsAction(..))
import Attendance.Actions exposing (AttendanceAction)
import Attendance.Commands

authenticatedUpdate : Model -> (String -> ( m, Cmd a )) -> Maybe ( m, Cmd a )
authenticatedUpdate model update =
    case model.user of
        Authenticated token ->
            Just (update token)

        _ ->
            Nothing

updateMembers : MembersAction -> Model -> (Model, Cmd Msg)
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

updateEvents: EventsAction -> Model -> (Model, Cmd Msg)
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

updateAttendance: AttendanceAction -> Model -> (Model, Cmd Msg)
updateAttendance action model =
    let
        next =
            Attendance.Update.update action model.attendance |> authenticatedUpdate model
    in
        case next of
            Just ( attendance, commands ) ->
                { model | attendance = attendance } ! [ Cmd.map AttendanceApp commands ]

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
                case membersAction of
                  Members.Actions.OnAttend member ->
                    case (model.user, model.event) of
                      (Authenticated token, Just event) ->
                        model ! [Cmd.map AttendanceApp (Attendance.Commands.submit token event member)]
                      _ -> model ! []
                  _ ->
                    updateMembers membersAction model

            EventsApp eventsAction ->
                case (eventsAction, model.user) of
                  (Events.Actions.OnSelectEvent event, Authenticated token) ->
                    { model | event = Just event } ! [Cmd.map AttendanceApp (Attendance.Commands.fetch token)]
                  _ ->
                    updateEvents eventsAction model

            AttendanceApp attendanceAction ->
                updateAttendance attendanceAction model

            Model.OnChangeDate date ->
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

            UpdateUser user ->
                { model | user = user } ! []

            Model.OnSelectEvent event ->
                { model | event = Just event } ! []

port openDatepicker : String -> Cmd msg


port tokenReceived : String -> Cmd msg
