module Salem.Component where

import Html exposing (Html)


type alias Signature model action =
  { init : model
  , update : action -> model -> model
  , view : model -> Html
  , actions : Signal action
  , model : Signal model
  , main : Signal Html
  }
