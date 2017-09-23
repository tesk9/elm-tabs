# elm-tabs
![](https://travis-ci.org/tesk9/elm-tabs.svg?branch=master)

Accessible tab widget using [`accessible-html`](package.elm-lang.org/packages/tesk9/accessible-html/latest).

#### Example:

```
import Html exposing (beginnerProgram)
import Accessibility as Html exposing (..)
import List.Zipper exposing (Zipper)
import Tabs.Model exposing (Model)
import Tabs.Update exposing (update)
import Tabs.View exposing (view)


main : Program Never Model Tabs.Update.Msg
main =
    beginnerProgram
        { model = model
        , update = update
        , view = view
        }


model : Model
model =
    { groupId = "test-view-container"
    , tabPanels = initZipper
    }


initZipper : Zipper ( Int, Html Never, Html Never )
initZipper =
    List.Zipper.Zipper
        []
        ( 0, header "Tab1", panel "Panel1" )
        [ ( 1, header "Tab2", panel "Panel2" )
        , ( 2, header "Tab3", panel "Panel3" )
        , ( 3, header "Tab4", panel "Panel4" )
        , ( 4, header "Tab5", panel "Panel5" )
        ]


header : String -> Html msg
header tabContent =
    h2 [] [ text tabContent ]


panel : String -> Html msg
panel panelContent =
    div []
        [ h3 [] [ text panelContent ]
        , text panelContent
        ]
```