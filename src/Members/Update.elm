module Members.Update exposing (update)

import Http
import Task
import Date
import Members.Model exposing (Member, Members, Model)
import Members.Actions exposing (MembersAction(..), FilterBy(..))
import Members.Submit
import Members.Commands exposing (submit)


updateMembers : Result Http.Error Members -> Members
updateMembers response =
    case response of
        Ok members ->
            members

        Err e ->
            []


updateMember : Result Http.Error Member -> Members -> Members
updateMember response members =
    case response of
        Ok member ->
            member :: (List.filter (\{ id } -> id /= member.id) members)

        Err e ->
            members


receiveMembers : Result Http.Error Members -> Model -> ( Model, Cmd MembersAction )
receiveMembers response model =
    { model | members = updateMembers response } ! []


receiveMember : Result Http.Error Member -> Model -> ( Model, Cmd MembersAction )
receiveMember response model =
    { model | members = updateMember response model.members } ! []


update : MembersAction -> Model -> String -> ( Model, Cmd MembersAction )
update action model token =
    let
        { members, filters, operation } =
            model
    in
        case action of
            ReceiveMembers payload ->
                receiveMembers payload model

            ReceiveMember payload ->
                receiveMember payload model

            OnFilter filterBy ->
                case filterBy of
                    ByFirstName value ->
                        ( { model | filters = { filters | firstName = value } }, Cmd.none )

                    ByLastName value ->
                        ( { model | filters = { filters | lastName = value } }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )

            OnChange member ->
                { model | operation = member } ! []

            OnSubmit ->
                model
                    ! [ Members.Commands.submit token model.operation ]

            UpdateDateValue dateString ->
                { model | operation = { operation | dateOfBirth = dateString } } ! []
