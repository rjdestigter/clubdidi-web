module Members.Update exposing (update, onDate)

import Http
import Members.Model exposing (Member, Members, Model, Route(..))
import Members.Actions exposing (MembersAction(..), FilterBy(..))
import Members.Commands exposing (submit)
import Debug
import Ports exposing (onRenderDatepicker)

updateMembers : Result Http.Error Members -> Members
updateMembers response =
    case response of
        Ok members ->
            members

        Err e ->
          let
            foo = Debug.log "error" e
          in
            []


updateMember : Result Http.Error Member -> Members -> Members
updateMember response members =
    case response of
        Ok member ->
            member :: (List.filter (\{ id } -> id /= member.id) members)

        Err e ->
          let
            foo = Debug.log "error" e
          in
            members


receiveMembers : Result Http.Error Members -> Model -> ( Model, Cmd MembersAction )
receiveMembers response model =
    { model | members = updateMembers response } ! []


receiveMember : Result Http.Error Member -> Model -> ( Model, Cmd MembersAction )
receiveMember response model =
    { model | members = updateMember response model.members } ! []


onDate : String -> MembersAction
onDate date = OnChangeDateOfBirth date

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
            OnRoute route ->
              case route of
                Add -> { model | operation = Members.Model.blank, route = route } ! [onRenderDatepicker ""]
                Edit member -> { model | operation = member, route = route } ! [onRenderDatepicker member.dateOfBirth]
                Delete member -> { model | operation = member, route = route } ! []
                _ -> { model | route = route } ! []

            OnChange member ->
                { model | operation = member } ! []

            OnSubmit ->
                model
                    ! [ Members.Commands.submit token model.operation ]

            OnChangeDateOfBirth date ->
                { model | operation = { operation | dateOfBirth = date } } ! []

            OnAttend member ->
               model ! []
