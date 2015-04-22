module Salem.Boat.Control where

import Html exposing (text, Html)
import Signal exposing ((<~))
import Time


type alias Model = Int

type alias XField a = { a | x : Int }


type Action
  = NoOp
  | Left
  | Right


type alias Signature =
  { init : Model
  , update : Action -> Model -> Model
  , view : Model -> Html
  , actions : Signal Action
  , model : Signal Model
  , main : Signal Html
  }


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


mkActions : Signal (XField a) -> Signal Action
mkActions xSignal =
  Signal.map keyToAction (.x <~ Signal.sampleOn (Time.fps 30) xSignal)


mkModel : Signal Action -> Signal Model
mkModel actions =
  Signal.foldp update 0 actions


mkControl : Signal (XField a) -> Signature
mkControl xSignal =
  let actions = mkActions xSignal
      model = mkModel actions
  in { init = 0
     , update = update
     , view = view
     , actions = actions
     , model = model
     , main = view <~ model
     }
