module Wind where

import Random (Seed, initialSeed)
import Html (Html, dl, dt, dd, text)
import Signal

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
updateWindSpeed m = m

updateWindDirection : Model -> Model
updateWindDirection m = m


type Action = NoOp

update : Action -> Model -> Model
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
model = Signal.foldp update initialModel (Signal.subscribe updates)

updates : Signal.Channel Action
updates = Signal.channel NoOp
