module Salem.Boat.Tiller where

import Html exposing (text, Html)
import Keyboard

import Salem.Boat.Control as Control
import Salem.Component as Component


type alias Model = Control.Model
type alias Action = Control.Action


component : Component.Signature Model Action
component =
  Control.mkComponent Keyboard.arrows


init : Model
init =
  component.init

update : Action -> Model -> Model
update =
  component.update

view : Model -> Html
view =
  component.view

actions : Signal Action
actions =
  component.actions

model : Signal Model
model =
  component.model

main : Signal Html
main =
  component.main
