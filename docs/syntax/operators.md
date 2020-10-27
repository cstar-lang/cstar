# List of C\* operators

## Note
> Code in examples and the `program behavior` column is pseudo-code used for presentation, not C\* itself.
See pseudo-code.md for information about the pseudo-code used in the documentation.

> Some behavior needs to present a value with specific binary size, so ux is its size, where x is a count of bits in the variable.

> Truth applied in some names of operators means each value not equal to 0 (which itself is false).

### Two-argument
| operator	| name			| syntax	| program behavior
| --------	| --------		| -------	| ---------------------
| =		| set			| x = y		| set x to y
| + 		| add			| x + y		| 2 + 3 = 5
| -		| substitude		| x - y		| 2 - 3 = -1
| \*		| multiply		| x * y		| 2 * 3 = 6
| /		| divide		| x / y		| `2 / 3 = 0` and `2.f / 3.f = 0.6f`
| \*\*		| power			| x \*\* y	| 2 \*\* 3 = 8 
| %		| modulo		| x % y		| 2 % 3 = 2
| &		| logical and		| x & y		| 2 & 3 = 2
| \|		| logical or		| x \| y	| 2 \| 3 = 3
| ^		| logical xor		| x ^ y		| 2 ^ 3 = 1
| <<		| logical shift left	| x << y	| u8(2) << 3 = 16
| >>		| logical shift right	| x >> y	| u8(2) >> 3 = 0
| <\|<		| logical rotate left	| x <\|< y	| u8(2) <\|< 3 = 16
| >\|>		| logical rotate right	| x >\|> y	| u8(2) >\|> 3 = 64
| +%		| wrapping add		| x +% y	| 17439 +% 4096 = 20480
| -%		| wrapping substitude	| x -% y	| 17439	-% 4096 = 16384

Each of above operators except obviosuly '=' has also an equivalent with '=', which means to directly set the left value to the calculated result and then evaluate the result. 
For example:  
`if i = 2, then doing (i += 2) = 4, next i = 4`

### Single-argument
| operator	| name			| syntax	| program behavior
| --------	| --------		| -------	| ----------------
| ++		| increment		| x++, ++x	| `if a = 2, then doing a++ = 2, next a = 3` and `if a = 2, then doing ++a = 3, next a = 3`
| --		| decrement		| x--, --x	| `if a = 2, then doing a-- = 2, next a = 1` and `if a = 2, then doing --a = 1, next a = 1` 
| !		| truth negate		| !x		| `!2 = 0` and `!0 = 1`
| ~		| binary negate		| ~x		| ~u8(2) = 253
| +		| positive value	| +x		| +2 = 2
| -		| negative value	| -x		| -2 = -2

### Comparisons
| operator	| name			| syntax	| program behavior
| --------	| --------		| -------	| ----------------
| ==		| equal			| x == y	| 1 == 2 = 0
| !=		| not equal		| x != y	| 1 != 2 = 1
| >=		| greater or equal	| x >= y	| 1 >= 2 = 0
| <=		| lesser or equal	| y <= y	| 1 <= 2 = 1
| >		| greater		| x > y		| 1 > 2 = 0
| <		| lesser		| x < y		| 1 < 2 = 1
| &&		| truth and		| x && y	| 1 && 0 = 0
| \|\|		| truth or		| x \|\| y	| 1 \|\| 0 = 1
| \<=\>		| three-way comparison  | x \<=\> y     | 4 \<=\> 10 = -1
