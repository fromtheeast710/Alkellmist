module Chemical.Bond where

data Bond = Single | Double | Triple | Quadruple deriving (Show, Read, Eq)

writeBond :: Bond -> Char
writeBond Single = '-'
writeBond Double = '='
writeBond Triple = '#'
writeBond Quadruple = '$'
