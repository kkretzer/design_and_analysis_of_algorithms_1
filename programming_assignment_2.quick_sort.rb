def sort_and_count_comparisons(int_array, pivot, sort_range, &pivot_chooser)
    comparisons = sort_range.count - 1
    return 0 if comparisons <= 0
    i = sort_range.first + 1
    search_range = (i..(sort_range.last))
    search_range.each do |j|
        if int_array[j] < int_array[pivot]
            int_array[i], int_array[j] = int_array[j], int_array[i]
            i += 1
        end
    end
    int_array[pivot], int_array[i-1] = int_array[i-1], int_array[pivot]
    unless i > sort_range.last
        upper_half_sort_range = (i..(sort_range.last))
        upper_pivot = yield(upper_half_sort_range, int_array)
        comparisons += sort_and_count_comparisons(int_array, upper_pivot, upper_half_sort_range, &pivot_chooser)
    end
    unless sort_range.first > i-2
        lower_half_sort_range = ((sort_range.first)..(i-2))
        lower_pivot = yield(lower_half_sort_range, int_array)
        comparisons += sort_and_count_comparisons(int_array, lower_pivot, lower_half_sort_range, &pivot_chooser)
    end
    comparisons
end

file_array = File.open(ARGV[0], 'r') do |file|
    file.readlines.map {|line| line.to_i}
end

init_sort_range = (0..(file_array.length - 1))

## PART 1
## always pick first element of subarray to be partitioned
#comps = sort_and_count_comparisons(file_array, init_sort_range.first, init_sort_range) do |sort_range, ary|
#    sort_range.first
#end

## PART 2
## always pick the last element of subarray to be partitioned
#def pivot_on_last(sort_range, ary)
#    ary[sort_range.first], ary[sort_range.last] = ary[sort_range.last], ary[sort_range.first]
#    sort_range.first
#end
#
#pivot = pivot_on_last(init_sort_range, file_array)
#comps = sort_and_count_comparisons(file_array, pivot, init_sort_range) do |sort_range, ary|
#    pivot_on_last(sort_range, ary)
#end

## PART 3
# look at the first, middle, and last elements, take the "median of three", use as pivot
def pivot_on_median_of_three(sort_range, ary)
    fidx, midx, lidx = sort_range.first, sort_range.first + sort_range.count/2, sort_range.last
    midx -= 1 if sort_range.count.even?
    f, m, l = ary[fidx], ary[midx], ary[lidx]
    median = fidx if f < [m,l].max and f > [m,l].min
    median = midx if m < [f,l].max and m > [f,l].min
    median = lidx if l < [m,f].max and l > [m,f].min
    median = midx if median.nil? # fidx, midx, lidx are all the same element
    ary[fidx], ary[median] = ary[median], ary[fidx]
    fidx
end

pivot = pivot_on_median_of_three(init_sort_range, file_array)
comps = sort_and_count_comparisons(file_array, pivot, init_sort_range) do |sort_range, ary|
    pivot_on_median_of_three(sort_range, ary)
end


puts comps

# write the sorted list to a file to double check correctness
File.open('/tmp/quicksorted.txt', 'w') {|file| file_array.each {|i| file.puts i}}


