# C\* - Aliases

## Redirecting Operators

Actually, C\* doesn't have such thing as generating a special function for an operator overloading like C++ does.  
Instead it allows to redirect an operator to another function in compile time.


```c
struct str {
private:
	int a;
	int b;
public:
	void add(int _b) {.a += _b;}
	alias { += [int] } = add;
	
	...
}
```
For operator aliases, `alias`' lvalue must be in `{}` brackets.   
`[int]` after `+=` means to redirect an operator only if rvalue is of type int.  
Optionally an lvalue may be specified in the above example. It would be `[&]`.  
`[&]` in our case means that the lvalue must be a pointer to a struct object the `alias` keyword is in.  
We cannot specify an lvalue other than `[&]` or the pointer type to the current container in a struct.  
If lvalue is not specified, `[&]` is default.
  
There are a few operators that can't be redirected because of security and readability.  
Those are:

- & (in the context of address getting - those people which actually redirect this operator in C++ probably are close satan friends)

Also, because of security we can't redirect operators that take the standard types as lvalues and rvalues, e.g  
`[int] + [int]`,
 but  
`[int] + [MyStruct]` or obviously vice versa are actually allowed.
 
 All assigning operators (suffixed with =) return a reference to the lvalue.  
 C++ does it wrong in my opinion, because code reader seeing `SomeStruct abc = ...; foo(abc += 1);`  
  doesn't know if they should expect type of `abc` on return or maybe something other.  
 `=` in the suffix says clearly - "I assign the result to the lvalue, so I give you lvalue".
 
## Redirecting identifiers
Another usage of the `alias` keyword is to redirect identifiers to other ones.  
Example:
```c
void foo() { ... }
alias bar = foo;
```
Now doing `bar()` will be expanded to `foo()`.

  
**Warning**: If an alias overlaps an identifier that exists (except of operators), compiler prints a warning and finally the alias is used in the current compilation unit.  
You can treat that as error with `-Werror=overlapping-alias`.  

## Expanding alias
Sometimes, you'd require to get a value the operator alias points to.  
For this case, the `expand_alias` bultin keyword exists.  
It returns an unnamed alias.   
It can be used for everything that normal alias can be.

This keyword is useful in situations like this:
```c
// defined in module.cgm
struct MyStr {
private:
	int a;
public:
	void add(int b) { .a += b; }
	alias { += [int] } = add;
	...
}

// defined in main.cg
int main()
{
	MyStr str = ...;
	auto fn = &expand_alias{ MyStr::+= [int] };
	...
	str.(fn)(43);
}
```
So in the other words when a structure is opaque and you want to take a pointer to the method implementing a operator.  
In C\* you can't do `auto fn = MyStr::+= [int]`, because.. look at it yourself. It's completely surreal and the compiler of course doesn't support that.  
On the other hand, all `alias` implementing keywords has a special syntax in `{}` so we can sort normal C\* syntax from the "alias" syntax.

`alias` is just like a type, but compile time, but you can't put it in if like `if (some_alias)` to check if it is valid.  
Once an alias was initialized (even with empty value e.g when `expand_alias` failed), it is treated as an identifier by `if()`  
so checking them that way is meaningless, because we would get simply the value of a variable this identifier names.  
So to check the `alias` validity we have to use the builtin function `defined()` which is documented in `validity-checking.md`   
Using `defined()`, we can do for example:
```c
int main()
{
	MyStr str = ...;
	alias add_a1 = expand_alias{ MyStr::+= [int] };
	if (defined(add_a1)) {
		...
	}
	else {
		static_error("Backend for the += operator in MyStr is not defined!");
	}
}
```
This does what you may guess it does.  
There exists also the `try_expand_alias` keyword to directly check the alias validity without the `defined()` overhead.  

To stringize alias targets, there is the `alias_literal` keyword.  
Returns `nullptr` if alias is undeclared.

## Alias & macros

You can declare functions with `alias` as a return type.  
Such function is completely compile-time.  
Example of such function:
```c
alias get_name(int x, int y) {
	return x > y ** 2 ? foo : bar;
}
```
You can also have alias arguments.  
Then unless return type is alias, a function will be generic.
```c
alias get_name(alias x, alias y) {
	if ( alias_literal(x) == "foo" ||
	     alias_literal(y) == "bar" )
		return dog;
	else
		return cat;
}
```
Such functionality is ideal for macro creation.

## Aliasing keywords

It is possible to create an alias to an identifier named like a builtin language keyword.  
In this case, the `alias`' target will be always treated as an identifier, not a keuword.
```c
void @"alias"(int a, int b)
{
	...
}

alias __alias = alias;

int main()
{
	__alias(3,4);
}

```
In the code above, we define a function `alias` that is called from main using a `__alias` redirection.  
One important clause to note, we can't use aliases to name variables and functions because of restrictions.  
The only possibility is to use 'at' operator with a constant string. It will be evaluated to an identifier.  
More info about 'at' operator aka `attribute` operator in C\* is in `attributes.md`.

## Remember

`alias` is **compile-time**!  
Don't confuse it with dynamic references.  
You can't do:
```c
int main()
{
	int a = foo();
	alias func = match (a) {
		0 .. 10 => bar;
		      * => bar2;
	}
}
```
because the value of a is not known during compilation.
