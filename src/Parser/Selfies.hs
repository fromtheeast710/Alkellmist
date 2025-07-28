{-# LANGUAGE LambdaCase #-}

module Parser.Selfies (parseSeflies) where

import Chemical.Atom
import Control.Applicative
import Data.Char
import GHC.TypeLits

data Value
  = Atom String
  | Bond Nat
  | Branch [Value]
  | Ring [Value]
  deriving (Show)

-- TODO: use Either for proper error handling
data Error = Error Int String deriving (Show)

newtype Parser a = Parser {runParser :: String -> Maybe (String, a)}

instance Functor Parser where
  fmap f (Parser p) = Parser $
    \i -> do
      (i', c) <- p i
      Just (i', f c)

instance Applicative Parser where
  pure c = Parser $ \i -> Just (i, c)
  (Parser p1) <*> (Parser p2) = Parser $
    \i -> do
      (i', f) <- p1 i
      (i'', c) <- p2 i'
      Just (i'', f c)

instance Alternative Parser where
  empty = Parser $ const Nothing
  (Parser p1) <|> (Parser p2) = Parser $
    \i -> p1 i <|> p2 i

charP :: Char -> Parser Char
charP c = Parser $
  \case
    h : t | h == c -> Just (t, c)
    _ -> Nothing

stringP :: String -> Parser String
stringP = traverse charP

scopeP :: String -> Parser String
scopeP s = charP '[' *> stringP s <* charP ']'

-- TODO: parse all natural numbers
structP :: String -> Parser Nat
structP k =
  charP '[' *> stringP k *> (read . (: []) <$> oneOf "12345") <* charP ']'
  where
    oneOf = foldr ((<|>) . charP) empty

parseAtom :: Parser Value
parseAtom = Atom <$> asum (map scopeP $ symbol <$> atomList)

parseBond :: Parser Value
parseBond = Bond <$> (expl <|> impl)
  where
    expl = structP "bond"
    impl = undefined

parseBranch :: Parser Value
parseBranch = Branch <$> undefined

parseRing :: Parser Value
parseRing = undefined

parseValue :: Parser Value
parseValue = parseAtom <|> parseBond <|> parseBranch <|> parseRing

parseSeflies :: String -> Maybe [Value]
parseSeflies "" = Just []
parseSeflies s = (:) <$> t <*> b
  where
    val = runParser parseValue s
    t = snd <$> val
    b = parseSeflies . fst =<< val
