
import * as React from "react"
import * as Oni from "oni-api"

export const activate = (oni: Oni.Plugin.Api) => {
    console.log("config activated")

    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind("<c-enter>", () => console.log("Control+Enter was pressed"))

    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    // oni.input.unbind("<c-p>")

}

export const deactivate = (oni: Oni.Plugin.Api) => {
    console.log("config deactivated")
}

export const configuration = {
    "ui.colorscheme": "n/a",

    //"oni.bookmarks": ["~/Documents"],
    "oni.useDefaultConfig": false,
    "oni.loadInitVim": true,
    "editor.fontSize": "14px",
    // "editor.fontFamily": "Monaco",
    "learning.enabled": false,
    "achievements.enabled": false,
    "autoClosingPairs.enabled": false,
    "editor.typingPrediction": false, // Wait for vim's confirmed typed characters, avoid edge cases
    "editor.clipboard.enabled": false, // workaround for https://github.com/onivim/oni/issues/2267
    // UI customizations
    "ui.animations.enabled": true,
    "ui.fontSmoothing": "auto",
}
