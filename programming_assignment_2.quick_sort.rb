def sort_and_count_comparisons(int_array, pivot, sort_range, &pivot_chooser)
    #puts "\t" + sort_range.to_s
    comparisons = sort_range.count - 1
    return 0 if comparisons <= 0
    i = sort_range.first + 1
    search_range = (i..(sort_range.last))
    search_range.each do |j|
        if int_array[j] < int_array[pivot]
            tmp = int_array[i]
            int_array[i] = int_array[j]
            int_array[j] = tmp
            i += 1
        end
    end
    tmp = int_array[pivot]
    int_array[pivot] = int_array[i-1]
    int_array[i-1] = tmp
    #puts "recursing on upper half"
    upper_half_sort_range = (i..(sort_range.last))
    comparisons += sort_and_count_comparisons(int_array, yield(upper_half_sort_range), upper_half_sort_range, &pivot_chooser)
    #puts "recursing on lower half"
    lower_half_sort_range = ((sort_range.first)..(i-2))
    comparisons += sort_and_count_comparisons(int_array, yield(lower_half_sort_range), lower_half_sort_range, &pivot_chooser)
    comparisons
end

file_array = File.open(ARGV[0], 'r') do |file|
    file.readlines.map {|line| line.to_i}
end

init_sort_range = (0..(file_array.length - 1))

puts sort_and_count_comparisons(file_array, init_sort_range.first, init_sort_range) {|sort_range| sort_range.first}

#puts sort_and_count_comparisons(file_array, init_sort_range.last, init_sort_range)

# write the sorted list to a file to double check correctness
File.open('/tmp/quicksorted.txt', 'w') {|file| file_array.each {|i| file.puts i}}
