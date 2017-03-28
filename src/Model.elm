module Model exposing (Model)

{-|
@docs Model
-}

import Html exposing (Html)
import List.Zipper exposing (Zipper)


{-| Zipper tabs are represented as a Zipper with an id, tab html, and tab panel html.
-}
type alias Model msg comparable =
    Zipper ( comparable, Html msg, Html msg )
