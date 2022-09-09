module Main exposing (..)

import Array
import Browser
import Browser.Dom exposing (Viewport, getViewport)
import Dict exposing (update)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes exposing (wrap)
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


viewPortInfo =
    Browser.Dom.getViewport


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
    ( { randomNum = 3 }, Cmd.none )



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
    layout [ width fill, height fill, padding 20 ] <|
        column [ width fill, height fill ]
            [ row [ height (px 100), width fill ]
                [ el [ padding 20, Background.color (rgb255 0x77 0x77 0xFF), width fill, Font.center, Font.color (rgb 1 1 1), Font.size 48 ]
                    (text "Spanish word drill")
                ]
            , row [ height (px 50) ]
                []
            , row [ width fill, height fill ]
                [ column
                    [ width (fillPortion 2), height fill ]
                    []
                , column [ Font.color (rgb255 0x77 0x77 0xFF), spacing 30, width (fillPortion 3), height fill ]
                    [ el [ Font.size 42 ]
                        (text (Maybe.withDefault "not known" (Array.get model.randomNum wordArray)))
                    , paragraph [ Font.size 38, paddingEach { left = 20, right = 0, top = 0, bottom = 0 } ]
                        [ text <| "- " ++ Maybe.withDefault "not known" (Array.get (model.randomNum + 1) wordArray) ]
                    , paragraph [ Font.size 38, Font.italic, paddingEach { left = 20, right = 0, top = 0, bottom = 0 } ]
                        [ text <| "- " ++ Maybe.withDefault "not known" (Array.get (model.randomNum + 2) wordArray) ]
                    , row [ height (px 40) ]
                        []
                    , Input.button [ Border.rounded 30, Border.width 3, padding 16, Font.size 28, Background.color (rgb255 0x77 0x77 0xFF), Font.color (rgb 1 1 1) ]
                        { label = text "New word", onPress = Just ShowWords }
                    ]
                ]
            ]



-- SUBSCRIPTIONS
