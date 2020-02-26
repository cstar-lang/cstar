#ifndef __STRINGS_H__
#define __STRINGS_H__

#define ca_arraysize(x) (sizeof(x) / sizeof(*x))

#define COLOR_RED "\e[1;21m"
#define COLOR_DEF "\e[0m"

extern const char s_color_red[];
extern const char s_color_def[];

extern const char s_compiler_error[];

#endif
