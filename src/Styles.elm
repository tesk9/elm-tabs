module Styles
    exposing
        ( Classes(..)
        , css
        , class
        , id
        , classList
        )

{-|
@docs Classes, css, class, id, classList
-}

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html.CssHelpers exposing (Namespace, withNamespace)


{-| Classes
-}
type Classes
    = Container


snippets : List Snippet
snippets =
    [ Css.class Container
        []
    ]


{ class, classList, id } =
    currentNamespace


currentNamespace : Html.CssHelpers.Namespace String a b c
currentNamespace =
    withNamespace "elm-tabs-"


{-| css
The produced stylesheet.
-}
css : String
css =
    snippets
        |> namespace currentNamespace.name
        |> stylesheet
        |> (\x -> [ x ])
        |> compile
        |> .css
