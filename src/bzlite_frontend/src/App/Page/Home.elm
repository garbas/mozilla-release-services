module App.Page.Home exposing (Model, Msg, init, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (attribute, class, classList, href, id, placeholder)
import Html.Events exposing (onClick)
import Http
import SelectList exposing (SelectList)
import Task exposing (Task)

import App.Css
import App.Data.Session
import App.Page.Errored
import App.Misc
import App.Views.Page


-- Messages

type Msg
    = NoOp


-- MODEL --

type alias Model =
    { saySomething : String
    }


init : App.Data.Session.Model -> Task App.Page.Errored.PageLoadError Model
init session =
    Model "WORKS"
        |> Task.succeed


-- VIEW --


view : App.Data.Session.Model -> Model -> Html Msg
view session model =
    div [ class "home-page" ]
         
        [ text model.saySomething ]


-- UPDATE --


update : App.Data.Session.Model -> Msg -> Model -> ( Model, Cmd Msg )
update session msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)
