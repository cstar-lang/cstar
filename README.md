# C\*

## What is C\*?
C\* (aka C-Star or C-Glob) is a language very similar to C, but extends it to classes and polymorphism.

And yeah, it may sound like C++, and grammatically it mostly looks like that, but there are some extensions and changes I have implemented.

I have started writing it because I wanted a fast, object-oriented optimized language which is fully controllable in low-level manner and perfect for OS development being a good replacement of C.  
  
C++ is not bad, but has some problems I want to fix.    
For example, if you use functions from one template class in two .cpp files, then C++ compiler will compile those functions twice for each source file.  
At least, at the end linker will remove duplicates while linking everything to an output, but that doesn't solve the problem of wasted time of compiling the same things.

## Compatibility
C\* is fully back-compatible with C11 and partially with C++11, so you can compile C code using C\* compiler as well.

To be able to extern C++ functions, you have to write: `extern "C++" { ... }`.  
And to extern C functions `extern "C" { ... }`.

## Symbol mangling
C* uses defaultly its own mangling defined in [docs/mangling.md](docs/mangling.md), but you can easily change it to that C++'s or the own one.

## File extensions
Language uses .cg (source) for code definition and .hg (headers) for declaration.  
But in most cases headers are useless, because C\* uses a concept of modules.  
.cg is an acronym of C-Glob. Optonal name of the language.  
It is not .cs (from C-Star), because .cs is already occupied by C#.

## Key features
- C\* is designed to be fully configurable in low-level manner.

- User can choose its own symbol mangling for classes, etc.

- This language is written with thought to be comfortable with OS development.
  
- Unicode function and variable names are also possible!

- As a love letter from me to Bash, Perl and other scripting languages, the language features a lot of glob extensions which are intended to ease a programmer's job. 

## Compiler
Basic C\* compiler is written in D.

I don't want to create a giant like gcc or clang. Just a simple compiler.

Code of C\* is compiled directly to ELF binary, because of speed.  
Optional method is compiling to NASM, GAS or C and then to binary

Only supported architecture now for direct compiling (each except through C) is x86_64 and i386.  
It is possible that in the future more architectures will be supported.

## More info
Will be added soon.

## Building
See [building.md](building.md).

## What if you want to involve in the project?
That's great! I will be really thankful if anyone would like to help me with this project.  
If you know D and know how computer languages work then you're welcome :-).  
Check out the coding style, make friendship with the code and you can act.  
I accept changes as pull requests.

## License
C\* is under GPLv3.  
Copyright (C) Grzegorz Kociołek 2020.
