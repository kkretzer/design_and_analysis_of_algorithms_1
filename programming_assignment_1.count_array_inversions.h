#include <stdlib.h>
#include <string.h>

#define merge_elem(ary,ptr,num) memcpy(ary, ptr, num); \
                                ary += num; \
                                ptr += num;

static size_t merge(void *, size_t, size_t, size_t, int (*compar)(const void *, const void *));

size_t mymergesort(void *input_array, size_t num_elem, size_t elem_width, int (*compar)(const void *, const void *))
{
    size_t l_num_elem, r_num_elem, inversions = 0;

    if (num_elem > 1) {
        l_num_elem = num_elem / 2;
        r_num_elem = num_elem - l_num_elem;

        inversions += mymergesort(input_array, l_num_elem, elem_width, compar);
        inversions += mymergesort(input_array + (l_num_elem * elem_width), r_num_elem, elem_width, compar);
        inversions += merge(input_array, l_num_elem, r_num_elem, elem_width, compar);
    }
    return inversions;
}

static size_t merge(void *to_merge, size_t l_num_elem, size_t r_num_elem, size_t elem_width, int (*compar)(const void *, const void *))
{
    char *l_iter, *r_iter, *l_end, *r_end, *merged;
    size_t inversions = 0, total_bytes = (l_num_elem + r_num_elem) * elem_width;
    int compar_result;

    l_iter = (char *)to_merge;
    r_iter = l_end = l_iter + l_num_elem * elem_width;
    r_end = r_iter + r_num_elem * elem_width;
    merged = (char *) malloc(total_bytes);

    while (l_iter < l_end && r_iter < r_end) {
        compar_result = (*compar)(l_iter, r_iter);
        if (compar_result < 0) {
            merge_elem(merged, l_iter, elem_width);
        } else if (compar_result > 0) {
            merge_elem(merged, r_iter, elem_width);
            inversions += ((l_end - l_iter)/elem_width);
        } else {
            merge_elem(merged, l_iter, elem_width);
            merge_elem(merged, r_iter, elem_width);
        }
    }
    merge_elem(merged, l_iter, l_end - l_iter);
    merge_elem(merged, r_iter, r_end - r_iter);
    merged -= total_bytes;
    memcpy(to_merge, merged, total_bytes);
    free(merged);
    return inversions;
}
