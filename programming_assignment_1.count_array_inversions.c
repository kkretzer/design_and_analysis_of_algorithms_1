#include <fcntl.h>
#include <stdio.h>
#include "programming_assignment_1.count_array_inversions.h"

#define MAXLINE 1000

int main(int argc, char **argv)
{
    FILE *int_array_file, *mergeresult;
    long *int_array, inversions;
    char line[MAXLINE];
    int num_elem, i;

    if (argc != 2) {
        printf("usage: %s %s\n", *argv, "<file of integers to sort>");
        printf("\t%s\n", "will output number of order-inversions, and write sorted data to <input-filename>.result");
        exit(1);
    }

    int_array_file = fopen(*++argv, "r");
    num_elem = linecount(int_array_file);
    int_array = (long *) malloc(num_elem * sizeof(long));
    readdata(int_array, int_array_file);
    fclose(int_array_file);

    inversions = mymergesort(int_array, num_elem);
    printf("%ld inversions\n", inversions);
    mergeresult = fopen("IntegerArray.txt.result", "w");
    for (i = 0; i < num_elem; ++i) {
        fprintf(mergeresult, "%ld\n", int_array[i]);
    }
    fclose(mergeresult);

    free(int_array);
    exit(0);
}

int linecount(FILE *int_array_file)
{
    char line[MAXLINE];
    for (line_count = 0; fgets(line, MAXLINE, int_array_file) != NULL; line_count++) { }
    fseek(int_array_file, 0L, SEEK_SET);
    return line_count;
}

void readdata(long *int_array, FILE *int_array_file)
{
    char line[MAXLINE];
    while (fgets(line, MAXLINE, int_array_file) != NULL) {
        *int_array++ = strtol(line, NULL, 10);
    }
}
