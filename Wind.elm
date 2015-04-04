module Wind where

import Random (Seed, initialSeed, generate, float, int)
import Html (..)
import Html.Attributes (..)
import Signal
import Time (..)
import String (toInt)

type alias Model =
  { windDirection : Float
  , windSpeed : Float
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
  let (prob, seed') = generate (float 0 1) m.seed
      windSpeed' = (m.windSpeed * 0.9) + (prob * 0.1)
  in { m | seed <- seed', windSpeed <- windSpeed' }

updateWindDirection : Model -> Model
updateWindDirection m =
  let (prob, seed') = generate (float 0 360) m.seed
      windDirection' = (m.windDirection * 0.9) + (prob * 0.1)
  in { m | seed <- seed', windDirection <- windDirection' }

update : a -> Model -> Model
update _ = updateWind


transformAngle : Float -> String
transformAngle direction = "rotate(" ++ toString (round direction) ++ "deg)"
        
speedColor : Float -> String
speedColor speed = 
  let lum = round (100.0 * (1 - speed))
  in "hsl(240,100%," ++ toString lum ++ "%)"



view : Model -> Html
view model =
  p [id "wind",
  style [
          ("height", "22px"),
          ("width", "16px"),
          ("font-size", "20px"),
          ("transform", transformAngle model.windDirection), 
          ("color", speedColor model.windSpeed)
  ]] [text ("↑")]



bootstrap : Model -> Model
bootstrap m = 
  let (windDirection', seed') = generate (float 0 360) m.seed
  in { m | seed <- seed', windDirection <- windDirection' }


main : Signal Html
main = Signal.map view model

model : Signal Model
model = Signal.foldp update (bootstrap initialModel) delta

delta = Signal.map inSeconds (fps 10)
