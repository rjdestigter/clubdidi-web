module Events exposing (events)

import GraphQL exposing (apply, maybeEncode)
import Http
import Json.Encode exposing (encode)
import Events.Model exposing (Events, Event)
import Events.Decoders exposing (eventsDecoder)


events : String -> Http.Request Events
events token =
    let
        graphQLQuery =
            """query events { events { id name date } }"""
    in
        let
            graphQLParams =
                Json.Encode.object
                    []
        in
            GraphQL.query "GET" token graphQLQuery "events" graphQLParams eventsDecoder
