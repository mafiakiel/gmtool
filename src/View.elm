module View exposing (view)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table
import FontAwesome exposing (icon, plus, redo, trash, undo)
import Html exposing (Html, div, h1, h2, node, text)
import Html.Attributes exposing (href, id, rel)
import List exposing (map)
import Types exposing (Action(..), Model, Msg(..), State)
import UndoList exposing (UndoList)


view : Model -> Html Msg
view model =
    div [ id "container" ]
        [ CDN.stylesheet
        , fontAwesome
        , header model
        , div [ id "content" ]
            [ playerList model.present
            , phaseContent model.present
            ]
        ]


header : Model -> Html Msg
header model =
    div [ id "header" ]
        [ h1 [] [ text "Name der Phase" ]
        , h2 [] [ text "Beschreibung der Phase" ]
        , Button.button [ Button.onClick Undo, Button.disabled <| not <| UndoList.hasPast model ] [ icon undo ]
        , Button.button [ Button.onClick Redo, Button.disabled <| not <| UndoList.hasFuture model ] [ icon redo ]
        ]


playerList : State -> Html Msg
playerList state =
    let
        actionSetNewPlayerName name =
            Action <| SetNewPlayerName name

        actionRemovePlayer id =
            Action <| RemovePlayer id

        playerToTableRow player =
            Table.tr []
                [ Table.td [] [ text player.name ]
                , Table.td [] [ Button.button [ Button.onClick <| actionRemovePlayer player.id, Button.danger, Button.small ] [ icon trash ] ]
                ]
    in
    div [ id "players" ]
        [ h2 [] [ text "Spieler" ]
        , Table.table
            { options = []
            , thead =
                Table.simpleThead
                    [--Table.th [] [text "Name"]
                    ]
            , tbody = Table.tbody [] (map playerToTableRow state.players)
            }
        , InputGroup.config
            (InputGroup.text [ Input.placeholder "Name", Input.value state.newPlayerName, Input.onInput actionSetNewPlayerName ])
            |> InputGroup.successors
                [ InputGroup.button [ Button.success, Button.onClick <| Action AddPlayer, Button.disabled <| state.newPlayerName == "" ] [ icon plus ] ]
            |> InputGroup.view
        ]


phaseContent : State -> Html Msg
phaseContent state =
    div [ id "phase-viewport" ] [ text "Phasenspezifischer Inhalt" ]


fontAwesome : Html msg
fontAwesome =
    -- Bootstrap.CDN.fontAwesome is version 4.7.0 but the FontAwesome package needs version 5
    node "link"
        [ rel "stylesheet"
        , href "https://use.fontawesome.com/releases/v5.7.2/css/all.css"
        ]
        []
