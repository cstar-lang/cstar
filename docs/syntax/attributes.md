# C\* - Attributes and macros

# Introduction

Attributes in C\* are a method to add a special behavior to a function or a structure.  

# Syntax

Attributes are put with a `#` operator and a preceding attribute name.  
They are placed before functions or structure definitions they shall be assigned to.  
For example:
```c
#noreturn
void die()
{
	printf("Bye world :(\n");
	exit(1);
}
```
for a function.  
Here, `noreturn` attribute means that the marked function never returns, because the program execution is ended before.  
This assertion tells the compiler to not generate instructions for returning from a function.  

Another example:
```c
#aligned(16)
struct container {
	char byte;
};
```
for a structure.  
`aligned` means to adjust a structure size to multiply of the given number.  
The example structure, although it has only one byte inside, will be adjusted to be of size 16.

You can find more built-in attributes in `function-attributes.md` and `structure-attributes.md`.

# Custom attributes

Custom attributes are a very powerful feature for meta-programming.   
At the moment there are 2 supported custom attribute types:

- addon
- macro

## Addons
Example of an addon attribute creation and usage:
```c
#addon("struct")
struct funny_variables {
	int d;
	int e;
	int f;
};

#[funny_variables]
struct variables {
	int a;
	int b;
	int c;
};
```
As you can see to create an addon attribute, we place `#addon` before a structure.  
The structure name will be used as an attribute name and its content as an addon.  
When we assign an addon attribute to another structure, the content of an addon will be pasted to the beginning of the assigning structure.

Putting custom attributes have a little different syntax from built-in attributes.  
Their names are enclosed in `[]` brackets.  

Another interesting example:
```c
#addon("struct")
struct funny_variables {
	int d;
	int e;
	int f;
};

struct variables {
	int a;
	#[!funny_variables]
	int b;
	int c;
}
```
The custom attribute can also be placed in the definition of a structure.  
The `!` character must be placed before an attribute name to tell the compiler that the attribute is assigned to the containing structure, not an object it precedes.  
In the current example, the addon will be pasted just after `a` and before `b`.

Addons can also be functions.
```c
#addon("func")
void macro()
{
	a += 42;
	b += 24;
}

void foo()
{
	int a = magic();
	int b = magic2();
	
	#[!macro]
}
```
Function addons are the simplest "copy and paste" as it is possible.  
`#addon` functions must always return `void` and take nothing.


## Macros
And now, something much more powerful: `macro`.  
It allows to create macros of your dreams.

```c
use std.io;
use std.math as math;

#macro("func", "scope")
@TokenStream funny_macro(@TokenStream input, @Token (a, b))
{
	if ($a == 54 * $b) { // this if will fail if $a and $b values
	                     // cannot be obtained in compile time
		@Token var;
		if (input.find_token("v:car")) 
			var.assign("v:car");
		elif (input.find_token("v:dog"))
			var.assign("v:dog");
		else
			@error("Any demanded variable not found in a function {}", input.get_assigner());
			
		if (var.get_type() != float)
			@error("Requested variable of type 'float', got '{}'", var.get_type());
			
		return {
			$var = math.sqrt($var);
		}
	}
	else {
		return {}; // Empty token stream. Macro returns nothing.
	}
}

int main()
{
	float car = magic();
	#[!funny_macro(108,2)]
	
	std.io.print("car is {}", car);
	
}
```

Macros can also be called directly with `name` + `!` + `(args...)`.  
E.g:  
```c
int main()
{
	funny_macro!(@get_token_stream(),108,2);
}

```
For the above example.  
But I don't recommend executing macros that take `TokenStream` this way.  
Calling macros with `#[name(...)]` always passes a `TokenStream` to a macro. It also implies that `#[name(...)]` cannot be logically used for other macros.   

In accordance to the official coding style, use `#[name(...)]` for macros taking `TokenStream` and `name!` for any other macros.  
The compiler will also warn if you use `name!` method for `TokenStream` macros.

Arguments passed to macros can only be `@Token` or `@TokenStream`considering also that the second one may only be the first argument and appear once.    

`@Token` is almost like `alias` language type, but a `@Token` object has methods in it and if a value of a`@Token` object is requested, preceding `$` is required.

Values of `@Token` objects requested by a `$` character in macro blocks can only be obtained if `@Token`:

- points to a variable initialized just before,
- points to a number constant,
- points to a comptime variable.

In other cases, error will be printed by the compiler, because macro blocks are **always** compile time.

`$` in a `@TokenStream` block copies a value assigned to a `@Token` to the token stream.

Think twice before creating macros, because a lot of things can be done **and are better done** using other mechanisms:

- inlines
- comptimes
- generics
- or even`#addon`

Macros are good if you want to explicitly generate code for the compiler.  
For example, using macros, you can create a mechanism for compiling regexes in compile time.  
But:
```c
#macro("func", "scope")
@TokenStream foo(@Token a)
{
	return $a == 32 ? { cat($a); } : { dog($a); };
}
```
is better done with:
```c
inline void foo(comptime int a)
{
	(a == 32) ? cat(a) : dog(a);
}
```
because it will be evaluated to `cat(a)` or `dog(a)` without `(a == 32)` comparison anyway. 


## Epilogue
`#macro` and `#addon` can take following strings as arguments:

- `"func"` - macro can be applied for functions,
- `"scope"` - macro can be applied in scopes,
- `"struct"` - macro can be applied for structures,
- `"outside"`- macro can be applied out of a function or a structure, `#[@macro]` syntax is used.

By default custom attribute can be put for everything.  
If any string is put, it can be used for an object named by a string.  
Each other string increases possibilities.

Methods of `@TokenStream` and `@Token` builtin classes can be find in `builtin-classes.md`.