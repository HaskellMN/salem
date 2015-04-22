module Salem.Boat where

import Html exposing (text, dl, dd, dt, div, Html)
import Html.Attributes exposing (id, style)
import Signal exposing ((<~))

import Boat.Tiller as Tiller
import Boat.Sheet as Sheet


type alias Model =
  { tiller : Tiller.Model
  , sheet : Sheet.Model
  }


init : Model
init =
  { tiller = Tiller.init
  , sheet = Sheet.init
  }


type Action
  = TillerAction Tiller.Action
  | SheetAction Sheet.Action


update : Action -> Model -> Model
update action m =
  case action of
    TillerAction action' -> { m | tiller <- Tiller.update action' m.tiller }
    SheetAction action' -> { m | sheet <- Sheet.update action' m.sheet }


view : Model -> Html
view m =
  dl []
    [ dt [] [ text "Tiller:" ]
    , dd [] [ Tiller.view m.tiller ]
    , dt [] [ text "Sheet:" ]
    , dd [] [ Sheet.view m.sheet ]
    , dt [] [ text "The Boat:"]
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


actions : Signal Action
actions =
  Signal.merge
    (TillerAction <~ Tiller.actions)
    (SheetAction <~ Sheet.actions)


model : Signal Model
model = Signal.foldp update init actions


main : Signal Html
main =
  view <~ model
