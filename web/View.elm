module View exposing (..)

import Css
import Html exposing (Attribute, Html, button, div, img, li, option, select, text, ul)
import Html.Attributes exposing (alt, class, selected, size, src)
import Html.Events exposing (on, onClick)
import Material
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Scheme
import Message exposing (Msg(Mdl, Randomize, SelectionChanged))
import Model exposing (Model)


styles : List Css.Mixin -> Attribute msg
styles =
    Css.asPairs >> Html.Attributes.style


disabled : Model.Selectable Model.Player -> List Css.Mixin
disabled selectable =
    selectionToVisibility selectable.selected


selectionToVisibility : Bool -> List Css.Mixin
selectionToVisibility selected =
    [ Css.opacity
        (Css.num
            (if selected then
                1
             else
                0.35
            )
        )
    ]


renderPlayer : Model.Selectable Model.Player -> Html Msg
renderPlayer selectable =
    li [ styles ([ Css.width (Css.pct 23), Css.margin (Css.px 4) ] ++ disabled selectable) ]
        [ case selectable.object of
            Model.Employee employee ->
                renderEmployee employee

            Model.Guest guest ->
                renderGuest guest
        , div [ class "overlay" ] []
        ]


renderEmployee : Model.EmployeeInfo -> Html Msg
renderEmployee employee =
    img
        [ styles [ Css.maxWidth (Css.pct 100), Css.maxHeight (Css.pct 100) ]
        , src employee.pictureUrl
        , alt employee.firstName
        , onClick (SelectionChanged (Model.Employee employee))
        ]
        []


renderGuest : Model.GuestInfo -> Html Msg
renderGuest guest =
    img [ styles [ Css.maxWidth (Css.pct 100), Css.maxHeight (Css.pct 100) ], src ("./assets/guest-" ++ toString guest.number ++ ".png"), alt "" ] []


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    div [ styles [ Css.backgroundColor (Css.hex "000000"), Css.height (Css.vh 100), Css.width (Css.vw 100) ] ]
        [ errorMessage model.error
        , ul [ styles [ Css.listStyleType Css.none, Css.margin Css.zero, Css.padding Css.zero, Css.displayFlex, Css.flexWrap Css.wrap, Css.justifyContent Css.center ] ]
            (List.map renderPlayer (Model.orderedPlayers model))
        , Button.render Mdl
            [ 0 ]
            model.mdl
            ([ Button.raised
             , Button.colored
             , Button.ripple
             , Options.onClick Randomize
             ]
                ++ (if Model.isRandomizable model then
                        []
                    else
                        [ Button.disabled ]
                   )
            )
            [ text "Randomize" ]
        ]
        |> Material.Scheme.top


errorMessage : Maybe Model.Error -> Html Msg
errorMessage error =
    case error of
        Nothing ->
            div [] []

        _ ->
            div []
                [ text (toString error) ]
