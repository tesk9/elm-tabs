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
update : Msg -> Model Msg -> Model Msg
update msg model =
    case msg of
        NoOp ->
            model

        SelectPreviousTab ->
            model
                |> Zipper.previous
                |> Maybe.withDefault (Zipper.last model)

        SelectCurrentTab identifier ->
            model
                |> Zipper.first
                |> Zipper.find (\( id, _, _ ) -> id == identifier)
                |> Maybe.withDefault model

        SelectNextTab ->
            model
                |> Zipper.next
                |> Maybe.withDefault (Zipper.first model)
