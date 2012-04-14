import sys
import time
from string import *
from collections import defaultdict

import sys
sys.setrecursionlimit(1000000)

def log(msg):
    print time.strftime("%H:%M:%S"), msg

def read_graph_file():
    with open(sys.argv[1], 'r') as file:
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


t = 0
s = None
f = defaultdict(int)
first_f = defaultdict(int)
leader = defaultdict(int)
explored = set([])

def strongly_connected_components(forward_graph, reverse_graph, vertices):
    global t, s, f, leader, explored, first_f
    def dfs(graph, i):
        global t, s, f, leader, explored

        explored.add(i)
        leader[s] += 1
        for j in graph[i]:
            if j not in explored:
                dfs(graph, j)
        t += 1
        f[i] = t

    sorted_vertices = sorted(vertices, reverse=True)
    for i in sorted_vertices:
        if i not in explored:
            s = i
            dfs(reverse_graph, i)

    forward_graph_relabeled = defaultdict(list)
    for vertex in forward_graph:
        neighbors = forward_graph[vertex]
        forward_graph_relabeled[f[vertex]] = [f[neighbor] for neighbor in neighbors]
    for k in f:
        first_f[k] = f[k]

    t = 0
    s = None
    f = defaultdict(int)
    leader = defaultdict(int)
    explored = set([])
    for i in sorted_vertices:
        if i not in explored:
            s = i
            dfs(forward_graph_relabeled, i)
    return leader

log("reading in file...")
input = read_graph_file()
log("done reading in file")
sccs = strongly_connected_components(input[0], input[1], input[2])
    
scc_counts = sorted(sccs.values(), reverse=True)
print scc_counts[:5]
