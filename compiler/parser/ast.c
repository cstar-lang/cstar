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

#include "ast.h"
#include "strings.h"
#include "common/err.h"
#include "common/try.h"
#include "common/strings.h"
#include <stdlib.h>
#include <string.h>


int ca_create_ast(struct ca_ast **tree_p, int flags)
{
	*tree_p = do_malloc_or_jmp(sizeof(struct ca_ast), err);

	restrict struct ca_ast *tree = *tree_p;

	tree->flags = flags;
	tree->scopes = do_malloc_or_jmp(sizeof(struct ca_scope), clean);
	tree->scopes[0].scope_creator = CA_AST_GLOBAL_SCOPE_CREATOR;
	tree->scopes[0].instructions = NULL;
	return 0;

clean:
	free(tree);
err:
	_ERR("Fatal error: cannot allocate data for the ast");
}

static ca_interval_t ca_std_inter[]= {
	CA_SINGLE_INTERVAL('_'),
	{'a', 'z'},
	{'A', 'Z'},
	{'0', '9'},
};

static char ca_space_bytes[] = "\x20\x09"

int ca_get_pragma_type(const char *word)
{

}

void ca_get_obj_type(struct ast_object_info *obj, const char *word)
{	
	if (ca_chkinter(word, ca_std_inter, ca_arraysize(ca_std_inter))) {
		/* Identifier, type or pragma */
		if (word[0] = '#') {
			word++;

			strcmp

			obj->type |= (CA_TYPE_PRAGMA << 0);
		}
	}
	else if (*word == '#') {
		/* Pragma */
	}
}

int ca_update_ast(struct ca_ast **tree_p, const char *code)
{
	if (code == NULL)
		return ca_create_ast(tree_p, 0);

	while (1) {
		char *word = ca_strrew(code, space_bytes);
		size_t word_size = strcspn(code, space_bytes);
		char *copy = strndup(word, word_size);

		struct ca_object_info obj;
		ca_get_obj_info(&obj, copy);


	}
	


}a
