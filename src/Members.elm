module Members exposing (members)

import Http
import GraphQL
import Json.Encode exposing (object)
import Members.Model exposing (Members)
import Members.Decoders exposing (membersDecoder)


members : String -> Http.Request Members
members token =
    let
        graphQLQuery =
            """query members { members { id firstName lastName email dateOfBirth payed volunteer roles } }"""
    in
        let
            graphQLParams =
                object
                    []
        in
            GraphQL.query "GET" token graphQLQuery "members" graphQLParams membersDecoder
