

#! @Chapter Graphs for Maniplexes
#! @Section Graph families

#! @Returns `IsGraph`
#! @Description Returns the Heawood graph, as described at https://www.distanceregular.org/graphs/heawood.html
DeclareOperation("HeawoodGraph", []);
#! @BeginExampleSession
#! gap> h := HeawoodGraph();;
#! gap> Length(Vertices(h));
#! 14
#! gap> Length(UndirectedEdges(h));
#! 21
#! @EndExampleSession

#! @Returns `IsGraph`
#! @Description Returns the Petersen graph, as described at https://www.gap-system.org/Manuals/pkg/grape/htm/CHAP002.htm
DeclareOperation("PetersenGraph", []);
#! @BeginExampleSession
#! gap> p := PetersenGraph();;
#! gap> Length(Vertices(p));
#! 10
#! gap> Length(UndirectedEdges(p));
#! 15
#! @EndExampleSession

#! @Arguments n, L
#! @Returns `IsGraph`
#! @Description Given an integer <A>n</A> and a list <A>L</A>, this returns the circulant graph with vertices `[1..n]`.
#! For each `i` in the list <A>L</A> and each vertex `v`, there is an edge from `v` to `v+i` and `v-i` modulo <A>n</A>.
DeclareOperation("CirculantGraph", [IsInt,IsList]);
#! @BeginExampleSession
#! gap> c := CirculantGraph(6, [1,2]);;
#! gap> Length(Vertices(c));
#! 6
#! gap> Length(UndirectedEdges(c));
#! 12
#! gap> IsConnectedGraph(c);
#! true
#! @EndExampleSession

#! @Arguments n, m
#! @Returns `IsGraph`
#! @Description Given two integers <A>n</A> and <A>m</A>, this returns the complete bipartite graph `K_{n,m}` with `n+m` vertices.
DeclareOperation("CompleteBipartiteGraph", [IsInt,IsInt]);
#! @BeginExampleSession
#! gap> k := CompleteBipartiteGraph(3,4);;
#! gap> Length(Vertices(k));
#! 7
#! gap> Length(UndirectedEdges(k));
#! 12
#! gap> IsBipartite(k);
#! true
#! @EndExampleSession



