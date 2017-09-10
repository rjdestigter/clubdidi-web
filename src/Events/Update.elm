module Events.Update exposing (update, onDate)

import Http
import Events.Model exposing (Event, Events, Model, Route(..))
import Events.Actions exposing (EventsAction(..), FilterBy(..))
import Events.Commands exposing (submit)
import Debug
import Ports exposing (onRenderDatepicker)

updateEvents : Result Http.Error Events -> Events
updateEvents response =
    case response of
        Ok events ->
            events

        Err e ->
          let
            foo = Debug.log "error" e
          in
            []


updateEvent : Result Http.Error Event -> Events -> Events
updateEvent response events =
    case response of
        Ok event ->
            event :: (List.filter (\{ id } -> id /= event.id) events)

        Err e ->
          let
            foo = Debug.log "error" e
          in
            events


receiveEvents : Result Http.Error Events -> Model -> ( Model, Cmd EventsAction )
receiveEvents response model =
    { model | events = updateEvents response } ! []


receiveEvent : Result Http.Error Event -> Model -> ( Model, Cmd EventsAction )
receiveEvent response model =
    { model | events = updateEvent response model.events } ! []

onDate : String -> EventsAction
onDate date = OnChangeDate date

update : EventsAction -> Model -> String -> ( Model, Cmd EventsAction )
update action model token =
    let
        { events, filters, operation } =
            model
    in
        case action of
            ReceiveEvents payload ->
                receiveEvents payload model

            ReceiveEvent payload ->
                receiveEvent payload model

            OnFilter filterBy ->
                case filterBy of
                    ByName value ->
                        ( { model | filters = { filters | name = value } }, Cmd.none )

            OnRoute route ->
              case route of
                Add -> { model | operation = Events.Model.blank, route = route } ! [onRenderDatepicker ""]
                Edit event -> { model | operation = event, route = route } ! [onRenderDatepicker event.date]
                Delete event -> { model | operation = event, route = route } ! []
                _ -> { model | route = route } ! []

            OnChange event ->
                { model | operation = event } ! []

            OnSubmit ->
                model
                    ! [ Events.Commands.submit token model.operation ]

            OnChangeDate date ->
                { model | operation = { operation | date = date } } ! []
