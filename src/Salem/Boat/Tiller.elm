module Salem.Boat.Tiller where

import Html exposing (text, Html)
import Keyboard

import Boat.Control as Control


type alias Model = Control.Model
type alias Action = Control.Action


control : Control.Signature
control =
  Control.mkControl Keyboard.arrows


init : Model
init =
  control.init


update : Action -> Model -> Model
update =
  control.update


view : Model -> Html
view =
  control.view


actions : Signal Action
actions =
  control.actions


model : Signal Model
model =
  control.model


main : Signal Html
main =
  control.main
