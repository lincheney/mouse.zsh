# mouse.zsh

[SGR mouse](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Extended-coordinates) support for zsh.

This provides a library that allows you to bind ZSH functions to SGR mouse events.

Note this only works if your terminal actually supports SGR mouse events.

> In contrast to https://github.com/matschaffer/oh-my-zsh-custom/blob/master/mouse.zsh
> this does not bind any actual actions to the mouse events.

## Usage

Download and `source` the [mouse.zsh](mouse.zsh) script,

Then you can enable SGR mouse events by running `zsh-enable-sgr-mouse`.
(And disable it again by running `zsh-enable-sgr-mouse 0`; you probably do not want it enabled all the time)
No events will trigger unless SGR mouse is enabled.

Then bind different events using `bindmouse EVENT FUNCTION`.

`EVENT` is something like:
* `left-down`, `left-up`: left mouse button is pressed/released
* `right-down`, `right-up`: same but for right mouse button
* `middle-down`, `middle-up`: same but for middle mouse button
* `scrollup`, `scrolldown`
* `buttonN-down`, `buttonN-up`: where `N` is a number, e.g. if your mouse has additional buttons.

You can also prefix the `EVENT` with combinations of modifiers `control`, `meta`, `shift`, e.g. `control-shift-left-up`.

The `FUNCTION` will be called with the arguments:
* the button/event e.g. `left`, `right`, `scrollup` etc
* the X coordinate
* the Y coordinate
* `up` or `down` (not applicable for `scrollup` and `scrolldown`)
* the modifiers as a space separated string

## Example

Print the X, Y coordinates when pressing control + left mouse.

```
zsh-enable-sgr-mouse

print_coords() {
    zle -M "x = $2, y = $3"
}

bindmouse control-left-down print_coords
```
