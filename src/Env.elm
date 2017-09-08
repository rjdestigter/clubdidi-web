module Env exposing (..)


type Host
    = Local
    | Remote


localhost : String
localhost =
    "localhost:8080"


digitalocean : String
digitalocean =
    "138.197.161.149:8080"


path : String
path =
    "/graphql"


url : Host -> String
url host =
    case host of
        Local ->
            String.join "" [ "http://", localhost, path ]

        Remote ->
            String.join "" [ "http://", digitalocean, path ]


local : String
local =
    url Local


remote : String
remote =
    url Remote


current : String
current =
    local
