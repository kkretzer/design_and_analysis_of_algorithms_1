def log msg
    puts "#{Time.now} :: #{msg}"
end

def read_graph_from_file
    File.open(ARGV[0], 'r') do |file|
        file.readlines.inject({}) do |adjacency_lists, line|
            vertex, neighbor = line.strip.split(/\s+/).map {|s| s.to_i}
            adjacency_lists[vertex] ||= []
            adjacency_lists[vertex] << neighbor
            adjacency_lists
        end
    end
end

def strongly_connected_components(graph)
    visited_with_finishing_times = {}
    leaders = {}
    t = 0
    s = nil
    # using closure
    dfs = lambda do |g, node|
        log "dfs at node #{node}"
        visited_with_finishing_times[node] = nil
        leaders[node] = s
        if g.has_key? node
            g[node].each do |neighbor|
                # lambda recursion
                dfs.call(g, neighbor) unless (visited_with_finishing_times.has_key? neighbor) || node == neighbor
            end
        end
        t += 1
        visited_with_finishing_times[node] = t
    end
    dfs_loop = lambda do |g, vertex|
        log "dfs_loop at vertex #{vertex}"
        unless visited_with_finishing_times.has_key? vertex
            s = vertex
            dfs.call(g, vertex)
        end
    end
    reversed_graph = graph.inject({}) do |revgraph, key_value|
        vertex, neighbors = key_value
        neighbors.each do |neighbor|
            revgraph[neighbor] ||= []
            revgraph[neighbor] << vertex
        end
        revgraph
    end
    reversed_dfs_loop = dfs_loop.curry[reversed_graph]
    reversed_graph.keys.sort.reverse.each &reversed_dfs_loop
    log "after first pass : visited_with_finishing_times = #{visited_with_finishing_times}"

    finishing_times = visited_with_finishing_times.invert
    visited_with_finishing_times = {}
    leaders = {}
    t = 0
    s = nil
    forward_dfs_loop = dfs_loop.curry[graph]
    order = finishing_times.keys.sort.reverse
    finishing_times.values_at(*order).each &forward_dfs_loop
    log "after second pass : leaders = #{leaders}"
    leaders.inject({}) do |sccs, key_value|
        vertex, leader = key_value
        sccs[leader] ||= []
        sccs[leader] << vertex
        sccs
    end
end

log "reading in #{ARGV[0]}..."
input_graph = read_graph_from_file()
log "done reading in #{ARGV[0]}"
sccs = strongly_connected_components(input_graph)
sccs_descending_count = sccs.map {|scc| scc[1].length}.sort.reverse!
puts sccs
puts sccs_descending_count[0..4].join ','
