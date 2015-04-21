module Salem where

import Html exposing (div, Html)
import Html.Attributes exposing (id)
import Signal exposing ((<~))

import Boat
import Wind


type alias Model =
  { wind : Wind.Model
  , boat : Boat.Model
  }


init : Model
init =
  { wind = Wind.init
  , boat = Boat.init
  }


type Action
  = BoatAction Boat.Action
  | WindAction Wind.Action


update : Action -> Model -> Model
update a m =
  case a of
    BoatAction a' -> { m | boat <- Boat.update a' m.boat }
    WindAction a' -> { m | wind <- Wind.update a' m.wind }


view : Model -> Html
view m =
  div [ id "salem" ]
      [ Wind.view m.wind
      , Boat.view m.boat
      ]


actions : Signal Action
actions =
  Signal.merge
    (BoatAction <~ Boat.actions)
    (WindAction <~ Wind.actions)


model : Signal Model
model = Signal.foldp update init actions


main : Signal Html
main =
  view <~ model
