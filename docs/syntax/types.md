# List of native C\* types

## Basic C integer types
| name			| bit size
| ----			| --------
| bool			| 8
| char			| 8
| short	[int]		| 16
| int			| 32
| long [int]		| target's address size
| long long [int]	| 64
| void			| 0

Words in **[]** means that this word is optional.

Each type can be used as a base for a pointer, for example: `void*`, `char*`, ...  
Pointer itself has the size of **long**.

There are keywords: **signed** and **unsigned**, which change behavior of mathematical operations of integer types.  
When a type is signed, then it can store negative value. Last bit of the variable is reserved for unsigned values, so  
if we have eight bit variable it can be 127 positive numbers, 127 negative numbers, and 1 zero.  
In the other way, unsigned variable doesn't have a division to positive and negative values, so it can be 255 positive numbers and 1 zero.

## Synonims
| name			| C type
| ----			| -------
| i8			| signed char
| i16			| signed short
| i32			| signed int
| ilong			| signed long
| i64			| signed long long
| i128			| __int128
| u8			| unsigned char
| u16			| unsigned short
| u32			| unsigned int
| ulong			| unsigned long
| u64			| unsigned long long
| u128			| unsigned __int128
| u0			| void

## Basic C floating-point types
| name			| bit size
| ----			| --------
| float			| 32
| double		| 64
| long double		| 128

## Synonims
| name			| C type
| ----			| ------
| f32			| float
| f64			| double
| f128			| long double
