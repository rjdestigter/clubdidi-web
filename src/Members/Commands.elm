module Members.Commands exposing (..)

import Http
import Task
import Date
import Members
import Members.Model exposing (Member)
import Members.Submit as Submit
import Members.Actions exposing (MembersAction(..))


fetch : String -> Cmd MembersAction
fetch token =
    Members.members token
        |> Http.send ReceiveMembers


submit : String -> Member -> Cmd MembersAction
submit token member =
    let
        httpTask =
            Task.andThen (\date -> Submit.submit token date member |> Http.toTask) Date.now
    in
        Task.attempt ReceiveMember httpTask
