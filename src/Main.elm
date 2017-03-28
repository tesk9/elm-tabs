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
main : Program Never Model Update.Msg
main =
    Html.beginnerProgram
        { model = model
        , update = update
        , view = view
        }


model : Model
model =
    let
        default =
            Z.singleton ( 0, Html.text "failed", Html.text "failed" )

        model =
            [ ( "Tab1", "Panel1" ), ( "Tab2", "Panel2" ), ( "Tab3", "Panel3" ), ( "Tab4", "Panel4" ), ( "Tab5", "Panel5" ) ]
                |> List.indexedMap toViewTuple
                |> Z.fromList
    in
        { tabPanels = Maybe.withDefault default model
        , groupId = "test-view-container"
        }


toViewTuple : a -> ( String, String ) -> ( a, Html.Html Never, Html.Html Never )
toViewTuple index ( tabContent, panelContent ) =
    ( index, header tabContent, panel panelContent )


header : String -> Html.Html msg
header tabContent =
    Html.h2 [] [ Html.text tabContent ]


panel : String -> Html.Html msg
panel panelContent =
    Html.div []
        [ Html.h3 [] [ Html.text panelContent ]
        , Html.text panelContent
        ]
