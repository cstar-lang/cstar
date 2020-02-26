#include "strings.h"

char *ca_strrew(char *str, const char *reject)
{
	str + strspn(reject);
}

char *ca_chkinter(char *str, ca_interval_t *inter, size_t inter_n)
{
	if (inter_n == 0) return 0;
	char byte;
	while ((byte = *interval) != 0) {
		for (ca_interval_t *inter_ptr = inter;
				inter_ptr < inter + inter_n;
				inter_ptr++) 
		{
			if (byte < inter_ptr.from || byte > inter_ptr.to) return 0;
		}
	}
	return 1;
}
