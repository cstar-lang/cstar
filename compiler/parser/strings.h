#ifndef __STRINGS_H__
#define __STRINGS_H__

#include <string.h>

typedef struct ca_interval {
	union {
		char from;
		char to;

		char interval[2];
	};
} ca_interval_t;

/* 
 * String Rewind
 * Get a first byte of the string past all rejected chars in reject
 * If no such byte was found, return NULL
 */
extern char *ca_strrew(char *str, const char *reject);

/*
 * Check if bytes are in a specified interval
 * Interval bytes are placed:
 * interval[0] - interval[1] (1st interval)
 * interval[2] - interval[3] (2nd interval)
 */
#define CA_SINGLE_INTERVAL(x) ((ca_interval_t) { x, x })
extern int *ca_chkinter(char *str, ca_interval_t *inter, size_t inter_n);
#endif
