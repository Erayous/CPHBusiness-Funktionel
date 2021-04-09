module Greeter exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode

type alias Greeter =
    { code: String
    , name: String
    , description: String
    }


greeterDecoder : Decode.Decoder Greeter
greeterDecoder =
    Decode.map3 Greeter
        (Decode.field "code" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "description" Decode.string)
