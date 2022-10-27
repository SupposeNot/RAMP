

#! @Chapter Graphs for Maniplexes
#! @Section Graph families

#! @Returns `IsGraph`
#! @Description Heawood Graph as described at https://www.distanceregular.org/graphs/heawood.html
DeclareOperation("HeawoodGraph", []);

#! @Returns `IsGraph`
#! @Description Petersen Graph as described at https://www.gap-system.org/Manuals/pkg/grape/htm/CHAP002.htm
DeclareOperation("PetersenGraph", []);

#! @Arguments n, L
#! @Returns `IsGraph`
#! @Description Given an integer <A>n</A> and a list <A>L</A>, this returns the Circulant Graph with <A>n</A> vertices.
#! For each `i` in the list <A>L</A> and each vertex `v`, there is an edge from `v` to `v+i` and `v-i` (mod <A>n</A>)
DeclareOperation("CirculantGraph", [IsInt,IsList]);

#! @Arguments n, m
#! @Returns `IsGraph`
#! @Description Given two integers <A>n, m</A>, this returns the Complete Bipartite Graph `K_{n,m}`.
DeclareOperation("CompleteBipartiteGraph", [IsInt,IsInt]);




