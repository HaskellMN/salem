module Wind where

import Random exposing (Seed, initialSeed, generate, float, int)
import Html exposing (p, text, Html)
import Html.Attributes exposing (id, style)
import Signal
import Time exposing (..)
import String exposing (toInt)


type alias Direction = Int
type alias Speed = Float


type alias Model =
  { windDirection : Direction
  , windSpeed : Speed
  , seed : Seed
  }


initialModel : Model
initialModel =
  { windSpeed = 0
  , windDirection = 0
  , seed = initialSeed 112358
  }


updateWind : Model -> Model
updateWind = updateWindSpeed << updateWindDirection


updateWindSpeed : Model -> Model
updateWindSpeed m =
  let (prob, seed') = generate (float -1 10) m.seed
      windSpeed' = max 0 <| m.windSpeed `updateWindSpeedBy` prob
  in { m | seed <- seed', windSpeed <- windSpeed' }


updateWindSpeedBy : Speed -> Speed -> Speed
updateWindSpeedBy x d = (9*x + d) / 10


updateWindDirection : Model -> Model
updateWindDirection m =
  let (prob, seed') = generate (int -5 5) m.seed
      windDirection' = (m.windDirection + prob) % 360
  in { m | seed <- seed', windDirection <- windDirection' }


update : a -> Model -> Model
update _ = updateWind


transformAngle : Int -> String
transformAngle direction = "rotate(" ++ toString direction ++ "deg)"


speedColor : Float -> String
speedColor speed =
  let lum = max 0 <| round <| 100 - (speed * 10)
  in "hsl(240,100%," ++ toString lum ++ "%)"


arrowStyle : Model -> List (String, String)
arrowStyle m =
  [ ("height", "22px")
  , ("width", "16px")
  , ("font-size", "20px")
  , ("transform", transformAngle m.windDirection)
  ]


view : Model -> Html
view m =
  p [ id "wind"
    , style [ ("color", speedColor m.windSpeed) ] ]
    [ text <| (toString <| round m.windSpeed) ++ " knots"
    , p [ style <| arrowStyle m ]
        [ text "↑" ]
    ]


bootstrap : Model -> Model
bootstrap m =
  let (windDirection', seed') = generate (int 0 360) m.seed
  in { m | seed <- seed', windDirection <- windDirection' }


main : Signal Html
main = Signal.map view model


model : Signal Model
model = Signal.foldp update (bootstrap initialModel) delta


delta : Signal Float
delta = Signal.map inSeconds (fps 10)
