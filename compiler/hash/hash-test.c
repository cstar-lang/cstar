#include "hash.h"
#include <stdint.h>
#include <stdio.h>

int main(int argc, char **argv) 
{
	if (argc < 2) {
		fprintf(stderr, "No argument specified.\n");
	}

	uint32_t result;

	ca_hash_into_u32(&result, argv[1], strlen(argv[1]));
	printf("Hash: 0x%x\n", result);
}
