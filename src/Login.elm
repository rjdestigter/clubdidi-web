module Login exposing (..)

import Http exposing (header)
import Json.Encode as Encode
import Json.Decode as Decode
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import MDC exposing (..)
import Model exposing (Msg(..), User(..))

login : String -> String -> Cmd Msg
login username password =
    Http.request
        { method = "POST"
        , headers =
            [ (header "Accept" "application/json")
            -- , (header "Content-Type" "application/json")
            ]
        , url = "http://138.197.161.149:8080/token"
        , body = Http.jsonBody <| Encode.object [ ("email", Encode.string username), ("password", Encode.string password)]
        , expect = Http.expectJson (Decode.at ["token"] Decode.string)
        , timeout = Nothing
        , withCredentials = False
        } |> Http.send ReceiveToken

onChangeUsername : User -> String -> Msg
onChangeUsername user username =
  case user of
    Authenticated user -> User username "" |> UpdateUser
    User _ password -> User username password |> UpdateUser

onChangePassword : User -> String -> Msg
onChangePassword user password =
  case user of
    Authenticated user -> User "" password |> UpdateUser
    User username _ -> User username password |> UpdateUser

isAuthenticated : User -> Bool
isAuthenticated user =
  case user of
    Authenticated token -> String.isEmpty token |> not
    _ -> False

loginScreen : User -> Html Msg
loginScreen user =
  let
      (username, password) =
        case user of
          Authenticated _ -> ("", "")
          User username password -> (username, password)
  in
    H.div [ A.style [("height", "100%"), ("display", "flex"), ("alignItems", "center"), ("justifyContent", "center")]]
      [ H.form
        [ A.class "mdc-card", A.style [ ( "margin", "auto auto" ), ( "padding", "15px" ), ("width", "300px")] ]
        [ textfield username "Username" (onChangeUsername user)
        , textfield password "Password" (onChangePassword user)
        , H.section [ A.class "mdc-card__actions" ]
            [ H.button [ A.class "mdc-button mdc-button--raised", A.type_ "button", E.onClick Login ] [ H.text "Login" ] ]
        ]
      ]
