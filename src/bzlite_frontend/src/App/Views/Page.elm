module App.Views.Page exposing (ActivePage(..), frame)

{-| The frame around a typical page - that is, the header and footer.
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy2)

import App.Route
import App.Data.Session
import App.Misc
import App.Views.Spinner exposing (spinner)


{-| Determines which navbar link (if any) will be rendered as active.

Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.

-}
type ActivePage
    = Other
    | Home


{-| Take a page's Html and frame it with a header and footer.

The caller provides the current user, so we can display in either
"signed in" (rendering username) or "signed out" mode.

isLoading is for determining whether we should show a loading spinner
in the header. (This comes up during slow page transitions.)

-}
frame : Bool -> Maybe App.Data.Session.User -> ActivePage -> Html msg -> Html msg
frame isLoading user page content =
    div [ class "page-frame" ]
        [ viewHeader page user isLoading
        , content
        , viewFooter
        ]


viewHeader : ActivePage -> Maybe App.Data.Session.User -> Bool -> Html msg
viewHeader page user isLoading =
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", App.Route.href App.Route.Home ]
                [ text "conduit" ]
            , ul [ class "nav navbar-nav pull-xs-right" ] <|
                lazy2 App.Misc.viewIf isLoading spinner
                    :: navbarLink (page == Home) App.Route.Home [ text "Home" ]
                    :: viewSignIn page user
            ]
        ]


viewSignIn : ActivePage -> Maybe App.Data.Session.User -> List (Html msg)
viewSignIn page user =
    case user of
        Nothing ->
            [
            -- TODO: Login
            ]

        Just user ->
            [ navbarLink (page == Home) App.Route.Home [ text "Home" ]
            -- TODO: Logout
            ]


viewFooter : Html msg
viewFooter =
    footer
        []
        [ text "This is footer" ]


navbarLink : Bool -> App.Route.Route -> List (Html msg) -> Html msg
navbarLink isActive route linkContent =
    li
        [ classList [ ( "nav-item", True ), ( "active", isActive ) ] ]
        [ a [ class "nav-link", App.Route.href route ] linkContent ]
