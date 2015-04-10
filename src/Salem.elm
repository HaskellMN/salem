module Salem where

import Signal
import Html (div, Html)
import Html.Attributes (id)

import Boat
import Wind

salem : Html -> Html -> Html
salem a b =
  div [id "salem"]
      [a, b]


main = Signal.map2 salem Wind.main Boat.main
