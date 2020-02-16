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
	CA_VAL_ENUM,		// CA_ENUM
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
	CA_MOD_WRAPPING_ADDITION,		// +%i, for example j +% 1024.
						// operation is equal to `j + 1024 - (j % 1024)`
				
	CA_MOD_WRAPPING_SUBSTRACTION, 		// -%i, for example j -% 1024;
						// operation is equal to `j - (j % 1024)`
				
	CA_MOD_WRAPPING_ADDITION_SET,		// +%=
	CA_MOD_WRAPPING_SUBSTRACTION_SET,	// -%=
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

struct ast {
	int flags;
	void *data;
};

/*
 * Create a new Abstract Syntax Tree with specified flags
 */
int create_ast(struct ast **tree, int flags);
/*
 * Update an Abstact Syntax Tree of the current C* code
 * If tree is NULL, then new AST with default flags is created
 */
int update_ast(struct ast *tree, const char *code);
/*
 * Free AST from the memory
 */
void free_ast(struct ast *tree);


#endif /* __AST_H__ */;
