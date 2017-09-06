module MembersList exposing (membersView)

import Model exposing (..)
import Members exposing (Members, Member)
import Html exposing (Html, table, tr, td, text)
import Html.Attributes exposing (style, class, colspan)
import Html.Events exposing (onClick)
import Date
import MDC exposing (textfield)


cell : List (Html Msg) -> Html Msg
cell =
    td [ style [ ( "padding", "10px" ), ( "white-space", "nowrap" ) ] ]


dob : String -> String
dob value =
    case Date.fromString value of
        Ok date ->
            String.join "-" [ Date.day date |> toString, Date.month date |> toString, Date.year date |> toString ]

        _ ->
            ""


memberRow : Member -> Html Msg
memberRow member =
    tr
        [ style
            [ ( "box-shadow", "0px 1px 1px rgba(0,0,0,0.1)" )
            , ( "padding", "15px" )
            , ( "border", "1px solid whitesmoke" )
            ]
        , onClick (OnEdit member)
        ]
        [ cell [ text member.firstName ]
        , cell [ text member.lastName ]
        , cell [ text member.email ]
        , cell [ member.dateOfBirth |> dob |> text ]
        , cell
            [ (if member.payed then
                "Yes"
               else
                "No"
              )
                |> text
            ]
        , td [ style [ ( "padding", "5px" ) ] ]
            [ (if member.volunteer then
                "Yes"
               else
                "No"
              )
                |> text
            ]
        , td [ style [ ( "padding", "5px" ) ] ]
            [ (if member.volunteer then
                member.roles
                    |> List.map toString
                    |> String.join ", "
               else
                ""
              )
                |> text
            ]
        ]


onFilter : (String -> FilterBy) -> String -> Msg
onFilter filterBy value =
    value |> filterBy |> OnFilter


stringFilterInput : (String -> FilterBy) -> String -> String -> Html Msg
stringFilterInput filterBy value label =
    textfield value label (filterBy |> onFilter)


filterCell : Html Msg -> Html Msg
filterCell child =
    td [ style [ ( "padding", "15px" ) ] ] [ child ]


filterRow : Filters -> Html Msg
filterRow filters =
    tr [ class "mdc-theme--secondary-bg" ]
        [ stringFilterInput ByFirstName filters.firstName "First Name" |> filterCell
        , stringFilterInput ByLastName filters.lastName "Last Name" |> filterCell
        , td [ colspan 5 ] []
        ]


membersView : Members -> Filters -> Html Msg
membersView members filters =
    members
        |> List.map memberRow
        |> \rows ->
            filterRow filters
                :: rows
                |> table [ style [ ( "width", "100%" ), ( "border-collapse", "collapse" ) ] ]
