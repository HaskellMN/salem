module Salem.Boat.Control where

import Html exposing (text, Html)
import Signal exposing ((<~))
import Time

import Salem.Component as Component


type alias Model = Int


type Action
  = NoOp
  | Left
  | Right


bound : Int
bound = 20


bind : Int -> Int
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


mkActions : Signal { a | x : Int } -> Signal Action
mkActions xSignal =
  Signal.map keyToAction (.x <~ Signal.sampleOn (Time.fps 30) xSignal)


mkModel : Signal Action -> Signal Model
mkModel actions =
  Signal.foldp update 0 actions


mkComponent : Signal { a | x : Int } -> Component.Signature Model Action
mkComponent xSignal =
  let actions = mkActions xSignal
      model = mkModel actions
  in { init = 0
     , update = update
     , view = view
     , actions = actions
     , model = model
     , main = view <~ model
     }
