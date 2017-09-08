module Events.Decoders exposing (eventsDecoder, eventDecoder)

import Events.Model exposing (Events, Event)
import Json.Decode exposing (Decoder, map3, field, string, at, list)


eventDecoder : Decoder Event
eventDecoder =
    map3 Event
        (field "id" string)
        (field "name" string)
        (field "date" string)


eventsDecoder : Decoder Events
eventsDecoder =
    at [ "data", "events" ] (list eventDecoder)
