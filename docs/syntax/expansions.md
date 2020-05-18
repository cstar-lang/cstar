# C\* - expansion

As you could see in structs.md, C\* has something called as **expansions**.  
It is a powerful tool allowing to short the LOC count by writing a simple evaluation.

## Syntax
Expansions may only be written in special brackets: **<** and **>**.  
In these brackets, there is a place for a pattern.  
Pattern is bash-like, so we can define following syntax:

- `v[x:y]` - select objects in an array beginning from v[x] and ending on v[x+y]
- `word0_{1, 2}` - for each word in the curly brackets, paste `word0_` with this word and put comma. If a word is not the last, put a comma in the end
- `word0_(1-5)` - for each number in the interval specified in the curly brackets, paste `word0_` with this number. If number is not the last, put a comma in the end
- `*` - get all variables in the selected scope, so for example `b.<*>` gets all variables in the struct object 'b', `@global_scope.<*>` gets all global variables and single `<*>` gets all local variables
