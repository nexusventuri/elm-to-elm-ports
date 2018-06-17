port module Subscriber exposing (main)

import Html exposing (Html, text, div, button, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (type_, value)
import Json.Encode exposing (Value)
import Json.Decode as Decode
import Debug exposing (log)


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- TYPES


type alias Flags =
    { startingValue : Int
    }


type alias Model =
    { count : Int
    }


type Msg
    = IncrementValue Int



-- MODEL


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { count = flags.startingValue }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IncrementValue increment ->
            ( { model | count = model.count + increment }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text ("value: " ++ toString model.count) ]



-- SUBSCRIPTIONS


port fromMain : (String -> msg) -> Sub msg


decodeMessage : String -> Msg
decodeMessage x =
    let
        result =
            Decode.decodeString messageFromMainDecoder x
    in
        case result of
            Ok v ->
                IncrementValue v.step

            Err e ->
                log ("error:" ++ e) None


type alias MessageFromMain =
    { step : Int }


messageFromMainDecoder : Decode.Decoder MessageFromMain
messageFromMainDecoder =
    Decode.map MessageFromMain (Decode.field "step" Decode.int)


subscriptions : Model -> Sub Msg
subscriptions _ =
    fromMain (decodeMessage)
