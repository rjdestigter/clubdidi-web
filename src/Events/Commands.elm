module Events.Commands exposing (..)

import Http
import Task
import Date
import Events
import Events.Model exposing (Event)
import Events.Submit as Submit
import Events.Actions exposing (EventsAction(..))


fetch : String -> Cmd EventsAction
fetch token =
    Events.events token
        |> Http.send ReceiveEvents


submit : String -> Event -> Cmd EventsAction
submit token event =
    let
        httpTask =
            Task.andThen (\date -> Submit.submit token date event |> Http.toTask) Date.now
    in
        Task.attempt ReceiveEvent httpTask
