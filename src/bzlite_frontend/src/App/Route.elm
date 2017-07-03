module App.Route exposing (Route(..), fromLocation, href, modifyUrl)

import Html
import Html.Attributes
import Navigation
import UrlParser


-- ROUTING --


type Route
    = Home


route : UrlParser.Parser (Route -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home (UrlParser.s "")
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []
    in
        "/" ++ String.join "/" pieces



-- PUBLIC HELPERS --


href : Route -> Html.Attribute msg
href route =
    Html.Attributes.href (routeToString route)


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


fromLocation : Navigation.Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        UrlParser.parseHash route location
