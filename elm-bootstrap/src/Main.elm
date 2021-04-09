module Main exposing (Model, Msg(..), init, main, mainContent, navbar, simpleForm, subscriptions, update, view)

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
import Html.Attributes exposing (..)


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> init
        , update = update
        , view = view
        , subscriptions = subscriptions
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
      }
    , navbarCmd
    )


type Msg
    = NoOp
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


update : Msg -> Model -> ( Model, Cmd msg )
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
        ]



mainContent : Model -> Html Msg
mainContent model =
    div [ style "margin-top" "60px" ]
        [ navbar model
        , simpleForm
        ]


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
            [ Navbar.itemLinkActive [ href "Main.elm" ] [ text "Startside" ]
            , Navbar.itemLink [ href "Medarbejdere.elm" ] [ text "Medarbejdere" ]
            , Navbar.itemLink [ href "Afdelinger.elm" ] [ text "Afdelinger" ]
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
        [ h1 [] [ text "Startside" ]
        , h3 [] [ text "Velkommen til ELM" ]
        ]


