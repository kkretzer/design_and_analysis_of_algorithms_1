def merge_and_count_inversions(left_sorted_array, right_sorted_array)
    inversions = 0
    sorted_array = []
    while left_sorted_array.length > 0 and right_sorted_array.length > 0
        if left_sorted_array.first < right_sorted_array.first
            sorted_array << left_sorted_array.shift
        elsif left_sorted_array.first > right_sorted_array.first
            sorted_array << right_sorted_array.shift
            inversions += left_sorted_array.length
        else
            sorted_array << left_sorted_array.shift
            sorted_array << right_sorted_array.shift
        end
    end
    if left_sorted_array.length > 0
        sorted_array.concat left_sorted_array
    elsif right_sorted_array.length > 0
        sorted_array.concat right_sorted_array
    end
    [inversions, sorted_array]
end

def sort_and_count_inversions(int_array)
    num_ints = int_array.length
    if num_ints > 2
        mid = int_array.length/2
        left_array = int_array[0..(mid-1)]
        right_array = int_array[mid..int_array.length]
        left_inversions, left_sorted_array = sort_and_count_inversions(left_array)
        right_inversions, right_sorted_array = sort_and_count_inversions(right_array)
        merged_inversions, sorted_array = merge_and_count_inversions(left_sorted_array, right_sorted_array)
        inversions = merged_inversions + left_inversions + right_inversions
    elsif num_ints == 1
        inversions = 0
        sorted_array = int_array
    else
        if int_array.first <= int_array.last
            inversions = 0
            sorted_array = int_array 
        else
            inversions = 1
            sorted_array = [int_array.last, int_array.first]
        end
    end
    [inversions, sorted_array]
end

file_array = File.open(ARGV[0], 'r') do |file|
    file.readlines.map {|line| line.to_i}
end
puts sort_and_count_inversions(file_array).first
