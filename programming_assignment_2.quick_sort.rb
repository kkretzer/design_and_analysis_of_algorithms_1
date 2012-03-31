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

# always pick first element of subarray to be partitioned
#comps = sort_and_count_comparisons(file_array, init_sort_range.first, init_sort_range) do |sort_range, ary|
#    sort_range.first
#end


# always pick the last element of subarray to be partitioned
file_array[0], file_array[file_array.length - 1] = file_array[file_array.length - 1], file_array[0]
comps = sort_and_count_comparisons(file_array, init_sort_range.first, init_sort_range) do |sort_range, ary|
    ary[sort_range.first], ary[sort_range.last] = ary[sort_range.last], ary[sort_range.first]
    sort_range.first
end


puts comps

# write the sorted list to a file to double check correctness
File.open('/tmp/quicksorted.txt', 'w') {|file| file_array.each {|i| file.puts i}}


