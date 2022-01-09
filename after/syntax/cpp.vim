
syn clear cppStructure
syn region cppNamespaceRegion start=/namespace \w\+ {/ end=/};/ contains=ALL 
syn keyword cppStructure Structure typename class concept template
syn keyword cppStructureNamespace Structure namespace contained
"igh link cppStructureNamespace Structure
