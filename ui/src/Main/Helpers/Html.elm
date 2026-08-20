module Main.Helpers.Html exposing (..)

import Html exposing (Attribute, Html, button, div, node)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (stopPropagationOn)
import Json.Decode
import Main.Config.App exposing (AppRuntime, showAppRuntime, showAppRuntimeDescription)
import Main.Icons exposing (iconCopy)
import Main.Update.Types exposing (..)


viewRuntimeBadge : AppRuntime -> Html Update
viewRuntimeBadge runtime =
    Html.span [ class "has-tooltip d-inline-block me-1", stopPropagationOn "click" (Json.Decode.succeed ( Update_NoOp, True )) ]
        [ Html.span [ class "badge rounded-pill bg-primary-subtle text-primary-emphasis border border-primary-subtle" ] [ Html.text (showAppRuntime runtime |> String.toLower) ]
        , div [ class "tooltip bs-tooltip-top", attribute "role" "tooltip" ]
            [ div [ class "tooltip-inner" ] [ Html.text (showAppRuntimeDescription runtime) ]
            ]
        ]


mdResolveLangCodeAlias : String -> String
mdResolveLangCodeAlias lang =
    case lang of
        "python3" ->
            "python"

        "py" ->
            "python"

        -- sparql is not sql but we don't need to bring in https://github.com/redmer/highlightjs-sparql
        -- for a single line in qlever app where sql highlighting works fine
        "sparql" ->
            "sql"

        any ->
            any


type alias CodeBlock =
    { body : String
    , language : Maybe String
    }


plainCodeBlock : String -> Html Update
plainCodeBlock content =
    codeBlock
        { body = content
        , language = Nothing
        }


nixCodeBlock : String -> Html Update
nixCodeBlock content =
    codeBlock
        { body = content
        , language = Just "nix"
        }


bashCodeBlock : String -> Html Update
bashCodeBlock content =
    codeBlock
        { body = content
        , language = Just "bash"
        }


codeBlock : CodeBlock -> Html Update
codeBlock body =
    let
        lang =
            body.language
                |> Maybe.withDefault ""
                |> mdResolveLangCodeAlias

        copyBtn =
            button
                [ class "btn btn-sm btn-secondary position-absolute top-0 end-0 m-2 button copy"
                , onClick (Update_CopyToClipboard body.body)
                ]
                [ iconCopy ]
    in
    div [ class "markdown-content position-relative" ]
        [ copyBtn
        , node
            "highlightjs-code"
            [ attribute "language" lang
            , attribute "body" body.body
            ]
            []
        ]


{-| `onClick` is like `Html.Events.onClick`
but prevents default action on internal links to avoid full page reloads.

The name conflicts on purpose to prevent accidental use of `Html.Events.onClick`.

Documentation: <https://github.com/mpizenberg/elm-url-navigation-port?tab=readme-ov-file#link-clicks>

-}
onClick : update -> Attribute update
onClick update =
    Html.Events.preventDefaultOn "click"
        (Json.Decode.succeed ( update, True ))


{-| Stop a click event from bubbling up to a parent element.
Use this on external links nested inside an `onClick` parent.
-}
onClickStopPropagation : Attribute Update
onClickStopPropagation =
    Html.Events.custom "click"
        (Json.Decode.succeed
            { message = Update_NoOp
            , stopPropagation = True
            , preventDefault = False
            }
        )
