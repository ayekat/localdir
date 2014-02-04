/* Inverts all bits in a file.
 * Written by ayekat in a cold january night in 2014.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int
main(int argc, char **argv)
{
	size_t pos, len;
	char *data;
	int c;

	if (argc > 2) {
		fprintf(stderr, "usage: %s [STRING]\n", argv[0]);
		return EXIT_FAILURE;
	} else if (argc == 2) {
		data = argv[1];
		len = strlen(data);
	} else {
		data = malloc(1);
		data[0] = 0xFF;
		len = 1;
	}

	pos = 0;
	while ((c = getchar()) != EOF) {
		putchar(c ^ data[pos]);
		pos = (pos+1)%len;
	}
}

