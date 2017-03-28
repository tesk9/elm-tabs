module View exposing (view)

{-|
@docs view
-}

import Html exposing (..)
import Html.Attributes
import Html.CssHelpers
import Model exposing (Model)
import Styles exposing (..)
import Update exposing (Msg(..))


{-| view
-}
view : Model -> Html Msg
view model =
    div
        [ class [ Container ] ]
        [ Html.CssHelpers.style css
        , text "Hello, world!"
        ]
