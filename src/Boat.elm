module Boat where

import Html (text, dl, dd, dt, div, Html)
import Html.Attributes (id, style)
import Keyboard
import Signal
import Color (..)
import Graphics.Collage (..)
import Graphics.Element (..)
import Time (..)

type alias Model =
  { tiller : Int
  , sheet : Int
  }


initialModel : Model
initialModel =
  { tiller = 0
  , sheet = 0
  }




type alias Input =
  { tiller : Int
  , sheet : Int
  , delta : Time
  }


update : Input -> Model -> Model
update i m = { m | sheet <- clamp -20 20 <| m.sheet + i.sheet
                 , tiller <- clamp -20 20 <| m.tiller + i.tiller }




view : Model -> Html
view m =
  dl []
    [ dt [] [ text "Tiller" ]
    , dd [] [ text <| toString m.tiller ]
    , dt [] [ text "Sheet" ]
    , dd [] [ text <| toString m.sheet ]
    , dt [] [ text "The boat:"]
    , dd [] [ viewBoat m ]
    ]




viewBoat : Model -> Html
viewBoat m =
  div [ style <| boatStyle m ]
      [ text "⛵️" ]

boatStyle : Model -> List (String, String)
boatStyle m =
  [ ("height", "120px")
  , ("width", "100px")
  , ("font-size", "100px")
  , ("margin-left", toString (10 * (m.sheet + 20)) ++ "px")
  , ("text-align", "center")
  , ("transform", "rotate(" ++ toString (10 * m.tiller) ++ "deg)")
  ]

main : Signal Html
main = Signal.map view model

model : Signal Model
model = Signal.foldp update initialModel input

input : Signal Input
input =
  Signal.sampleOn delta <|
    Signal.map3 Input
      (Signal.map .x Keyboard.arrows)
      (Signal.map .x Keyboard.wasd)
      delta

delta = Signal.map inSeconds (fps 40)
