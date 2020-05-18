# Defining structs in C\*

## Info
**Structs** are primary container type in C\*.  
There are also **classes**.  
They are absolutely the same except, that they have default protection: **private**, so in this markdown, classes and structs will be named the same way - as structs.

## Protection
| name		| behavior
| ----		| --------
| private	| Data can be only accessible from structure methods' view
| public	| Data is accessible from anywhere
| protected	| Data is private, but it may be inherited

## Defining
Structs are defined like in C:
```c
struct str {
	u32 x, y;
	u8 w = 2, z = 4;
};
```
^- This example shows a simple struct.  
It is a public-scoped struct.  
There are 4 variables in it: x and y of type u32 and w and z of type u8.  
Additionally w and z have default values assigned to them, in sequence: 2 and 4.  

```c
class str {
	u32 priv_var1, priv_var2;
public:
	u32 pub_var1, pub_var2;

	float geo_avg(void)
	{
		return *<{priv,pub}_var{1,2}> ** (1.f/4);
	}
};
```
^- This struct (class) has 4 variables, 2 private and 2 public and also defines a public method: `geo_avg`, which takes no arguments, so **void**.
We can evaluate its syntax into:
```c
float geo_avg(void)
{
	return (priv_var1 * priv_var2 * pub_var1 * pub_var2) ** (1.f/4);
}
```

Such expansions like above were created to shorten writing mathematical operations like above. 
If you think, that it isn't well-readable, don't worry, because it is easy to get use to it and this language was created to be practical and efficient, not cute :-).  
It is exactly the same to what bash does, so if you are familiar with it you know how it goes.  
More info about expansions is in **expansions.md**.

