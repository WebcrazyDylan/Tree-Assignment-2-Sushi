//
//  main.swift
//  Tree Assignment 2-Sushi
//
//  Created by Dylan Park on 2021-08-24.
//

import Foundation

Sushi()

func Sushi() {
  
  struct DFS {
    private(set) var marked: [Bool]
    private(set) var depth: [Int]
    private(set) var count: Int = 0
    private let s: Int
    
    public init(G: Graph, s: Int) {
      self.s = s
      marked = [Bool](repeating: false, count: G.V)
      depth = [Int](repeating: -1, count: G.V)
      dfs(G, v: s, d: 0)
    }
    
    private mutating func dfs(_ G: Graph, v: Int, d: Int) {
      marked[v] = true
      depth[v] = d
      count += 1
      for u in G.adj(to: v) {
        if !marked[u] {
          dfs(G, v: u, d: d + 1)
        }
      }
    }
    
    public func visited(v: Int) -> Bool {
      return marked[v]
    }
    
    public func depth(of v: Int) -> Int {
      return depth[v]
    }
  }

  class Graph {
    let V: Int
    private(set) var E: Int
    private var adj: [Set<Int>]
    
    public init(V: Int) {
      self.V = V
      self.E = 0
      self.adj = [Set<Int>](repeating: Set<Int>(), count: V)
    }
    
    public func addEdge(from u: Int, to v: Int) {
      E += 1
      adj[u].insert(v)
      adj[v].insert(u)
    }
    
    public func degree(of v: Int) -> Int {
      return adj[v].count
    }
    
    public func adj(to v: Int) -> Set<Int> {
      return adj[v]
    }
    
    public func removeAllEdges(from v: Int) {
      E -= adj[v].count
      for u in adj[v] {
        adj[u].remove(v)
      }
      adj[v].removeAll()
    }
  }
  
  func removeLeaves(from graph: Graph, v: Int, sushi: Set<Int>, visited: inout [Bool]) {
    visited[v] = true
    for u in graph.adj(to: v) {
      if !visited[u] {
        removeLeaves(from: graph, v: u, sushi: sushi, visited: &visited)
      }
    }
    if graph.degree(of: v) == 1 && !sushi.contains(v) {
      graph.removeAllEdges(from: v)
    }
  }
  
  let firstLine = readLine()!.split(separator: " ").map { Int($0)! }
  let n = firstLine[0]
  
  let nextLine = readLine()!.split(separator: " ").map { Int($0)! }
  let realSushi = Set<Int>(nextLine)
  
  let graph = Graph(V: n)
  for _ in 0..<n - 1 {
    let edge = readLine()!.split(separator: " ").map { Int($0)! }
    graph.addEdge(from: edge[0], to: edge[1])
  }
  
  let start = realSushi.first!
  var visited = [Bool](repeating: false, count: graph.V)
  removeLeaves(from: graph, v: start, sushi: realSushi, visited: &visited)
  
  let dfs = DFS(G: graph, s: start)
  var maxVertex = start
  for i in 0..<n {
    if dfs.depth(of: i) > dfs.depth(of: maxVertex) {
      maxVertex = i
    }
  }
  
  let dfs2 = DFS(G: graph, s: maxVertex)
  var diameter = maxVertex
  for i in 0..<n {
    if dfs2.depth(of: i) > dfs2.depth(of: diameter) {
      diameter = i
    }
  }
  
  print(2 * (graph.E) - dfs2.depth(of: diameter))
}


