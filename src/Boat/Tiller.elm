module Boat.Tiller where


import Html exposing (text, Html)
import Keyboard
import Signal exposing ((<~))
import Time


type alias Model = Int


init : Model
init = 0


type Action
  = NoOp
  | Left
  | Right


bound = 20

bind = clamp (-bound) bound

update : Action -> Model -> Model
update action m =
  case action of
    Right -> bind <| m + 1
    Left -> bind <| m - 1
    NoOp -> m


view : Model -> Html
view m =
  text <| toString m


keyToAction : Int -> Action
keyToAction i =
  case i of
    -1 -> Left
    1 -> Right
    _ -> NoOp


actions : Signal Action
actions =
  Signal.map keyToAction (.x <~ Signal.sampleOn (Time.fps 30) Keyboard.arrows)


model : Signal Model
model =
  Signal.foldp update 0 actions


main : Signal Html
main =
  view <~ model
