port module Main exposing (main)

import Html exposing (Html, text, div, button, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (type_, value)
import Json.Encode exposing (Value)
import Json.Encode as Encode exposing (encode, int, object)
import Json.Decode as Decode
import Debug exposing (log)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- TYPES


type alias Model =
    { message : String
    }


type Msg
    = UpdateStr String
    | SendToSubscribers String



-- MODEL


init : ( Model, Cmd Msg )
init =
    ( { message = "Elm program is ready. Get started!" }, Cmd.none )



----- UPDATE


port toSubscribers : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateStr str ->
            ( { model | message = str }, Cmd.none )

        SendToSubscribers str ->
            log ("value" ++ str) ( model, toSubscribers (messageToSubscribers str) )


messageToSubscribers : String -> String
messageToSubscribers text =
    let
        value =
            String.toInt text |> Result.toMaybe |> Maybe.withDefault 0

        result =
            Encode.object
                [ ( "step", Encode.int value )
                ]
    in
        Encode.encode 0 result



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "number", onInput UpdateStr, value model.message ] []
        , div [] [ text model.message ]
        , button
            [ onClick (SendToSubscribers model.message) ]
            [ text "Send To Subscribers" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
