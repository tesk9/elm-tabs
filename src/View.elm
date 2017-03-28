module View exposing (view)

{-|
@docs view
-}

import Html exposing (..)
import Html.Attributes
import Html.CssHelpers
import Html.Events exposing (onClick)
import Key exposing (..)
import List.Zipper as Zipper
import Model exposing (Model)
import Styles exposing (..)
import Update exposing (Msg(..))


{-| Create a tab interface. Pass in a unique id and a zipper of (tab header content, panel content) pairs.
-}
view : String -> Model (Msg comparable) comparable -> Html (Msg comparable)
view groupId model =
    let
        tabId section identifier =
            groupId ++ "-tab-" ++ section ++ toString identifier

        panelId section identifier =
            groupId ++ "-tabPanel-" ++ section ++ toString identifier

        viewTab : Bool -> String -> comparable -> Html (Msg comparable) -> Html (Msg comparable)
        viewTab isSelected section identifier tabContent =
            tab
                [ id (tabId section identifier)
                , onClick (SelectCurrentTab identifier)
                , onEnter (SelectCurrentTab identifier)
                , onLeft SelectPreviousTab
                , onRight SelectNextTab
                , A11y.controls (panelId section identifier)
                , A11y.selected isSelected
                ]
                [ tabContent ]

        viewPanel : Bool -> String -> comparable -> Html (Msg comparable) -> Html (Msg comparable)
        viewPanel isSelected section identifier panelContent =
            tabPanel
                [ id (panelId section identifier)
                , labelledby (tabId section identifier)
                , A11y.hidden (not isSelected)
                , Html.Attributes.hidden (not isSelected)
                ]
                [ panelContent ]

        toTabPanelWithIds section isSelected ( id, tabContent, panelContent ) =
            ( id, viewTab isSelected section id tabContent, viewPanel isSelected section id panelContent )

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
            , div [] (tabList [ id groupId ] tabs :: panels)
            ]
