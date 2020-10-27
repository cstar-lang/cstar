# Experimental features

Experimental features are things that may be implemented, but for now they are only for consideration.  
Here they are documented and described.

## Unicode optional operators
In 2020 year, UTF-8 and full Unicode is supported by almost any font.  
Why then, couldn't we add some of operators defined by it.  
This is the list of interesting operators that would be added to the language:
  
| operator     | example | behavior
| ----         | ----    | ----
| ²            | x²      | x ** 2
| ³            | x³      | x ** 3
| ½            | ½x      | x / 2

Example of code using these operators:
```c
use std:string as : ;
use std:math as math;
use std:io;
use std:assert;

int main(int argc, char **argv)
{
	std:assert!(argc > 1);
	
    str coord_s = argv[1];
    double (x, y) = coord_s.scan("{}:{}").?;
   
    double d = math:sqrt(x² + y²);
    std:io:print("Diagonal is: {.2}\n", d);
    std:io:print("Field of a circle with the above diagonal: {.2}\n", math:PI * (½d)²);
}
```