module TheList exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Json


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- Model


type alias ListItem =
    { text : String
    }


type alias Model =
    { newItem : String
    , list : List ListItem
    }


model : Model
model =
    { newItem = ""
    , list =
        [ { text = "Hello World!" }
        ]
    }



-- Update


type Msg
    = AddListItem
    | InputNewItem String
    | ClearList


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddListItem ->
            { model
                | list = List.append model.list [ { text = model.newItem } ]
                , newItem = ""
            }

        InputNewItem theText ->
            { model | newItem = theText }

        ClearList ->
            { model | list = [] }



-- View


viewListItem : ListItem -> Html Msg
viewListItem listItem =
    li [] [ text listItem.text ]


viewList : List ListItem -> Html Msg
viewList list =
    let
        listOfItems =
            List.map viewListItem list
    in
        ul [] listOfItems


view : Model -> Html Msg
view model =
    div []
        [ input
            [ placeholder "New text"
            , value model.newItem
            , onInput InputNewItem
            , onEnter AddListItem
            ]
            []
        , button [ onClick AddListItem ] [ text "Add" ]
        , button [ onClick ClearList ] [ text "Clear list" ]
        , viewList model.list
        ]



-- Custom Event Listener


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter keyCode)
