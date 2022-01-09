syn clear cppStructure
syn region cppNamespaceRegion start=/namespace \w\+ {/ end=/};/ contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cCppParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell
syn keyword cppStructure Structure typename class concept template
syn keyword cppStructureNamespace Structure namespace contained
high link cppStructureNamespace Structure
