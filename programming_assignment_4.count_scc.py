import sys, time, os
from string import *
from collections import defaultdict

import sys
sys.setrecursionlimit(1000000)

def log(msg):
    print time.strftime("%H:%M:%S"), msg

def read_graph_file(input_file):
    with open(input_file, 'r') as file:
        edges = []
        for line in file:
            edges.append([int(x) for x in split(strip(line))])
    return edges

def strongly_connected_components(edges):
    forward_adjacency_lists = defaultdict(list)
    reversed_adjacency_lists = defaultdict(list)
    vertices = set([])
    for edge in edges:
        tail, head = edge
        vertices.update([tail,head])
        forward_adjacency_lists[tail].append(head)
        reversed_adjacency_lists[head].append(tail)

    # TODO: wtf?
    #   t and s can't be 'closed over' if their just an integer???
    #   can't get the following closures to work unless t and s are some type of other object
    t = [0]
    s = [0]
    f = defaultdict(int)
    leader = defaultdict(int)
    explored = set([])
    sorted_vertices = sorted(vertices, reverse=True)

    def dfs(graph, i):
        explored.add(i)
        leader[s[0]] += 1
        for j in graph[i]:
            if j not in explored:
                dfs(graph, j)
        t[0] += 1
        f[i] = t[0]

    def dfs_loop(graph):
        for i in sorted_vertices:
            if i not in explored:
                s[0] = i
                dfs(graph, i)

    dfs_loop(reversed_adjacency_lists)
    forward_graph_relabeled = defaultdict(list)
    for vertex in forward_adjacency_lists:
        neighbors = forward_adjacency_lists[vertex]
        forward_graph_relabeled[f[vertex]] = [f[neighbor] for neighbor in neighbors]

    # reset stuff that is significant in the 2nd pass
    leader = defaultdict(int)
    explored = set([])

    dfs_loop(forward_graph_relabeled)
    return leader

if len(sys.argv) == 1:
    input_file = os.path.join(os.path.dirname(__file__), 'SCC.txt')
else:
    input_file = sys.argv[1]

# some cheap test setup...
expected_biggest_5 = None
if os.path.basename(input_file) == 'test_scc.txt':
    expected_biggest_5 = [3,3,3]
elif os.path.basename(input_file) == 'test_scc2.txt':
    expected_biggest_5 = [7,3]
elif os.path.basename(input_file) == 'SCC.txt':
    expected_biggest_5 = [434821, 968, 459, 313, 211]

log("reading in file...")
input_edges = read_graph_file(input_file)
log("done reading in file")

log("computing strongly connected components...")
sccs = strongly_connected_components(input_edges)
log("done computing strongly connected components")
    
# only expecting strongly_connected_components to return the SCC's, not in any particular order
# so rank them by size here
scc_counts = sorted(sccs.values(), reverse=True)

computed_biggest_5 = scc_counts[:5]
log("biggest 5 strongly connected components:")
print computed_biggest_5
if expected_biggest_5 != None:
    test_status = ("FAILED", "PASSED")[expected_biggest_5 == computed_biggest_5]
    log(test_status + " test")
