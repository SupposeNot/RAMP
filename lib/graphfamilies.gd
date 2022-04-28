

#! @Chapter Graphs for Maniplexes
#! @Section Graph families

#! @Returns `IsGraph`
#! @Description Heawood Graph as described at https://www.distanceregular.org/graphs/heawood.html
DeclareOperation("HeawoodGraph", []);

#! @Returns `IsGraph`
#! @Description Petersen Graph as described at https://www.gap-system.org/Manuals/pkg/grape/htm/CHAP002.htm
DeclareOperation("PetersenGraph", []);

#! @Arguments int, list
#! @Returns `IsGraph`
#! @Description Given an integer n and a list L, this returns the Circulant Graph with n vertices
#! For each i in the list L and each vertex v, there is an edge from v to v+i and v-i (mod n)
DeclareOperation("CirculantGraph", [IsInt,IsList]);

#! @Arguments int, list
#! @Returns `IsGraph`
#! @Description Given two integers n, m, this returns the Complete Bipartite Graph K_{n,m}
DeclareOperation("CompleteBipartiteGraph", [IsInt,IsInt]);




