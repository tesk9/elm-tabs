module View exposing (view)

{-|
@docs view
-}

import Html exposing (..)
import Html.A11y exposing (..)
import Html.Attributes
import Html.Attributes.A11y as A11yAttributes
import Html.CssHelpers
import Html.Events exposing (onClick)
import Key exposing (..)
import List.Zipper as Zipper
import Model exposing (Model, TabAndPanel)
import Styles exposing (..)
import Update exposing (Msg(..))


{-| Create a tab interface. Pass in a unique id and a zipper of (tab header content, panel content) pairs.
-}
view : String -> Model -> Html Msg
view groupId model =
    let
        ( tabs, panels ) =
            model
                |> Zipper.map Model.tabAndPanel
                |> Zipper.mapBefore (List.map (Model.section "previous-"))
                |> Zipper.mapCurrent (Model.selected >> Model.section "current-")
                |> Zipper.mapAfter (List.map (Model.section "upcoming-"))
                |> Zipper.map (\tabAndPanel -> ( viewTab groupId tabAndPanel, viewPanel groupId tabAndPanel ))
                |> Zipper.toList
                |> List.unzip
    in
        div
            [ class [ Container ] ]
            [ Html.CssHelpers.style css
            , div [] (tabList [ id groupId, class [ TabList ] ] tabs :: panels)
            ]


tabId : String -> String -> Int -> String
tabId groupId section identifier =
    groupId ++ "-tab-" ++ section ++ toString identifier


panelId : String -> String -> Int -> String
panelId groupId section identifier =
    groupId ++ "-tabPanel-" ++ section ++ toString identifier


viewTab : String -> TabAndPanel -> Html Msg
viewTab groupId { tabContent, isSelected, section, identifier } =
    tab
        [ id (tabId groupId section identifier)
        , classList [ ( Tab, True ), ( SelectedTab, isSelected ) ]
        , onClick (SelectCurrentTab identifier)
        , onKeyDown
            [ enter (SelectCurrentTab identifier)
            , left SelectPreviousTab
            , right SelectNextTab
            ]
        , A11yAttributes.controls (panelId groupId section identifier)
        , A11yAttributes.selected isSelected
        ]
        [ Html.map never tabContent ]


viewPanel : String -> TabAndPanel -> Html Msg
viewPanel groupId { panelContent, isSelected, section, identifier } =
    tabPanel
        [ id (panelId groupId section identifier)
        , class [ TabPanel ]
        , A11yAttributes.labelledBy (tabId groupId section identifier)
        , A11yAttributes.hidden (not isSelected)
        , Html.Attributes.hidden (not isSelected)
        ]
        [ Html.map never panelContent ]
