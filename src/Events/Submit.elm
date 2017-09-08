module Events.Submit exposing (submit)

import GraphQL exposing (apply, maybeEncode)
import Http
import Json.Decode exposing (..)
import Json.Encode as Encode exposing (encode)
import Events exposing (Event, eventDecoder)
import Date exposing (Date, Month(..))


date : String -> String
date dob =
    if String.isEmpty dob |> not then
        let
            yyymmdd =
                dob |> String.split "/" |> List.reverse |> String.join "/"
        in
            case Date.fromString yyymmdd of
                Ok date ->
                    yyymmdd

                _ ->
                    ""
    else
        ""


dateToString : Date -> String
dateToString date =
    String.join "-" [ Date.year date |> toString, Date.month date |> monthToInt, Date.day date |> toString ]


submit : String -> Date -> Event -> Http.Request Event
submit token date event =
    let
        isNew =
            String.isEmpty event.id

        ( operationName, graphQLQuery, decoder ) =
            case isNew of
                True ->
                    ( "CreateEvent"
                    , """mutation CreateEvent($input: CreateEventInput!) { createEvent(input: $input) { event { id name date } } }"""
                    , submitEventDecoder "createEvent"
                    )

                False ->
                    ( "UpdateEvent"
                    , """mutation UpdateEvent($input: UpdateEventInput!) { updateEvent(input: $input) { event { id name date } } }"""
                    , submitEventDecoder "updateEvent"
                    )
    in
        let
            encoders =
                [ ( "name", Encode.string event.name )
                , ( "date", Encode.string event.date )
                ]

            graphQLParams =
                Encode.object
                    [ ( "input"
                      , Encode.object
                            (case isNew of
                                True ->
                                    encoders

                                False ->
                                    ( "id", Encode.string event.id ) :: encoders
                            )
                      )
                    ]
        in
            GraphQL.mutation token graphQLQuery operationName graphQLParams decoder


submitEventDecoder : String -> Decoder Event
submitEventDecoder key =
    at [ "data", key, "event" ] eventDecoder
