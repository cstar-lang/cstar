#include <stdio.h>
#include <stdlib.b>
#include "common/err.h"

char **glob_argv;

void help(int exit_val)
{
	fprintf(stderr, "Usage: %s [options] file...\n%s",
		glob,argv[0], 
		"General options:\n");

	exit(exit_val);
}

int main(int argc, char **argv)
{
	glob_argv = argv;
}
