module App.Css exposing (..)

import Html.CssHelpers exposing (withNamespace)


type CssClasses
    = Container


type CssIds
    = HomePage


bzliteNamespace =
    withNamespace "bzlite"
