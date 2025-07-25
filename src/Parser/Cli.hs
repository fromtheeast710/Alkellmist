module Parser.Cli (parseCli) where

import Data.List
import System.Console.GetOpt
import System.Exit
import System.IO

data Flag
  = Help
  | Format
  | Input
  deriving (Eq, Ord, Enum, Show, Bounded)

help :: String
help =
  "Alkellmist v0.1.0 \n\
  \  Usage: alkellmist [-hfi] [string] \n\
  \  Flags: \n\
  \    -h    Show this help message \n\
  \    -f    Chemical format [Smiles/Selfies] \n\
  \    -i    Chemical input \n\\"

flags :: [OptDescr Flag]
flags =
  [ Option ['i'] ["input"] (NoArg Input) "Chemical input",
    Option ['f'] ["format"] (NoArg Format) "Chemical format",
    Option ['h'] ["help"] (NoArg Help) help
  ]

parseCli :: [String] -> IO ([a], [String])
parseCli argv = case getOpt Permute flags argv of
  (args, inputs, []) -> do
    let inp = if null inputs then ["-"] else inputs
    if Help `elem` args
      then do
        hPutStrLn stderr (usageInfo help flags)
        exitSuccess
      else return ([], [])
  -- else return (nub (concatMap set args), files)
  (_, _, errs) -> do
    hPutStrLn stderr (concat errs ++ usageInfo help flags)
    exitWith (ExitFailure 1)
