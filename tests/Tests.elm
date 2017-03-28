module Tests exposing (..)

import Expect
import Html exposing (..)
import List.Zipper as Zipper
import String
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import View


all : Test
all =
    describe "View"
        [ tabsTests
        ]


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


testCurrentTab : Model Int -> ( Int, String, String ) -> List Test
testCurrentTab tabPanelPairsZipper ( index, tabContent, panelContent ) =
    let
        queryView =
            View.view "group-id" tabPanelPairsZipper
                |> Query.fromHtml

        tabSelector =
            Query.find [ Selector.attribute "role" "tab", Selector.attribute "aria-selected" "true" ] queryView

        panelSelector =
            Query.find [ Selector.attribute "role" "tabpanel", Selector.attribute "aria-hidden" "false" ] queryView
    in
        [ test "the current tab has the right content" <|
            \() ->
                Query.has [ Selector.text tabContent ] tabSelector
        , test "the tab controls the associated panel" <|
            \() ->
                Query.has [ Selector.attribute "aria-controls" ("group-id-tabPanel-current-" ++ toString index) ] tabSelector
        , test "the current panel has the right content" <|
            \() ->
                Query.has [ Selector.text panelContent ] panelSelector
        , test "the panel is labelled by the tab" <|
            \() ->
                Query.has [ Selector.attribute "aria-labelledby" ("group-id-tab-current-" ++ toString index) ] panelSelector
        ]
