port module Stylesheets exposing (..)

import Css.File exposing (CssCompilerProgram, CssFileStructure)
import App.Css.Stylesheets


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "index.css", Css.File.compile [ App.Css.Stylesheets.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
