#include "hash.h"
#include "common/err.h"

#include <stdio.h>

int ca_hash_into_u32(uint32_t *result, const void *data, size_t data_n)
{
	if (result == NULL || data == NULL || data_n == 0) return 0;
	uint8_t unaligned = data_n % 4;

	for (const uint32_t *data_u32 = (const uint32_t*)data; 
			data_u32 < (uint32_t*)(data + (data_n - unaligned));
			data_u32 ++)
	{
		*result ^= *data_u32;
	}
	if (unaligned) {
		uint8_t to_align = 4 - unaligned;
		const char *unaligned_begin = data + data_n - unaligned;
		uint32_t missing;
		_DBG("unaligned: %hhu, to_align: %hhu", unaligned, to_align);

#ifdef __CA_HASH_MEMCPY_MEMSET

		memcpy(&missing, unaligned_begin, unaligned);
		memset(&missing+unaligned, unaligned_begin[unaligned-1], to_align);
		*result ^= missing;
#else
		const char *unaligned_ptr = unaligned_begin - 1;
		char *hash_byte_ptr = (char*)result;
		_DBG("unaligned begin: %p", unaligned_begin);
		_DBG("loop1");
		for (hash_byte_ptr; hash_byte_ptr < (char*)result + unaligned; hash_byte_ptr++) {
			unaligned_ptr++;
			_DBG("hash_byte_ptr: %p (%c), unaligned_ptr: %p (%c)", hash_byte_ptr, *hash_byte_ptr, unaligned_ptr, *unaligned_ptr);
			*hash_byte_ptr ^= *unaligned_ptr;
		}
		_DBG("loop2");
		for (hash_byte_ptr; hash_byte_ptr < (char*)result + 4; hash_byte_ptr++) {
			_DBG("hash_byte_ptr: %p (%c), unaligned_ptr: %p (%c)", hash_byte_ptr, *hash_byte_ptr, unaligned_ptr, *unaligned_ptr);
			*hash_byte_ptr ^= *unaligned_ptr;
		}
#endif
	}

	return 1;
}
