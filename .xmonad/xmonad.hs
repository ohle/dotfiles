-- vim:ai
import XMonad
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops
import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Util.NamedScratchpad
import Data.List -- isPrefixOf
import System.IO
-- import Util (startsWith)

myWorkspaces = [ "1:dev", "2:dev", "3:GUI", "4:shells", "5:web", "6:mail/IM",
                 "7:spm", "8:docs", "9:float", "0", "-", "="
               ]

-- -- Solarized Colors
base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green   = "#719e07"

active = green

myManageHook = composeAll [ className =? "Chromium-browser"  --> doShift "5:web"
                          , className =? "Thunderbird"       --> doShift "6:mail/IM"
                          , className =? "Pidgin"            --> doShift "6:mail/IM"
                          , className =? "Mendeley Desktop"  --> doShift "8:docs"
                          , className =? "org-python-util-jython" --> doShift "3:GUI"
                          -- , className =? "com-intellij-rt-execution-application-AppMain" --> doShift "3:GUI"
                          , title `startsWith` "JPK Nano" --> doShift "3:GUI"
                          , manageDocks -- make xmobar etc. visible everywhere
                          -- spawn new windows one below the master pane
                          -- instead of on the master pane, except for
                          -- dialogs
                          , isDialog --> doF W.shiftMaster <+> doF W.swapDown 
                          , className =? "com-jpk-junicam-JUnicam" --> doFloat
                          , title     =? "JUnicam" --> doFloat
                          , className =? "zeal" --> doFloat
                          , className =? "trayer" --> doIgnore
                          ]
               where
                   startsWith :: Eq a => Query [a] -> [a] -> Query Bool
                   startsWith q prefix = fmap (isPrefixOf prefix) q

fullLayout = noBorders $ Full

tiledLayout = noBorders $ spacing 5 $ Tall nmaster delta ratio 
    where
        nmaster = 1           -- # windows in master pane by default
        ratio   = 1.0 / 1.618 -- golden ratio
        delta   = 3/100       -- increment for resize

defaultLayouts = tiledLayout ||| Mirror tiledLayout ||| reflectHoriz tiledLayout ||| fullLayout
        -- tiled = reflectHoriz $ Tall nmaster delta ratio -- master on the right

noMirrorLayouts = tiledLayout ||| fullLayout

-- myLayouts = defaultLayouts
myLayouts = onWorkspaces ["1:dev", "2:dev"] noMirrorLayouts $ onWorkspaces ["9:float"] simpleFloat $ defaultLayouts

scratchpads = [ NS "qutebrowser"  "qutebrowser" (className =? "qutebrowser") nonFloating 
              , NS "zeal" "zeal" (className =? "zeal") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)) ]

main = do
    xmproc <- spawnPipe "/home/claussen/.cabal/bin/xmobar /home/claussen/.xmobarrc"
    xmonad $ ewmh defaultConfig {
          terminal   = "gnome-terminal"
        , workspaces = myWorkspaces
        , startupHook = setWMName "LG3D" -- needed for Java Swing apps
        , manageHook = manageDocks 
                        <+> myManageHook 
                        <+> namedScratchpadManageHook scratchpads 
                        <+> manageHook defaultConfig
        , layoutHook = avoidStruts   $  myLayouts
        , focusedBorderColor = yellow
        , normalBorderColor  = base0
        , borderWidth = 1
        -- logHooks: see http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-DynamicLog.html
        -- , logHook    = fadeInactiveLogHook 0.8 <+>
        , logHook    = takeTopFocus <+> -- fix for some java apps
                       dynamicLogWithPP xmobarPP 
                           { ppOutput  = hPutStrLn xmproc -- pipe to xmobar
                           , ppTitle   = xmobarColor cyan "" . shorten 50
                           , ppCurrent = xmobarColor base03 base01 . wrap "" ""
                           , ppUrgent  = xmobarColor magenta ""
                           , ppLayout  = xmobarColor blue ""
                           , ppSep     = xmobarColor base01 "" " | "
                           }
        , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
        }
        `additionalKeys`
        [
          -- ((mod1Mask, xK_h), sendMessage Expand) -- reverse expand and shrink
        -- , ((mod1Mask, xK_l), sendMessage Shrink) -- to go with mirrored layout
          ((mod1Mask, xK_bracketright), spawn "amixer sset 'Master' 5%+")
        , ((mod1Mask, xK_bracketleft),  spawn "amixer sset 'Master' 5%-")
        , ((mod1Mask, xK_s), spawn "xscreensaver-command -lock")
        , ((mod1Mask, xK_b), namedScratchpadAction scratchpads "qutebrowser")
        , ((mod1Mask, xK_z), namedScratchpadAction scratchpads "zeal")
        ]
