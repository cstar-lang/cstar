#ifndef __HASH_H__
#define __HASH_H__

#include <stdint.h>
#include <string.h>

/*
 * Hash data into 32 bit value. Data must be 4-byte aligned.
 * If not, hashing function will fill missing bytes like this:
 * If data was: 0xab 0xcd 0xef, hasher will align it to: 
 * 0xab, 0xcd, 0xef, 0xef and finally hash
 */
int ca_hash_into_u32(uint32_t *result, const void *data, size_t data_n);

#endif
