module Members.View exposing (render, menuItems)

import Html as H exposing (Html)
import Members.Model exposing (Model, Route(..))
import Members.Actions exposing (MembersAction(..))
import Members.List
import Members.Form
import MDC

render : Model -> List String -> Html MembersAction
render model attendees = case model.route of
  Add -> Members.Form.render model.operation
  Edit member -> Members.Form.render model.operation
  Delete member -> H.text "WIP"
  Index -> Members.List.render model attendees




menuItems : Model -> List (Html MembersAction)
menuItems model =
  [ MDC.drawerItem (OnRoute Index) "view_list" (H.text "Members")
  , MDC.drawerItem (OnRoute Add) "person_add" (H.text "Add Member")
  ]
