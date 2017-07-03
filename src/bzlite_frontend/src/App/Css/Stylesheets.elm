module App.Css.Stylesheets exposing (css)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)

import App.Css exposing (..)


css =
    (stylesheet << namespace bzliteNamespace.name)
        [ body
            [
            ]
        ]
