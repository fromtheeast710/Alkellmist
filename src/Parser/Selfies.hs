module Parser.Selfies () where

import GHC.TypeLits

data Value
  = Atom (Nat, String)
  | Bond Nat
  | Ring Nat (Maybe String)
  | Branch Selfies
  | Scope Value
  deriving (Show, Eq)

newtype Selfies = Selfies {getSelfies :: [Value]}
  deriving (Show, Eq)

newtype Parser a = Parser
  {runParser :: String -> Either (Int, String) (String, a)}

-- parseSelfies :: Parser Value
-- parseSelfies = Parser (Bond 9)
