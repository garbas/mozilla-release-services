module App.Data.Session exposing (User, Model)


type alias User =
    { email : String
    --...
    }


type alias Model =
    { user : Maybe User
    }
