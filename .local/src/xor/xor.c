/* Inverts all bits in a file.
 * Written by ayekat in a cold january night in 2014.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

int
main(int argc, char **argv)
{
	FILE *f;
	int d, k;

	if (argc > 2) {
		fprintf(stderr, "usage: %s [KEYFILE]\n", argv[0]);
		return EXIT_FAILURE;
	}

	/* no argument, swap all bits */
	if (argc == 1) {
		while ((d = getchar()) != EOF) {
			putchar(d ^ 0xFF);
		}
	}

	/* file specified, read content */
	else {
		f = fopen(argv[1], "r");
		if (f == NULL) {
			fprintf(stderr, "could not open %s for reading: %s",
					argv[1], strerror(errno));
			return EXIT_FAILURE;
		}

		while ((d = getchar()) != EOF) {
			if ((k = fgetc(f)) == EOF) {
				rewind(f);
				if ((k = fgetc(f)) == EOF) {
					fprintf(stderr, "cannot use %s as key: file is empty\n",
							argv[1]);
					return EXIT_FAILURE;
				}
			}
			putchar(d ^ k);
		}
		fclose(f);
	}
	return EXIT_SUCCESS;
}

