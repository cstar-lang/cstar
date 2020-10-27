# If expressions

If expressions allow you to check a condition in each place requiring a value as rvalue of operators or function arguments.  

```c
int main()
{
	// ...
	int r = if (x) v + 5 else -v;
	foo(r);
}
```

Here it has the same behavior as
```c
int main()
{
	// ...
	int r = x ? v + 5 : -v;
	foo(r);
}
```
Although `if expression` are useful in comparisons with a lot of `else if-s`.  
For example:
```c
int main()
{
	// ...
	int r = if (bar()) 
		        43
		    else if (foo())
			    32
		    else if (dog())
		        10
		    else
		        5;
}
```
With ternary it would be
```c
int main()
{
	// ...
	int r = (bar() ? 43 :
	        (foo() ? 32 :
	        (dog() ? 10 :
	        (5))));
}
```
Both are nice but the second one requires `()` for each more condition.  
Sometimes it can even happen that there are `)))))))))))))))` of closing braces or even more.  
`If expressions` are here a bit cleaner.  
 
## Why do I allow to use more than one solution for a simple problem
The case is that `if` expressions are not OK everywhere.  
Imagine something like this:  
```c
(x ? y : z) = (foo() ? bar() : 0);
```
How it would look like using if expressions:  
```c
(if (x) y else z) = (if (foo()) bar() else 0);
```
Or another example:
```c
foo(x ? y : z);
```
With `if expressions` it would be:
```c
foo(if (x) y else z);
```

In my opinion, `if expressions` are good, but if they are branched to separate lines and for one-liners ternary is the best and cleanest.  
The second thing is that I don't want to remove `ternary` - a thing highly attached and recognizable from C,C++,Java,C# and other languages from the closest C family.  
C\* has not to diverge from it as much as for example Rust.  
I think that programmers are not cavemen and can learn how do `?`, `:` and `if` expressions work.  
Additionally it's absolutely no problem for me to program and maintain these two things in the compiler.  
Let these things complement each other in the language.
