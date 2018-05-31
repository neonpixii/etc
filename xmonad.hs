import Data.Bits ((.|.))
import Data.Default (def)
import System.Exit (exitWith, ExitCode(..))
import Data.Map (fromList, insert, delete)
import qualified XMonad as Xm


myTerminal :: String
myTerminal = "urxvt"

myModMask :: Xm.KeyMask
myModMask  = Xm.mod4Mask -- super/windows key

{-| Edit oldBinds and newBinds to change xmonad's basic keybindings -}
myKeys :: Xm.XConfig l -> Xm.XConfig Xm.Layout
            -> Data.Map.Internal.Map (Xm.ButtonMask, Xm.KeySym) (Xm.X ())
myKeys conf@(Xm.XConfig {Xm.modMask = mod}) =
  insertThese newBinds $ deleteThese oldBinds $ defaultKeys where
    defaultKeys = (Xm.keys def) conf
    deleteThese ks  m = foldl (\m' k -> delete k m') m ks
    insertThese kvs m = foldl (\m' (k,v) -> insert k v m') m kvs
    shift = Xm.shiftMask
    -- oldBinds are removed before newBinds are added
    -- they represent unwanted keyboard shortcuts
    oldBinds = [ (mod .|. shift, Xm.xK_q)
               , (mod .|. shift, Xm.xK_Return)]
    -- new ((shortcut), action) keybindings go here
    newBinds = [ ((mod .|. shift, Xm.xK_q), Xm.kill)
               , ((mod .|. shift, Xm.xK_e), Xm.io (exitWith ExitSuccess))
               , ((mod, Xm.xK_Return), Xm.spawn $ Xm.terminal conf)
               ]

main :: IO ()
main = do
  -- Note: someRecordValue {record = list} is interpreted as
  -- someRecordValue, but with these replacements
  Xm.xmonad def -- def is the default XConfig
    { Xm.modMask = myModMask
    , Xm.terminal = myTerminal
    , Xm.keys = myKeys
    }

{-
Important haskell concepts in use:
 - The ($) function (function application operator)
 - Qualified imports (Xm.whatever)
 - Record datatypes (Those curly-brace, "name = value" lists)
 - Haskell's very silly-looking preferred indent style for long lists
 - Pattern matching against Record datatypes, like in myKeys
 - do syntax and IO
-}
