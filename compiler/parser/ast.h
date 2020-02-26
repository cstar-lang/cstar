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

#ifndef __AST_H__
#define __AST_H__

enum ast_types {
	CA_TYPE_CHAR,
	CA_TYPE_SHORT,
	CA_TYPE_INT,
	CA_TYPE_LONG,
	CA_TYPE_LONG_LONG,

	/* synonims */
	CA_TYPE_I8 = CA_TYPE_CHAR,
	CA_TYPE_I16 = CA_TYPE_SHORT,
	CA_TYPE_I32 = CA_TYPE_INT,
	CA_TYPE_I64 = CA_TYPE_LONG_LONG,

	CA_TYPE_CLASS,
	CA_TYPE_STRUCT,
};

enum ast_value {
	CA_VAL_COMPTIME_STRING,	// "string"
	CA_VAL_INTEGER,		// 123i, 123
	CA_VAL_UINTEGER,	// 123u, 123
	CA_VAL_FLOAT,		// 123.f, 123.0
	CA_VAL_ENUM,		// CA_VAL_ENUM
	CA_VAL_OBJECT		// tree
};

enum ast_comparison_operators {
	CA_CMP_EQUAL,		// ==
	CA_CMP_NOT_EQUAL,	// !=
	CA_CMP_GREATER,		// >
	CA_CMP_LESSER,		// <
	CA_CMP_GREATER_OR_EQUAL,// >=
	CA_CMP_LESSER_OR_EQUAL,	// <=
	CA_CMP_AND,		// &&
	CA_CMP_OR		// ||
};

enum ast_modifying_operators {
	CA_MOD_SET,		// =
	CA_MOD_ADD,		// +
	CA_MOD_SUB,		// -
	CA_MOD_MUL,		// *
	CA_MOD_DIV,		// /
	CA_MOD_REM,		// %
	CA_MOD_REM_SET,		// %=
	CA_MOD_SHR,		// <<
	CA_MOD_SHL,		// >>
	CA_MOD_AND,		// &
	CA_MOD_OR,		// |
	CA_MOD_XOR,		// ^
	CA_MOD_ADD_SET,		// +=
	CA_MOD_SUB_SET,		// -=
	CA_MOD_MUL_SET,		// *=
	CA_MOD_DIV_SET,		// /=
	CA_MOD_SHR_SET,		// >>=
	CA_MOD_SHL_SET,		// <<=
	CA_MOD_AND_SET,		// &=
	CA_MOD_OR_SET,		// |=
	CA_MOD_XOR_SET,		// ^=
	CA_MOD_POST_INC,	// i++
	CA_MOD_PRE_INC,		// ++i
	CA_MOD_POST_DEC,	// i--
	CA_MOD_PRE_DEC,		// --i
	CA_MOD_NEG,		// -i
	CA_MOD_NOT,		// ~
	CA_MOD_ADDITION_NOT,	// !
};

/* Operators extended by C*. There are no such operators in raw C */
enum ast_additional_operators {
	CA_MOD_COMPLETE_TO_DIVISIBLE,		// +%i, for example j +% 1024.
						// operation is equal to `j + 1024 - (j % 1024)`
				
	CA_MOD_SUBTRACT_TO_DIVISIBLE, 		// -%i, for example j -% 1024;
						// operation is equal to `j - (j % 1024)`
				
	CA_MOD_COMPLETE_TO_DIVISIBLE_SET,	// +%=
	CA_MOD_SUBTRACT_TO_DIVISIBLE_SET,	// -%=
	CA_MOD_ROL,				// <|<
	CA_MOD_ROR,				// >|>
	CA_MOD_ROL_SET,				// <|<=
	CA_MOD_ROR_SET,				// >|>=
};

enum ast_keywords {
	CA_KWORD_SIGNED,	// is default for integers
	CA_KWORD_UNSIGNED,	// type modifier; changes behavior for treating integers
	CA_KWORD_IF,
	CA_KWORD_FOR,
	CA_KWORD_WHILE,
	CA_KWORD_DO,
	CA_KWORD_BREAK,
	CA_KWORD_CONTINUE,
	CA_KWORD_CLASS,
	CA_KWORD_STRUCT,
	CA_KWORD_ENUM,
};


/* Preprocessor keywords */
enum ca_preproc_keywords {
	CA_PREPROC_KWORD_DEFINE = 1,
	CA_PREPROC_KWORD_IF,
	CA_PREPROC_KWORD_IFDEF,
	CA_PREPROC_KWORD_IFNDEF,
	CA_PREPROC_KWORD_DEFINED,
	CA_PREPROC_KWORD_UNDEF,
	CA_PREPROC_KWORD_INCLUDE,
}

enum ast_flags {
	CA_AST_COMPATIBILITY_MODE,	// C* parser works just as C parses; C* extended code is an error
};

struct ca_object_info {
	int type;
	const char *name;
};

struct ca_ast {
	int flags;
	void *data;
};


/*
 * Create a new Abstract Syntax Tree with specified flags
 */
int ca_create_ast(struct ast **tree, int flags);
/*
 * Parse the C* code and update the abstract syntax tree
 * If tree is NULL, then new AST with default flags is created
 */
int ca_update_ast(struct ast *tree, const char *code);
/*
 * Free AST from the memory
 */
void ca_free_ast(struct ast *tree);
/*
 * Scan a word and get a identifier
 */
void ca_get_obj_type(struct ast_object_info *obj, const char *word);
/*
 * Scan a word and get a pragma type or 0 if no type was found
 * String must not have any prefix
 */
int ca_get_pragma_type(const char *word);



#endif /* __AST_H__ */;
