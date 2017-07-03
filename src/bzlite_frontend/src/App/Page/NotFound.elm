module App.Page.NotFound exposing (view)

import Html exposing (Html, div, h1, img, main_, text)
import Html.Attributes exposing (alt, class, id, src, tabindex)

import App.Data.Session

-- VIEW --


view : App.Data.Session.Model -> Html msg
view session =
    main_ [ id "content", class "container", tabindex -1 ]
        [ h1 [] [ text "Not Found" ]
        , div [ class "row" ] [ text "Here should come a nice 404 image." ]
        ]
