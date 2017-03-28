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
import Css.Colors exposing (..)
import Css.Namespace exposing (namespace)
import Html.CssHelpers exposing (Namespace, withNamespace)


{-| Classes
-}
type Classes
    = Container
    | TabList
    | Tab
    | SelectedTab
    | TabPanel


snippets : List Snippet
snippets =
    [ Css.class Container
        [ width (px 768) ]
    , Css.class TabList
        [ displayFlex
        , justifyContent spaceBetween
        ]
    , Css.class Tab
        [ border3 (px 1) solid black
        , borderTopRadius (px 8)
        , minWidth (px 150)
        , textAlign center
        ]
    , Css.class SelectedTab
        [ borderBottomColor (hex "fff")
        ]
    , Css.class TabPanel
        [ border3 (px 1) solid black
        , position relative
        , top (px -1)
        , zIndex (int -1)
        ]
    ]


borderTopRadius : Length compatible units -> Mixin
borderTopRadius setting =
    mixin
        [ borderTopLeftRadius setting
        , borderTopRightRadius setting
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
