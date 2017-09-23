module Tabs.Key exposing (onKeyDown, enter, right, left)

{-|
@docs onKeyDown, enter, right, left
-}

import Html exposing (Attribute)
import Html.Events exposing (on, keyCode)
import Json.Decode


{-| Pass a list of decoders.

    onKeyDown [ enter TheyHitEnterDoSomething, left DoSomeOtherThing ]
-}
onKeyDown : List (Json.Decode.Decoder msg) -> Attribute msg
onKeyDown decoders =
    on "keydown" (Json.Decode.oneOf decoders)


succeedForKeyCode : Int -> msg -> Json.Decode.Decoder msg
succeedForKeyCode key msg =
    (Json.Decode.andThen
        (\keyCode ->
            if keyCode == key then
                Json.Decode.succeed msg
            else
                Json.Decode.fail (toString keyCode)
        )
        keyCode
    )


{-| For enter keydown.
-}
enter : msg -> Json.Decode.Decoder msg
enter msg =
    succeedForKeyCode 13 msg


{-| For left arrow keydown.
-}
left : msg -> Json.Decode.Decoder msg
left msg =
    succeedForKeyCode 37 msg


{-| For right arrow keydown.
-}
right : msg -> Json.Decode.Decoder msg
right msg =
    succeedForKeyCode 39 msg
