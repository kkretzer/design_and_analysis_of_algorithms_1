require 'pp'
require 'set'

def log msg
    puts "#{Time.now} :: #{msg}"
end

def read_graphs_from_file
    forward_adjacency_lists, reversed_adjacency_lists = {}, {}
    File.open(ARGV[0], 'r') do |file|
        file.readlines.each do |line|
            vertex, neighbor = line.strip.split(/\s+/).map {|s| s.to_i}
            forward_adjacency_lists[vertex] ||= []
            forward_adjacency_lists[vertex] << neighbor
            reversed_adjacency_lists[neighbor] ||= []
            reversed_adjacency_lists[neighbor] << vertex
        end
    end
    [forward_adjacency_lists, reversed_adjacency_lists]
end

def strongly_connected_components(forward_graph, reverse_graph)
    finishing_times = {}
    visited = [].to_set
    leaders = {}
    t = 0
    s = nil
    dfs = lambda do |graph, node|
        #log "dfs at node #{node}"
        visited << node
        leaders[node] = s
        neighbors = graph[node]
        neighbors ||= []
        neighbors.each do |neighbor|
            # lambda recursion
            dfs.call(graph, neighbor) unless (visited.member? neighbor) || node == neighbor
        end
        t += 1
        finishing_times[node] = t
    end
    reverse_graph.keys.sort.reverse.each do |vertex|
        log "dfs loop at vertex #{vertex}"
        unless visited.member? vertex
            s = vertex
            dfs.call(reverse_graph, vertex)
        end
    end
    log "after first pass : finishing_times = #{finishing_times}"

    finishing_times = finishing_times.invert
    visited = [].to_set
    leaders = {}
    t = 0
    s = nil
    graph = forward_graph
    order = finishing_times.keys.sort.reverse
    finishing_times.values_at(*order).each do |vertex|
        log "dfs loop at vertex #{vertex}"
        unless visited.member? vertex
            s = vertex
            dfs.call(forward_graph, vertex)
        end
    end
    log "after second pass : leaders = #{leaders}"
    leaders.inject({}) do |sccs, key_value|
        vertex, leader = key_value
        sccs[leader] ||= []
        sccs[leader] << vertex
        sccs
    end
end

log "reading in #{ARGV[0]}..."
input_graphs = read_graphs_from_file()
log "done reading in #{ARGV[0]}"
sccs = strongly_connected_components(*input_graphs)
sccs_descending_count = sccs.map {|scc| scc[1].length}.sort.reverse!
pp sccs
puts sccs_descending_count[0..4].join ','
