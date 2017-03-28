module Update exposing (update, Msg(..))

{-|
@docs Msg, update
-}

import Model exposing (Model)
import List.Zipper as Zipper


{-| Msg for tabs.
-}
type Msg
    = NoOp
    | SelectPreviousTab
    | SelectCurrentTab Int
    | SelectNextTab


{-| Map over this to select a tab.
-}
update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        SelectPreviousTab ->
            model.tabPanels
                |> Zipper.previous
                |> Maybe.withDefault (Zipper.last model.tabPanels)
                |> updateTabPanels model

        SelectCurrentTab identifier ->
            model.tabPanels
                |> Zipper.first
                |> Zipper.find (\( id, _, _ ) -> id == identifier)
                |> Maybe.withDefault model.tabPanels
                |> updateTabPanels model

        SelectNextTab ->
            model.tabPanels
                |> Zipper.next
                |> Maybe.withDefault (Zipper.first model.tabPanels)
                |> updateTabPanels model


updateTabPanels : Model -> Model.TabPanels -> Model
updateTabPanels model newTabPanels =
    { model | tabPanels = newTabPanels }
