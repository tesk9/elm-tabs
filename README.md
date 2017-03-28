# elm-tabs

Accessible tab widget using [`elm-html-a11y`](package.elm-lang.org/packages/tesk9/elm-html-a11y/latest).

#### Example:

```
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
        , view = view "test-view-container"
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
        Maybe.withDefault default model


toViewTuple : a -> ( String, String ) -> ( a, Html.Html Never, Html.Html Never )
toViewTuple index ( tabContent, panelContent ) =
    ( index, Html.map never <| header tabContent, Html.map never <| panel panelContent )


header : String -> Html.Html msg
header tabContent =
    Html.h2 [] [ Html.text tabContent ]


panel : String -> Html.Html msg
panel panelContent =
    Html.div []
        [ Html.h3 [] [ Html.text panelContent ]
        , Html.text panelContent
        ]
```