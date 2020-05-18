# C\*

## What is C\*?
C\* (aka C-Star or C-Glob) is a language very similar to C, but extends it to classes and polymorphism.

And yeah, it may sound like C++, and grammatically it mostly looks like that, but there are some extensions and changes I have implemented.

I have started writing it because I wanted a fast, object-oriented optimized language which is fully controllable in low-level manner and perfect for OS development being a good replacement of C.  
  
C++ is not bad, but has some problems I want to fix.    
For example, if you use functions from one template class in two .cpp files, then C++ compiler will compile those functions twice for each source file.  
At least, at the end linker will remove duplicates while linking everything to an output, but that doesn't solve the problem of wasted time of compiling the same things.

## How do I want to solve above problem?
C\* compiler will have a flag to parse each object or source file and basing on parsed data define each inclusive  
template function in one global object file named wanted.o for default.  
Finally the linker links wanted.o and each other .o file and then creates final executable file.

C\* will also have a non-flag method to solve this problem. Each template class or single function will be able  
to be defined in one source file. There will be a keyword: 'export' and it will export each class method or  
single function.  
It is an example:
```cg
#include "class.hg"

export foo::class<int>::*
```
To tell a compiler to import class methods or single functions instead of create new static, there will be a  
keyword 'import'. For example:
```cg
#include "class.hg"

import foo:class<int>::*
```
'import' is backward compatible with 'extern', but not vice versa.  
You cannot use 'extern' to express code above.

## Compatibility
C\* is fully back-compatible with C11 and partially with C++11, so you can compile C code using C\* compiler as well.

To be able to extern C++ functions, one has to write: `extern "C++" { ... }`.  
There is no such need for C, because it is natural for C\* - uses the same mangling and conventions.  
But you can do that and it will be even recommended for blocks of code written entirely in C, because then compiler will be able to greatly optimize its work.  
Especially if you compile through C backend.

## Symbol mangling
But what with mangling, because it is inevitable when you implement classes and methods?

Yeah. That's right. Default mangling for classes is `::` and for namespaces `.`.  
But it is changeable.

## File extensions
Language uses .cg for code definition and .hg for declaration.  
.cg is an acronym of C-Glob. Optonal name of the language.  
It is not .cs (from C-Star), because .cs is already occupied by C#.

## Key features
- C\* is designed to be fully configurable in low-level manner.

- User can choose its own symbol mangling for classes, etc.

- This language is written with thought to be comfortable with OS development.
  
- Unicode function and variable names are also possible!

- As a love letter from me to Bash, Perl and other scripting languages, the language features a lot of glob extensions which are intended to ease a programmer's job. 

## Compiler
Basic C\* compiler is written in Perl.

I don't want to create a giant like gcc or clang. Just a simple compiler.

Code of C\* is compiled directly to ELF binary, because of speed.  
Optional method is compiling to NASM, GAS or C and then to binary

Only supported architecture now for direct compiling (each except through C) is x86_64 and i*86.  
It is possible that in the future more architectures will be supported.

## Building
See [building.md](building.md).

## What if you want to involve in the project?
Then great! I will be really thankful if anyone would like to help me with this project.  
If you know Perl and know how computer languages work then you're welcome :-).  
Check out the coding style, make friends with the code and you can act.  
I accept changes as pull requests.

## License
C\* is under GPLv3.  
Copyright (C) Grzegorz Kociołek 2020.
