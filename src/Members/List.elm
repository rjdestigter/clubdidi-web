module Members.List exposing (render)

import Members.Model exposing (Model, Members, Member, Filters, Route (..))
import Members.Actions exposing (MembersAction(..), FilterBy(..))
import Html exposing (Html, table, tr, td, text, div)
import Html.Attributes exposing (style, class, colspan)
import Html.Events exposing (onClick)
import Date
import MDC exposing (textfield, icon)
import Utils exposing (test)


cell : List (Html MembersAction) -> Html MembersAction
cell =
    td [ style [ ( "padding", "10px" ), ( "white-space", "nowrap" ) ] ]


dob : String -> String
dob value =
    case Date.fromString value of
        Ok date ->
            String.join "-" [ Date.day date |> toString, Date.month date |> toString, Date.year date |> toString ]

        _ ->
            ""


filterMembers : Filters -> Member -> Bool
filterMembers filters member =
    test filters.firstName member.firstName
        && test filters.lastName member.lastName


getMembers : Filters -> Members -> Members
getMembers filters members =
    members
        |> List.filter (filterMembers filters)


memberRow : Member -> Html MembersAction
memberRow member =
    tr
        [ style
            [ ( "box-shadow", "0px 1px 1px rgba(0,0,0,0.1)" )
            , ( "padding", "15px" )
            , ( "border", "1px solid whitesmoke" )
            ]

        -- , onClick (OnEdit member)
        ]
        [ cell [ text member.firstName ]
        , cell [ text member.lastName ]
        , cell [ text member.email ]
        , cell [ member.dateOfBirth |> dob |> text ]
        , cell
            [ (if member.payed then
                text ""
               else
                icon "money_off"
              )
            ]
        , td [ style [ ( "padding", "5px" ) ] ]
            [ (if member.volunteer then
                icon "check"
               else
                text ""
              )
            ]
        , td [ style [ ( "padding", "5px" ) ] ]
            [
              div [ onClick (OnRoute (Edit member))] [ icon "mode_edit"]
            ]
        , td [ style [ ( "padding", "5px" ) ] ]
            [
              div [ onClick (OnRoute (Delete member))] [ icon "delete"]
            ]
        ]


onFilter : (String -> FilterBy) -> String -> MembersAction
onFilter filterBy value =
    value |> filterBy |> OnFilter


stringFilterInput : (String -> FilterBy) -> String -> String -> Html MembersAction
stringFilterInput filterBy value label =
    textfield value label (filterBy |> onFilter)


filterCell : Html MembersAction -> Html MembersAction
filterCell child =
    td [ style [ ( "padding", "15px" ) ] ] [ child ]


filterRow : Filters -> Html MembersAction
filterRow filters =
    tr [ class "mdc-theme--secondary-bg" ]
        [ stringFilterInput ByFirstName filters.firstName "First Name" |> filterCell
        , stringFilterInput ByLastName filters.lastName "Last Name" |> filterCell
        , td [ colspan 5 ] []
        ]


render : Model -> Html MembersAction
render { members, filters } =
    members
        |> getMembers filters
        |> List.map memberRow
        |> \rows ->
            filterRow filters
                :: rows
                |> table [ style [ ( "width", "100%" ), ( "border-collapse", "collapse" ) ] ]
