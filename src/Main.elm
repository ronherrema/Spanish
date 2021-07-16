module Main exposing (..)

import Array
import Browser
import Browser.Dom exposing (Viewport)
import Dict exposing (update)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Random exposing (..)
import Random.Array exposing (..)
import Words exposing (words)



-- MAIN


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }



-- MODEL


type Msg
    = ShowWords
    | NewRandomWordId Int


type alias Model =
    { randomNum : Int }


wordArray : Array.Array String
wordArray =
    Array.fromList words


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { randomNum = 0 }, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowWords ->
            ( model
            , Random.generate NewRandomWordId (Random.int 0 (Array.length wordArray))
            )

        NewRandomWordId id ->
            ( { model | randomNum = id - modBy 3 id }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    layout [ width fill, height fill, paddingEach { top = 20, bottom = 20, left = 700, right = 0 } ] <|
        column [ Font.size 48, Font.color (rgb255 0x77 0x77 0xFF), spacing 30 ]
            [ el [] (text (Maybe.withDefault "not known" (Array.get model.randomNum wordArray)))
            , el [] (text (Maybe.withDefault "not known" (Array.get (model.randomNum + 1) wordArray)))
            , el [] (text (Maybe.withDefault "not known" (Array.get (model.randomNum + 2) wordArray)))
            , Input.button [ Border.rounded 30, Border.width 1, padding 30 ] { label = text "New word", onPress = Just ShowWords }
            ]



-- SUBSCRIPTIONS
