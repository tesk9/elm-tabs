module Tabs.Styles
    exposing
        ( Classes(..)
        , class
        , classList
        , css
        , id
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
    | TabList
    | Tab
    | SelectedTab
    | TabPanel


snippets : List Snippet
snippets =
    [ Css.class Container
        [ width (px 768)
        , margin2 (px 20) auto
        ]
    , Css.class TabList
        [ displayFlex
        , justifyContent spaceBetween
        ]
    , Css.class Tab
        [ border3 (px 1) solid black
        , borderTopRadius (px 8)
        , minWidth (px 150)
        , textAlign center
        , backgroundColor lightGray
        , zIndex (int 1)
        ]
    , Css.class SelectedTab
        [ borderBottomColor white
        , backgroundColor white
        ]
    , Css.class TabPanel
        [ border3 (px 1) solid black
        , borderBottomRadius (px 8)
        , position relative
        , top (px -1)
        , padding (px 30)
        ]
    ]


borderTopRadius : Length compatible units -> Style
borderTopRadius setting =
    batch
        [ borderTopLeftRadius setting
        , borderTopRightRadius setting
        ]


borderBottomRadius : Length compatible units -> Style
borderBottomRadius setting =
    batch
        [ borderBottomLeftRadius setting
        , borderBottomRightRadius setting
        ]


black : Color
black =
    hex "#000"


white : Color
white =
    hex "#fff"


lightGray : Color
lightGray =
    hex "#dbdbdb"


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
