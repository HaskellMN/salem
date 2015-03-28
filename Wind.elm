module Wind where

import Random (Seed, initialSeed, generate, float)
import Html (Html, dl, dt, dd, text)
import Signal
import Time (..)

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
      windSpeed' = m.windSpeed + prob
  in { m | seed <- seed', windSpeed <- windSpeed' }

updateWindDirection : Model -> Model
updateWindDirection m =
  let (prob, seed') = generate (float 0 1) m.seed
      windDirection' = m.windDirection + prob
  in { m | seed <- seed', windDirection <- windDirection' }

update : a -> Model -> Model
update _ = updateWind





view : Model -> Html
view model =
  dl []
    [ dt [] [text "Wind Speed"]
    , dd [] [text (toString model.windSpeed)]
    , dt [] [text "Wind Direction"]
    , dd [] [text (toString model.windDirection)]
    ]





main : Signal Html
main = Signal.map view model

model : Signal Model
model = Signal.foldp update initialModel delta

delta = Signal.map inSeconds (fps 10)
