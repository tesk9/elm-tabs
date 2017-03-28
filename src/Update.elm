module Update exposing (update, Msg(..))

{-|
@docs Msg, update
-}

import Model


{-| Msg
-}
type Msg
    = NoOp


{-| update
-}
update : Msg -> Model.Model -> ( Model.Model, Cmd c )
update msg model =
    case msg of
        NoOp ->
            model ! []
