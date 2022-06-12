"syn clear cppStructure
"syn region cppClassRegion start=/class \w\+ {/ end=/};/ contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cCppParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell containedin=cppNamespaceRegion
"syn region cppNamespaceRegion start=/namespace \w\+ {/ end=/Hallo/ contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cCppParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell
"syn keyword cppStructure Structure typename concept template
"syn keyword cppStructureContained Structure namespace class contained
"high link cppStructureContained Structure
"high link cppClassRegion Structure
"high link cppNamespaceRegion String
