import sys, time, os
from string import *
from collections import defaultdict

import sys
sys.setrecursionlimit(1000000)

def log(msg):
    print time.strftime("%H:%M:%S"), msg

def read_graph_file(input_file):
    with open(input_file, 'r') as file:
        forward_adjacency_lists = defaultdict(list)
        reversed_adjacency_lists = defaultdict(list)
        vertices = set([])
        for line in file:
            vertex, neighbor = [int(x) for x in split(strip(line))]
            vertices.add(vertex)
            vertices.add(neighbor)
            forward_adjacency_lists[vertex].append(neighbor)
            reversed_adjacency_lists[neighbor].append(vertex)
    return [forward_adjacency_lists, reversed_adjacency_lists, vertices]


def strongly_connected_components(forward_graph, reverse_graph, vertices):
    def dfs(graph, i):
        explored.add(i)
        # s is the leader for an SCC, it was the first of the SCC to be visited
        # (only significant in the 2nd dfs-loop)
        # 'leader' dictionary is just counting the # of vertices in each leader-group
        leader[s] += 1
        for j in graph[i]:
            if j not in explored:
                dfs(graph, j)
        t[0] += 1
        f[i] = t[0]

    # TODO: wtf?
    #   t can't be 'closed over' if it's just an integer???
    #   can't get the above closure to work unless t is some type of other object
    #   odd that I don't need to do this to s, i *have* to be overlooking something with t
    t = [0]
    s = 0
    f = defaultdict(int)
    leader = defaultdict(int)
    explored = set([])

    sorted_vertices = sorted(vertices, reverse=True)
    for i in sorted_vertices:
        if i not in explored:
            s = i
            dfs(reverse_graph, i)

    forward_graph_relabeled = defaultdict(list)
    for vertex in forward_graph:
        neighbors = forward_graph[vertex]
        forward_graph_relabeled[f[vertex]] = [f[neighbor] for neighbor in neighbors]

    t = [0]
    s = None
    f = defaultdict(int)
    leader = defaultdict(int)
    explored = set([])
    for i in sorted_vertices:
        if i not in explored:
            s = i
            dfs(forward_graph_relabeled, i)
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
input = read_graph_file(input_file)
log("done reading in file")

log("computing strongly connected components...")
sccs = strongly_connected_components(input[0], input[1], input[2])
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
