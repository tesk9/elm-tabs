module Tests exposing (..)

import Accessibility exposing (..)
import Html.Attributes
import Json.Encode
import List.Zipper as Zipper
import Tabs.Model exposing (Model, TabPanels)
import Tabs.View as View
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


tabsTests : Test
tabsTests =
    let
        header content =
            h3 [] [ text content ]

        panel content =
            div [] [ h4 [] [ text "Section header" ], div [] [ text content ] ]
    in
    describe "view"
        [ describe "for a single tab" <|
            testCurrentTab (Zipper.singleton ( 0, header "Tab1", panel "Panel1" )) ( 0, "Tab1", "Panel1" )
        , describe "for many tabs" <|
            let
                default =
                    Zipper.withDefault ( 0, header "Failed", panel "Failed" )

                tabPanelPairsZipper =
                    default <|
                        Zipper.fromList <|
                            List.indexedMap
                                (\index ( tabContent, panelContent ) ->
                                    ( index, header tabContent, panel panelContent )
                                )
                                [ ( "Tab1", "Panel1" )
                                , ( "Tab2", "Panel2" )
                                , ( "Tab3", "Panel3" )
                                , ( "Tab4", "Panel4" )
                                , ( "Tab5", "Panel5" )
                                ]
            in
            [ describe "first tab selected" <|
                testCurrentTab tabPanelPairsZipper ( 0, "Tab1", "Panel1" )
            , describe "second tab selected" <|
                testCurrentTab (default <| Zipper.next tabPanelPairsZipper) ( 1, "Tab2", "Panel2" )
            , describe "last tab selected" <|
                testCurrentTab (Zipper.last tabPanelPairsZipper) ( 4, "Tab5", "Panel5" )
            ]
        ]


testCurrentTab : TabPanels -> ( Int, String, String ) -> List Test
testCurrentTab tabPanelPairsZipper ( index, tabContent, panelContent ) =
    let
        queryView =
            { groupId = "group-id"
            , tabPanels = tabPanelPairsZipper
            }
                |> View.view
                |> Query.fromHtml

        tabSelector =
            Query.find [ attribute "role" "tab", attribute "aria-selected" "true" ] queryView

        panelSelector =
            Query.find [ attribute "role" "tabpanel", attribute "aria-hidden" "false" ] queryView
    in
    [ test "the current tab has the right content" <|
        \() ->
            Query.has [ Selector.text tabContent ] tabSelector
    , test "the tab controls the associated panel" <|
        \() ->
            Query.has [ attribute "aria-controls" ("group-id-tabPanel-current-" ++ toString index) ] tabSelector
    , test "the current panel has the right content" <|
        \() ->
            Query.has [ Selector.text panelContent ] panelSelector
    , test "the panel is labelled by the tab" <|
        \() ->
            Query.has [ attribute "aria-labelledby" ("group-id-tab-current-" ++ toString index) ] panelSelector
    ]


attribute : String -> String -> Selector.Selector
attribute propertyName propertyValue =
    Selector.attribute
        (Html.Attributes.property propertyName
            (Json.Encode.string propertyValue)
        )
