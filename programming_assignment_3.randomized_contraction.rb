def min_cut(adj_lists)
    if adj_lists.length == 2
        edge_lists = adj_lists.values
        raise 'you did it wrong' if edge_lists.map {|el| el.length}.uniq.length > 1
        return edge_lists.first.length
    end
    collapse_edge = random_edge(adj_lists)
    new_vertex = collapse_edge[0]*10000 + collapse_edge[1]*100
    first_vertex_neighbors = adj_lists[collapse_edge[0]]
    second_vertex_neighbors = adj_lists[collapse_edge[1]]
    new_neighbor_list = (first_vertex_neighbors + second_vertex_neighbors).reject do |neighbor|
        collapse_edge.member? neighbor
    end
    collapse_edge.each {|v| adj_lists.delete v}
    adj_lists.each_key do |vertex|
        adj_lists[vertex] = adj_lists[vertex].map do |neighbor|
            collapse_edge.member?(neighbor) ? new_vertex : neighbor
        end
    end
    adj_lists[new_vertex] = new_neighbor_list
    min_cut(adj_lists)
end

def random_edge(adj_lists)
    # given adj_lists = { 1=>[2,3],
    #                           2=>[1],
    #                           3=>[1] }
    # edges should end up like:
    #   [ [1,2],
    #     [1,3],
    #     [2,1],
    #     [3,1] ]
    edges = adj_lists.inject([]) do |edges, adj_list| 
        vertex, neighbors = adj_list
        edges.concat neighbors.map {|neighbor| [vertex,neighbor]}
        edges
    end
    edges.sample
end

def adjacency_lists
    File.open(ARGV[0], 'r') do |file|
        file.readlines.inject({}) do |adj_lists, line|
            nums = line.strip.split(/\s+/).map {|s| s.to_i}
            adj_lists[nums.first] = nums[1..(nums.length)]
            adj_lists
        end
    end
end

smallest_min_cut = nil
(0..1000).each do |i|
    min_cut_result = min_cut(adjacency_lists)
    smallest_min_cut ||= min_cut_result
    smallest_min_cut = [smallest_min_cut, min_cut_result].min
end

puts "smallest min cut seen was #{smallest_min_cut}"

