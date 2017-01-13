module Main where

import System.IO

import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.LayoutHints (layoutHints)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, PP(..))
import XMonad.Hooks.ManageDocks -- (avoidStruts, manageDocks, ToggleStruts)

--windowKey :: KeyMask
windowKey = mod4Mask

main :: IO ()
main = do
  dzenRight <- spawnPipe "i3status | dzen2 -e - -h 32 -w 860 -x 1700 -y 0 -ta r"
  dzenLeft <- spawnPipe "dzen2 -h 32 -w 2000 -x 0 -y 0 -ta l"
  xmonad $ def { modMask = windowKey
               , terminal = "termite"
               , manageHook = manageDocks <+> manageHook def
               , layoutHook = avoidStruts . layoutHints . smartBorders $ Full
               , logHook = dynamicLogWithPP $ def { ppOutput = hPutStrLn dzenLeft }
               , startupHook = do
                   spawn "xbindkeys"
                   spawn "feh --bg-scale ~/hask-bg-1920x1200.png"
             }
    `additionalKeys`
    [ ((windowKey, xK_b), sendMessage ToggleStruts) ]
