def sort_and_count_comparisons(int_array, pivot, sort_range)
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
    comparisons += sort_and_count_comparisons(int_array, i, (i..(sort_range.last)))
    #puts "recursing on lower half"
    comparisons += sort_and_count_comparisons(int_array, sort_range.first, ((sort_range.first)..(i-2)))
    comparisons
end

def choose_pivot_always_first(sort_range)
    sort_range.first
end


file_array = File.open(ARGV[0], 'r') do |file|
    file.readlines.map {|line| line.to_i}
end

init_sort_range = (0..(file_array.length - 1))

puts sort_and_count_comparisons(file_array, choose_pivot_always_first(init_sort_range), init_sort_range)

# write the sorted list to a file to double check correctness
File.open('/tmp/quicksorted.txt', 'w') {|file| file_array.each {|i| file.puts i}}
