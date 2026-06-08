gap> h := HeawoodGraph();;
gap> Length(Vertices(h));
14
gap> Length(UndirectedEdges(h));
21
gap> p := PetersenGraph();;
gap> Length(Vertices(p));
10
gap> Length(UndirectedEdges(p));
15
gap> c := CirculantGraph(6, [1,2]);;
gap> Length(Vertices(c));
6
gap> Length(UndirectedEdges(c));
12
gap> IsConnectedGraph(c);
true
gap> k := CompleteBipartiteGraph(3,4);;
gap> Length(Vertices(k));
7
gap> Length(UndirectedEdges(k));
12
gap> IsBipartite(k);
true
