module Salem.Wind where

import Html exposing (p, text, Html)
import Html.Attributes exposing (style)
import Random exposing (Seed, initialSeed, generate, float, int)
import Signal exposing ((<~))
import Time


type alias Direction = Int
type alias Speed = Float


type alias Model =
  { windDirection : Direction
  , windSpeed : Speed
  , seed : Seed
  }


init : Model
init =
  let m = { windSpeed = 0
          , windDirection = 0
          , seed = initialSeed 112358
          }
      (windDirection', seed') = generate (int 0 360) m.seed
  in { m | seed <- seed', windDirection <- windDirection' }


type Action = UpdateWind


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



update : Action -> Model -> Model
update _ = updateWindSpeed << updateWindDirection


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
  p [ style [ ("color", speedColor m.windSpeed) ] ]
    [ text <| (toString <| round m.windSpeed) ++ " knots"
    , p [ style <| arrowStyle m ]
        [ text "↑" ]
    ]


actions : Signal Action
actions =
  Signal.sampleOn (Time.fps 10) <| Signal.constant UpdateWind


model : Signal Model
model =
  Signal.foldp update init actions


main : Signal Html
main =
  view <~ model
