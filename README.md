# Extended C language

### What is C\*?
C\* is a language very very similar to C, but extends it to classes and polymorphism.  
And yeah, it's not C++, but may sound very similar.  
I have started writing it only because I want fast and optimalized language.  
C++ has a lot of problems I want to fix.  
Let's take for example:  
imagine that you have two source files, each defining template function, e.g vector.  
If you defined vector<int> in a.cpp and vector<int> in b.cpp, then a lot of useless doubled functions  
will be merged into final binary file.

### How do I want to fix above problem?
C\* compiler will have a flag to parse each source file and basing of parsed data define each inclusive  
template function in one global object file, let's take that in current example, it has a name 'def.o'  
Finally the linker links def.o and each another .o file and then creates final executable file.  
C\* will also have a non-flag method to solve this problem. Each template class or single function will be able  
to be defined in one source file. There will be a keyword: 'export' and it will export each class method or  
single function.  
It is an example:
```ca
#include "class.ha"

export foo::class<int>::*
```
To tell a compiler to import class methods or single functions instead of create new static, there is a  
keyword 'import'. For example:
```ca
#include "class.ha"

import foo:class<int>::*
```
'import' is backward compatible with 'extern', but not vice versa.  
You cannot use 'extern' to express code above.

### Compatibility
C\* is fully back-compatible with C and partially with C++.  

### File extensions
Language uses .ca for code definition and .ha for declaration

### Nice features
C\* is designed to be fully configurable.  
User can choose its own symbol mangling for classes, etc.  
This language is written with thought to be comfortable with OS development.  
Unicode function and variable names are also possible!  
(But, anyway, who names symbols in languages other than English, hmm)

### Compiler
Code of C\* is compiled directly to machine code, because of speed. Optional method is compiling to NASM or  
GAS and then to machine code.  
Only supported architecture is x86_32 and x86_64, but I plan to extend this to support arm and risc-v.

### License
C\* is under GPLv3 license and its author is Grzegorz Kociołek.
