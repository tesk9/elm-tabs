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
import Model exposing (Model)
import Styles exposing (..)
import Update exposing (Msg(..))


{-| Create a tab interface. Pass in a unique id and a zipper of (tab header content, panel content) pairs.
-}
view : String -> Model Msg -> Html Msg
view groupId model =
    let
        toTabPanelWithIds section isSelected ( id, tabContent, panelContent ) =
            ( id, viewTab groupId isSelected section id tabContent, viewPanel groupId isSelected section id panelContent )

        viewPreviousTabPanel tabPanelTuple =
            toTabPanelWithIds "previous-" False tabPanelTuple

        viewUpcomingTabPanel tabPanelTuple =
            toTabPanelWithIds "upcoming-" False tabPanelTuple

        ( tabs, panels ) =
            model
                |> Zipper.mapBefore (List.map viewPreviousTabPanel)
                |> Zipper.mapCurrent (toTabPanelWithIds "current-" True)
                |> Zipper.mapAfter (List.map viewUpcomingTabPanel)
                |> Zipper.toList
                |> List.map (\( _, tab, panel ) -> ( tab, panel ))
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


viewTab : String -> Bool -> String -> Int -> Html Msg -> Html Msg
viewTab groupId isSelected section identifier tabContent =
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
        [ tabContent ]


viewPanel : String -> Bool -> String -> Int -> Html Msg -> Html Msg
viewPanel groupId isSelected section identifier panelContent =
    tabPanel
        [ id (panelId groupId section identifier)
        , class [ TabPanel ]
        , A11yAttributes.labelledBy (tabId groupId section identifier)
        , A11yAttributes.hidden (not isSelected)
        , Html.Attributes.hidden (not isSelected)
        ]
        [ panelContent ]
