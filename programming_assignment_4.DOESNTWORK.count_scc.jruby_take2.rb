require 'pp'
require 'set'

def log msg
    puts "#{Time.now} :: #{msg}"
end

def read_graphs_from_file
    forward_adjacency_lists, reversed_adjacency_lists = {}, {}
    vertices = Set.new([])
    File.open(ARGV[0], 'r') do |file|
        file.readlines.each do |line|
            vertex, neighbor = line.strip.split(/\s+/).map {|s| s.to_i}
            vertices << vertex
            vertices << neighbor
            forward_adjacency_lists[vertex] ||= []
            forward_adjacency_lists[vertex] << neighbor
            reversed_adjacency_lists[neighbor] ||= []
            reversed_adjacency_lists[neighbor] << vertex
        end
    end
    [forward_adjacency_lists, reversed_adjacency_lists, vertices]
end

@@t = 0
@@s = nil
@@f = {}
@@leader = {}
@@explored = Set.new([])
def strongly_connected_components(forward_graph, reverse_graph, vertices)
    vertices.sort.reverse!.each do |i|
        if !@@explored.member?(i)
            @@s = i
            dfs(reverse_graph, i)
        end
    end

    #puts "f map after first pass:"
    #pp @@f

    forward_graph_relabeled = forward_graph.inject({}) do |fgr, key_value|
        vertex, neighbors = key_value
        fgr[@@f[vertex]] = neighbors.map {|n| @@f[n]}
        fgr
    end
    vertices_relabeled = vertices.map {|v| @@f[v]}

    #puts "forward graph :"
    #pp forward_graph
    #puts "forward graph after relabelling:"
    #pp forward_graph_relabeled


    @@t = 0
    @@s = nil
    @@f = {}
    @@leader = {}
    @@explored = Set.new([])
    vertices_relabeled.sort.reverse!.each do |i|
        if !@@explored.member?(i)
            @@s = i
            dfs(forward_graph_relabeled, i)
        end
    end
    @@leader
end

def dfs(graph, i)
    @@explored.add(i)
    @@leader[@@s] = 0 unless @@leader.has_key?(@@s)
    @@leader[@@s] += 1
    js = graph[i] || []
    js.each do |j|
        if !@@explored.member?(j)
            dfs(graph, j)
        end
    end
    @@t += 1
    @@f[i] = @@t
end

log "reading in #{ARGV[0]}..."
input_graphs = read_graphs_from_file()
log "done reading in #{ARGV[0]}"
sccs = strongly_connected_components(*input_graphs)
#sccs_descending_count = sccs.map {|scc| scc[1].length}.sort.reverse!
pp sccs
#puts sccs_descending_count[0..4].join ','
