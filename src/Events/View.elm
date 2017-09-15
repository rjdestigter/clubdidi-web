module Events.View exposing (render, menuItems)

import Html as H exposing (Html)
import Events.Model exposing (Model, Event, Route(..))
import Events.Actions exposing (EventsAction(..))
import Events.List
import Events.Form
import MDC

render : Maybe Event -> Model -> Html EventsAction
render event model = case model.route of
  Add -> Events.Form.render model.operation
  Edit event -> Events.Form.render model.operation
  Delete event -> H.text "WIP"
  Index -> Events.List.render event model




menuItems : Model -> List (Html EventsAction)
menuItems model =
  [ MDC.drawerItem (OnRoute Index) "view_list" (H.text "Events")
  , MDC.drawerItem (OnRoute Add) "add" (H.text "Add Event")
  ]
