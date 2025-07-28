= Modified SelfIES Schema

$
  "Number" n in& NN
\ "Symbol" s in& {"H", "He", "Li", ..., "Og"}
\ "Expression" e ::=& [e]
                  \ &| s
                  \ &| "bond" n
                  \ &| "branch" n
                  \ &| "ring" n
$

== Example

+ Diethyl Ether: `[C][C][O][C][C]`

+ Benzene: `[ring 6][C][bond 2][C][C][bond 2][C][C][bond 2][C]`

+ Ethyl Cyclopentane: `[ring 5][C][C][C][C][C][C][C]`

+ Isopentane: `[C][branch 1][C][C][C][C]`
