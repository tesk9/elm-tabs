module Flags exposing (Flags, decoder)

{-|
@docs Flags, decoder
-}

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


{-| Flags
-}
type alias Flags =
    {}


{-| decoder
-}
decoder : Decoder Flags
decoder =
    decode Flags
