module Afdelinger exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
    exposing
        ( Decoder
        , decodeString
        , field
        , int
        , list
        , map3
        , string
        )


type alias Afdelinger =
    { code : String
    , name : String
    , description : String
    }


type alias Afdelinger_Model =
    { posts_afdelinger : List Afdelinger
    , errorMessage : Maybe String
    }


view : Afdelinger_Model -> Html Msg
view model_afdelinger =
    div []
        [ h1 [][ text "ELM Frontend" ]
        , h3 [][ text "Backend: www.minnow.dk" ]
        , button [ onClick SendHttpRequest ][ text "Hent alle afdelinger" ]
        , viewPostsOrError_afdelinger model_afdelinger
        ]


viewPostsOrError_afdelinger : Afdelinger_Model -> Html Msg
viewPostsOrError_afdelinger model =
    case model.errorMessage of
        Just message ->
            viewError_afdelinger message
        Nothing ->
            viewPosts_afdelinger model.posts_afdelinger

viewError_afdelinger : String -> Html Msg
viewError_afdelinger errorMessage =
    let
        errorHeading =
            "Kunne ikke hente data."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]

viewPosts_afdelinger : List Afdelinger -> Html Msg
viewPosts_afdelinger posts_afdelinger =
    div []
        [ h3 [] [ text "Afdelinger" ]
        , table []
            ([ viewTableHeader_afdelinger ] ++ List.map viewPost_afdelinger posts_afdelinger)
        ]

viewTableHeader_afdelinger : Html Msg
viewTableHeader_afdelinger =
    tr []
        [ th []
            [ text "Code" ]
        , th []
            [ text "Name" ]
        , th []
            [ text "Description" ]
        ]

viewPost_afdelinger : Afdelinger -> Html Msg
viewPost_afdelinger post =
    tr []
        [ td []
            [ text (post.code) ]
        , td []
            [ text post.name ]
        , td []
            [ text post.description ]
        ]

type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error (List Afdelinger))


postDecoder_afdelinger : Decoder Afdelinger
postDecoder_afdelinger =
    map3 Afdelinger
        (field "code" string)
        (field "name" string)
        (field "description" string)


httpCommand_afdelinger : Cmd Msg
httpCommand_afdelinger =
    Http.get
        { url = "http://minnow.dk/cphbusiness/alldepartments"
        , expect = Http.expectJson DataReceived (list postDecoder_afdelinger)
        }

update : Msg -> Afdelinger_Model -> ( Afdelinger_Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model, httpCommand_afdelinger )

        DataReceived (Ok posts) ->
            ( { model
                | posts_afdelinger = posts
                , errorMessage = Nothing
              }
            , Cmd.none
            )

        DataReceived (Err httpError) ->
            ( { model
                | errorMessage = Just (buildErrorMessage httpError)
              }
            , Cmd.none
            )


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message
        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."
        Http.NetworkError ->
            "Unable to reach server."
        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode
        Http.BadBody message ->
            message



init : () -> ( Afdelinger_Model, Cmd Msg )
init _ =
    ( { posts_afdelinger = []
      , errorMessage = Nothing
      }
    , Cmd.none
    )

main : Program () Afdelinger_Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }





