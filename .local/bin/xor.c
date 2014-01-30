/* Inverts all bits in a file.
 * Written by ayekat in a cold january night in 2014.
 */

#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char **argv)
{
	FILE *src, *dst;
	int a;

	if (argc != 3) {
		fprintf(stderr, "usage: %s SRC DEST\n", argv[0]);
		return EXIT_FAILURE;
	}

	src = fopen(argv[1], "r");
	if (src == NULL) {
		fprintf(stderr, "could not open %s for reading\n", argv[1]);
		return EXIT_FAILURE;
	}
	dst = fopen(argv[2], "r");
	if (dst != NULL) {
		fclose(dst);
		printf("%s already exists, overwrite? [y/N] ", argv[2]);
		a = fgetc(stdin);
		if (a != 'y') {
			return EXIT_FAILURE;
		}
	}
	dst = fopen(argv[2], "w");

	while ((a = fgetc(src)) != EOF) {
		a ^= 0xFF;
		fputc(a, dst);
	}

	fclose(src);
	fclose(dst);
}
