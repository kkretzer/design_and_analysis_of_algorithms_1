#include <stdlib.h>
#include <string.h>

static size_t merge(char *, size_t, size_t, size_t, int (*compar)(const void *, const void *));

size_t mymergesort(void *input_array, size_t num_elem, size_t elem_width, int (*compar)(const void *, const void *))
{
    size_t l_num_elem, r_num_elem, inversions = 0;

    if (num_elem > 1) {
        l_num_elem = num_elem / 2;
        r_num_elem = num_elem - l_num_elem;

        inversions += mymergesort(input_array, l_num_elem, elem_width, compar);
        inversions += mymergesort(input_array + (l_num_elem * elem_width), r_num_elem, elem_width, compar);
        inversions += merge((char *) input_array, l_num_elem, r_num_elem, elem_width, compar);
    }
    return inversions;
}

static size_t merge(char *to_merge, size_t l_num_elem, size_t r_num_elem, size_t elem_width, int (*compar)(const void *, const void *))
{
    char *l_iter, *r_iter, *l_end, *r_end, *temp, *temp_holder;
    size_t inversions;
    int compar_result, i;
    l_iter = to_merge;
    r_iter = l_end = to_merge + (l_num_elem * elem_width);
    r_end = to_merge + (l_num_elem + r_num_elem)*elem_width;
    inversions = 0;
    temp = (char *) malloc((l_num_elem + r_num_elem) * elem_width);
    temp_holder = temp;

    while (l_iter < l_end && r_iter < r_end) {
        compar_result = (*compar)(l_iter, r_iter);
        if (compar_result < 0) {
            for (i=0; i<elem_width; ++i) {
                *temp = *l_iter;
                ++temp;
                ++l_iter;
            }
        } else if (compar_result > 0) {
            for (i=0; i<elem_width; ++i) {
                *temp = *r_iter;
                ++temp;
                ++r_iter;
            }
            inversions += ((l_end - l_iter)/elem_width);
        } else {
            for (i=0; i<elem_width; ++i) {
                *temp = *l_iter;
                ++temp;
                ++l_iter;
            }
            for (i=0; i<elem_width; ++i) {
                *temp = *r_iter;
                ++temp;
                ++r_iter;
            }
        }
    }
    while (l_iter < l_end) {
        *temp = *l_iter;
        ++temp;
        ++l_iter;
    }
    while (r_iter < r_end) {
        *temp = *r_iter;
        ++temp;
        ++r_iter;
    }
    memcpy(to_merge, temp_holder, (l_num_elem+r_num_elem)*elem_width);
    free(temp_holder);
    return inversions;
}
