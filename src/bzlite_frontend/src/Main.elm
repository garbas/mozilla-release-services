module Main exposing (main)

import Html exposing (..)
import Navigation
import Task

import Ports

import App.Data.Session
import App.Page.Errored
import App.Page.Home
import App.Page.NotFound
import App.Route
import App.Views.Page


-- WARNING: this whole file will become unnecessary and go away in Elm 0.19,
-- so avoid putting things in here unless there is no alternative!


type Page
    = Blank
    | NotFound
    | Errored App.Page.Errored.PageLoadError
    | Home App.Page.Home.Model


type RemotePage
    = Loaded Page
    | TransitioningFrom Page



-- MODEL --


type alias Model =
    { session : App.Data.Session.Model
    , page : RemotePage
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    setRoute (App.Route.fromLocation location)
        { page = Loaded Blank
        , session = { user = Nothing }
        }


-- VIEW --


view : Model -> Html Msg
view model =
    case model.page of
        Loaded page ->
            viewPage model.session False page

        TransitioningFrom page ->
            viewPage model.session True page


viewPage : App.Data.Session.Model -> Bool -> Page -> Html Msg
viewPage session isLoading page =
    let
        frame =
            App.Views.Page.frame isLoading session.user
    in
    case page of
        NotFound ->
            App.Page.NotFound.view session
                |> frame App.Views.Page.Other

        Blank ->
            -- This is for the very intiial page load, while we are loading
            -- data via HTTP. We could also render a spinner here.
            Html.text ""
                |> frame App.Views.Page.Other

        Errored subModel ->
            App.Page.Errored.view session subModel
                |> frame App.Views.Page.Other

        Home subModel ->
            App.Page.Home.view session subModel
                |> frame App.Views.Page.Home
                |> Html.map HomeMsg



-- SUBSCRIPTIONS --
-- Note: we aren't currently doing any page subscriptions, but I thought it would
-- be a good idea to put this in here as an example. If I were actually
-- maintaining this in production, I wouldn't bother until I needed this!


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ pageSubscriptions (getPage model.page)
        ]


getPage : RemotePage -> Page
getPage page=
    case page of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none

        Errored _ ->
            Sub.none

        NotFound ->
            Sub.none

        Home _ ->
            Sub.none


-- UPDATE --


type Msg
    = SetRoute (Maybe App.Route.Route)
    | HomeLoaded (Result App.Page.Errored.PageLoadError App.Page.Home.Model)
    | HomeMsg App.Page.Home.Msg


setRoute : Maybe App.Route.Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        transition toMsg task =
            ( { model | page = TransitioningFrom (getPage model.page ) }
            , Task.attempt toMsg task
            )

        errored =
            pageErrored model
    in
    case maybeRoute of
        Nothing ->
            ( { model | page = Loaded NotFound }
            , Cmd.none
            )

        Just App.Route.Home ->
            transition HomeLoaded (App.Page.Home.init model.session)


pageErrored : Model -> App.Views.Page.ActivePage -> String -> ( Model, Cmd msg )
pageErrored model activePage errorMessage =
    let
        error =
            App.Page.Errored.pageLoadError activePage errorMessage
    in
        ( { model | page = Loaded (Errored error) }
        , Cmd.none
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.page) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    let
        session =
            model.session

        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
            ( { model | page = Loaded (toModel newModel) }, Cmd.map toMsg newCmd )

        errored =
            pageErrored model
    in
    case ( msg, page ) of
        ( SetRoute route, _ ) ->
            setRoute route model

        ( HomeLoaded (Ok subModel), _ ) ->
            ( { model | page = Loaded (Home subModel) }
            , Cmd.none
            )

        ( HomeLoaded (Err error), _ ) ->
            ( { model | page = Loaded (Errored error) }
            , Cmd.none
            )

        ( HomeMsg subMsg, Home subModel ) ->
            toPage Home HomeMsg (App.Page.Home.update session) subMsg subModel

        ( _, NotFound ) ->
            -- Disregard incoming messages when we're on the NotFound page.
            ( model, Cmd.none )

        ( _, _ ) ->
            -- Disregard incoming messages that arrived for the wrong page
            ( model, Cmd.none )


-- MAIN --

type alias Flags =
    Maybe { user : Maybe String
          }


main : Program Flags Model Msg
main =
    Navigation.programWithFlags (App.Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
