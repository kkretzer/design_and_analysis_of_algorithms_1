static void swap(char *, char *, size_t);
static void pivot(char *, size_t, size_t, int (*compar)(const void *, const void *));

size_t myquicksort(void *input_array, size_t num_elem, size_t elem_width, int (*compar)(const void *, const void *))
{
    size_t comparisons = num_elem - 1;
    char *boundary, *curr_elem, *data;

    if (comparisons <= 0) {
        return 0;
    }

    data = (char *) input_array;
    pivot(data, num_elem, elem_width, compar);
    curr_elem = boundary = data + elem_width;
    while (curr_elem < (data + (num_elem * elem_width))) {
        if ((*compar)(curr_elem, data) < 0) {
            swap(curr_elem, boundary, elem_width);
            boundary += elem_width;
        }
        curr_elem += elem_width;
    }
    swap(data, boundary-elem_width, elem_width);

    size_t lower_num_elem = (boundary - data) / elem_width;
    if (lower_num_elem > 1) {
        comparisons += myquicksort((void *)data, lower_num_elem-1, elem_width, compar);
    }
    if (num_elem > lower_num_elem) {
        comparisons += myquicksort((void *)boundary, num_elem - lower_num_elem, elem_width, compar);
    }
    return comparisons;
}

static void pivot(char *data, size_t num_elem, size_t elem_width, int (*compar)(const void *, const void *))
{
    /* using median of three to match programming_assignment_2 */
    /* pivot value will be moved to the first position in the data array */
    char *first = data;
    char *mid = data + (num_elem/2) * elem_width;
    char *last = data + (num_elem-1) * elem_width;
    if (!(num_elem & 1)) {
        mid -= elem_width;
    }
    if (((*compar)(mid, first) >= 0 && (*compar)(mid, last) <= 0) ||
        ((*compar)(mid, last) >= 0 && (*compar)(mid, first) <= 0)) {
        swap(first, mid, elem_width);

    } else if (((*compar)(last, first) >= 0 && (*compar)(last, mid) <= 0) ||
               ((*compar)(last, mid) >= 0 && (*compar)(last, first) <= 0)){
        swap(first, last, elem_width);
    }
}

void swap(char *l, char *r, size_t w)
{
    if (l != r) {
        while (w-- > 0) {
            *l ^= *r;
            *r ^= *l;
            *(l++) ^= *(r++);
        }
    }
}
