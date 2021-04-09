module Afdelinger exposing (Model, Msg(..), init, main, mainContent, navbar, simpleForm, subscriptions, update, view)

import Bootstrap.Accordion as Accordion
import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Form as Form

import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid

import Bootstrap.Modal as Modal
import Bootstrap.Navbar as Navbar

import Bootstrap.Popover as Popover
import Bootstrap.Tab as Tab
import Bootstrap.Table as Table
import Browser
import Color
import Html exposing (..)
import Html.Attributes exposing (class, for, href, style)
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

main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

type alias Afdelinger =
    { code : String
    , name : String
    , description : String
    }


type alias Model =
    { dummy : String
    , dropdownState : Dropdown.State
    , splitDropState : Dropdown.State
    , tabState : Tab.State
    , accordionState : Accordion.State
    , navbarState : Navbar.State
    , navMsgCounter : Int
    , popoverStateLeft : Popover.State
    , popoverStateRight : Popover.State
    , popoverStateTop : Popover.State
    , popoverStateBottom : Popover.State
    , modalVisibility : Modal.Visibility
    , simplePaginationIdx : Int
    , customPaginationIdx : Int
    , posts_afdelinger : List Afdelinger
    , errorMessage : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg
    in
    ( { dummy = "init"
      , dropdownState = Dropdown.initialState
      , splitDropState = Dropdown.initialState
      , tabState = Tab.initialState
      , accordionState = Accordion.initialStateCardOpen "card1"
      , navbarState = navbarState
      , navMsgCounter = 0
      , popoverStateLeft = Popover.initialState
      , popoverStateRight = Popover.initialState
      , popoverStateBottom = Popover.initialState
      , popoverStateTop = Popover.initialState
      , modalVisibility = Modal.hidden
      , simplePaginationIdx = 0
      , customPaginationIdx = 1
      , posts_afdelinger = []
      , errorMessage = Nothing
      }
    , navbarCmd
    )


type Msg
    = NoOp
    | DataReceived (Result Http.Error (List Afdelinger))
    | SendHttpRequest
    | DropdownMsg Dropdown.State
    | SplitMsg Dropdown.State
    | Item1Msg
    | Item2Msg
    | SplitMainMsg
    | SplitItem1Msg
    | SplitItem2Msg
    | ModalCloseMsg
    | ModalShowMsg
    | TabMsg Tab.State
    | AccordionMsg Accordion.State
    | NavbarMsg Navbar.State
    | TogglePopoverLeftMsg Popover.State
    | TogglePopoverRightMsg Popover.State
    | TogglePopoverBottomMsg Popover.State
    | TogglePopoverTopMsg Popover.State
    | SimplePaginationSelect Int
    | CustomPaginationSelect Int

update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ accordionState } as model) =
    case msg of
        NoOp ->
            ( { model | dummy = "NoOp" }, Cmd.none )

        Item1Msg ->
            ( { model | dummy = "item1" }, Cmd.none )

        Item2Msg ->
            ( { model | dummy = "item2" }, Cmd.none )

        DropdownMsg state ->
            ( { model | dropdownState = state }
            , Cmd.none
            )

        SplitMainMsg ->
            ( { model | dummy = "splitmain" }, Cmd.none )

        SplitItem1Msg ->
            ( { model | dummy = "splititem1" }, Cmd.none )

        SplitItem2Msg ->
            ( { model | dummy = "splititem2" }, Cmd.none )

        SplitMsg state ->
            ( { model | splitDropState = state }
            , Cmd.none
            )

        ModalCloseMsg ->
            ( { model | modalVisibility = Modal.hidden }
            , Cmd.none
            )

        ModalShowMsg ->
            ( { model | modalVisibility = Modal.shown }
            , Cmd.none
            )

        TabMsg state ->
            ( { model | tabState = state }
            , Cmd.none
            )

        AccordionMsg state ->
            ( { model | accordionState = state }
            , Cmd.none
            )

        NavbarMsg state ->
            ( { model | navbarState = state, navMsgCounter = model.navMsgCounter + 1 }
            , Cmd.none
            )

        TogglePopoverLeftMsg state ->
            ( { model | popoverStateLeft = state }
            , Cmd.none
            )

        TogglePopoverRightMsg state ->
            ( { model | popoverStateRight = state }
            , Cmd.none
            )

        TogglePopoverBottomMsg state ->
            ( { model | popoverStateBottom = state }
            , Cmd.none
            )

        TogglePopoverTopMsg state ->
            ( { model | popoverStateTop = state }
            , Cmd.none
            )

        SimplePaginationSelect idx ->
            ( { model | simplePaginationIdx = idx }
            , Cmd.none
            )

        CustomPaginationSelect idx ->
            ( { model | customPaginationIdx = idx }
            , Cmd.none
            )

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

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Accordion.subscriptions model.accordionState AccordionMsg
        , Dropdown.subscriptions model.dropdownState DropdownMsg
        , Dropdown.subscriptions model.splitDropState SplitMsg
        , Tab.subscriptions model.tabState TabMsg
        , Navbar.subscriptions model.navbarState NavbarMsg
        ]


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , CDN.fontAwesome
        , mainContent model
        , afdelingContent model
        ]


mainContent : Model -> Html Msg
mainContent model =
    div [ style "margin-top" "60px" ]
        [ navbar model
        , simpleForm
        ]

afdelingContent : Model -> Html Msg
afdelingContent model =
        div []
            [ h4 [][ text "Backend: http://minnow.dk/cphbusiness/alldepartments" ]
            , button [ onClick SendHttpRequest ][ text "Hent alle afdelinger" ]
            , viewPostsOrError_afdelinger model
        ]

viewPostsOrError_afdelinger : Model -> Html Msg
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
        [
        table []
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


navbar : Model -> Html Msg
navbar model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.container
        |> Navbar.fixTop
        |> Navbar.darkCustom (Color.rgb255 193 125 17)
        |> Navbar.collapseMedium
        |> Navbar.brand [ href "#" ] [ text "Logo" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "Main.elm" ] [ text "Startside" ]
            , Navbar.itemLink [ href "Medarbejdere.elm" ] [ text "Medarbejdere" ]
            , Navbar.itemLinkActive [ href "Afdelinger.elm" ] [ text "Afdelinger" ]
            ]
        |> Navbar.customItems
            [Navbar.formItem [ class "ml-lg-2" ]
                [ Input.text [ Input.small ]
                , Button.button
                    [ Button.success, Button.small ]
                    [ text "Submit" ]
                ]
            ]
        |> Navbar.view model.navbarState


simpleForm : Html Msg
simpleForm =
    Form.form
        []
        [ h1 [] [ text "Afdelinger" ]
        ]


