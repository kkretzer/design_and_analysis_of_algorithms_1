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
    char *l_iter, *r_iter, *l_end, *r_end, *merged;
    size_t inversions;
    int compar_result;
    l_iter = to_merge;
    r_iter = l_end = to_merge + (l_num_elem * elem_width);
    r_end = to_merge + (l_num_elem + r_num_elem)*elem_width;
    inversions = 0;
    merged = (char *) malloc((l_num_elem + r_num_elem) * elem_width);

    while (l_iter < l_end && r_iter < r_end) {
        compar_result = (*compar)(l_iter, r_iter);
        if (compar_result < 0) {
            memcpy(merged, l_iter, elem_width);
            merged += elem_width;
            l_iter += elem_width;
        } else if (compar_result > 0) {
            memcpy(merged, r_iter, elem_width);
            merged += elem_width;
            r_iter += elem_width;
            inversions += ((l_end - l_iter)/elem_width);
        } else {
            memcpy(merged, l_iter, elem_width);
            merged += elem_width;
            l_iter += elem_width;
            memcpy(merged, r_iter, elem_width);
            merged += elem_width;
            r_iter += elem_width;
        }
    }
    memcpy(merged, l_iter, l_end - l_iter);
    merged += l_end - l_iter;
    memcpy(merged, r_iter, r_end - r_iter);
    merged += r_end - r_iter;
    merged -= (l_num_elem + r_num_elem) * elem_width;
    memcpy(to_merge, merged, (l_num_elem+r_num_elem)*elem_width);
    free(merged);
    return inversions;
}
