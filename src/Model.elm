module Model exposing (Model, TabPanels, TabAndPanel, tabAndPanel, section, selected)

{-|
@docs Model, TabPanels, TabAndPanel, tabAndPanel, section, selected
-}

import Html exposing (Html)
import List.Zipper exposing (Zipper)


{-| The model contains tabpanels and the groupid for the tab collection.
-}
type alias Model =
    { tabPanels : TabPanels
    , groupId : String
    }


{-| Zipper tabs are represented as a Zipper with an id, tab html, and tab panel html.
-}
type alias TabPanels =
    Zipper ( Int, Html Never, Html Never )


{-| Internal represenation of a tab/panel pair.
-}
type alias TabAndPanel =
    { identifier : Int
    , tabContent : Html Never
    , panelContent : Html Never
    , section : String
    , isSelected : Bool
    }


{-| Initialize a pre-selection and pre-section tab/panel pair.
-}
tabAndPanel : ( Int, Html Never, Html Never ) -> TabAndPanel
tabAndPanel ( id, tabContent, panelContent ) =
    { identifier = id
    , tabContent = tabContent
    , panelContent = panelContent
    , section = ""
    , isSelected = False
    }


{-| Set a TabAndPanel section to be the given string.
-}
section : String -> TabAndPanel -> TabAndPanel
section section tabAndPanel =
    { tabAndPanel | section = section }


{-| Set a TabAndPanel to be selected.
-}
selected : TabAndPanel -> TabAndPanel
selected tabAndPanel =
    { tabAndPanel | isSelected = True }
