/*
 * Copyright (C) 2020 Grzegorz Kociołek (Dark565)
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#ifndef __TRY_H__
#define __TRY_H__

#include "err.h"
#include <stddef.h>

#define do_call_or_error(inv, type, fun, args, error_fmt, ...) 	\
({								\
 	type ret = fun args; 	 				\
 	if (ret == inv) _ERR(error_fmt, ##__VA_ARGS__);		\
	ret; 							\
})

#define do_call_or_jmp(inv, type, fun, args, jmp_to)		\
({								\
 	type ret = fun args; 	 				\
 	if (ret == inv) goto jmp_to;				\
	ret; 							\
})

#define do_malloc_or_error(size, error_fmt, ...) \
	do_call_or_error(NULL, void*, malloc, (size), error_fmt, ##__VA_ARGS__)

#define do_malloc_or_jmp(size, jmp_to) \
	do_call_or_jmp(NULL, void*, malloc, (size), jmp_to)

#endif
