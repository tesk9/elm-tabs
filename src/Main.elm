module Main exposing (main)

{-|
@docs main
-}

import Html
import Model exposing (Model)
import Update exposing (update)
import View exposing (view)
import List.Zipper as Z


{-| main
-}
main : Program Never (Model (Update.Msg Int) Int) (Update.Msg Int)
main =
    Html.beginnerProgram
        { model = model
        , update = update
        , view = view "test-view-container"
        }


model : Model (Update.Msg Int) Int
model =
    Maybe.withDefault (Z.singleton ( 0, Html.text "failed", Html.text "failed" )) <|
        Z.fromList <|
            List.indexedMap
                (\index ( tabContent, panelContent ) ->
                    ( index, Html.h2 [] [ Html.text tabContent ], Html.div [] [ Html.text panelContent ] )
                )
                [ ( "Tab1", "Panel1" )
                , ( "Tab2", "Panel2" )
                , ( "Tab3", "Panel3" )
                , ( "Tab4", "Panel4" )
                , ( "Tab5", "Panel5" )
                ]
