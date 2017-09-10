module Events.Submit exposing (submit)

import Http
import Json.Decode exposing (..)
import Date exposing (Date, Month(..))
import Json.Encode as Encode exposing (encode)
import GraphQL exposing (apply, maybeEncode)
import Events.Model exposing (Event)
import Events.Decoders exposing (eventDecoder)
import Events.Encoders exposing (dateEncoder)


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
                , ( "date", dateEncoder event.date )
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
