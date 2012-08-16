#include <stdlib.h>
#include <string.h>

static long merge(long *, long, long, long *);

long mymergesort(long *int_array, long num_elem)
{
    long l_num_elem, r_num_elem, temp;
    long *copy, inversions = 0;

    if (num_elem <= 1) {
        return 0;
    }

    copy = (long *) malloc(num_elem * sizeof(long));
    memcpy((void *)copy, (void *)int_array, num_elem * sizeof(long));

    l_num_elem = num_elem / 2;
    r_num_elem = num_elem - l_num_elem;
    inversions += mymergesort(copy, l_num_elem);
    inversions += mymergesort(copy + l_num_elem, r_num_elem);

    inversions += merge(copy, l_num_elem, r_num_elem, int_array);

    free(copy);
    return inversions;
}

static long merge(long *to_merge, long l_num_elem, long r_num_elem, long *merged)
{
    long *l_iter, *r_iter, *l_end, *r_end, inversions;
    l_iter = to_merge;
    r_iter = l_end = to_merge + l_num_elem;
    r_end = to_merge + l_num_elem + r_num_elem;
    inversions = 0;

    while (l_iter < l_end && r_iter < r_end) {
        if (*l_iter < *r_iter) {
            *merged++ = *l_iter++;
        } else if (*l_iter > *r_iter) {
            *merged++ = *r_iter++;
            inversions += l_end - l_iter;
        } else {
            *merged++ = *l_iter++;
            *merged++ = *r_iter++;
        }
    }
    if (l_iter < l_end) {
        memcpy((void *)merged, (void *)l_iter, (l_end - l_iter) * sizeof(long));
    } else if (r_iter < r_end) {
        memcpy((void *)merged, (void *)r_iter, (r_end - r_iter) * sizeof(long));
    }
    return inversions;
}
