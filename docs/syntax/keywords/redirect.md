# Keyword - redirect

## Example

```c
int foo()
{
	return 43;
}

int bar()
{
	redirect foo();
}
```

## Description
`redirect` keyword will do the following operations:

- Destruct all local variables
- Moves `rsp` to `rbp`
- Pops `rbp`
- Jumps to the target

It allows to optimize functions that call other functions and return immediately.