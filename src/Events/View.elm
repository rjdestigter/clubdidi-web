module Events.View exposing (render, menuItems)

import Html as H exposing (Html)
import Events.Model exposing (Model, Route(..))
import Events.Actions exposing (EventsAction(..))
import Events.List
import Events.Form
import MDC

render : Model -> Html EventsAction
render model = case model.route of
  Add -> Events.Form.render model.operation
  Edit event -> Events.Form.render model.operation
  Delete event -> H.text "WIP"
  Index -> Events.List.render model




menuItems : Model -> List (Html EventsAction)
menuItems model =
  [ MDC.drawerItem (OnRoute Index) "view_list" (H.text "Events")
  , MDC.drawerItem (OnRoute Add) "add" (H.text "Add Event")
  ]
