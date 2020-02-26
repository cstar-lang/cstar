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

#ifndef __ERR_H__
#define __ERR_H__

#include <stdlib.h>
#include <stdio.h>

#define _ERR(format, ...) 									\
{												\
	fprintf(stderr, "%s:%s:%u: "format"\n", __FILE__, __func__, __LINE__, ##__VA_ARGS__);	\
	exit(1);										\
}


#define _COMPILER_ERR_NODEF(format, ...)							\
{												\
	fprintf(stderr, "%s%s %s:%u:%s"format"\n",						\
		s_color_red, s_compiler_error, __FILE__, __func__,				\
		__LINE__, ##__VA_ARGS__);							\
	exit(1);										\
}

#define _COMPILER_ERR(format, ...)								\
	_COMPILER_ERR_NODEF("%s: "format, s_color_def, ##__VA_ARGS__);

#ifdef __CA_DBG_ENABLED
	#define _DBG(format, ...)								\
	{											\
		fprintf(stderr, format"\n", ##__VA_ARGS__);					\
	}
#else
	#define _DBG(format, ...)
#endif

#endif /* __ERR_H__ */
