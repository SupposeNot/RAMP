
#! @Chapter Maniplex Constructors
#! @Section Subclasses of maniplex

#! @Arguments M
#! @Description Returns whether the maniplex <A>M</A> is polytopal;
#! i.e., the flag graph of a polytope.
DeclareProperty("IsPolytopal", IsManiplex);

#! @Arguments M
#! @Returns IsBool
#! @Description Tests for the weak path intersection property in a maniplex. Definitions and description available in <Cite Key="GleHub18"/>.
DeclareProperty("SatisfiesWeakPathIntersectionProperty", IsManiplex);


#! @Arguments m
#! @Description Returns whether the maniplex <A>m</A> is
#! faithful, as defined in "Polytopality of Maniplexes"; i.e., whether for each flag the intersection of all the i-faces containing that flag is just the flag itself.
DeclareOperation("IsFaithful", [IsManiplex]);
#! @BeginExampleSession
#! gap> IsFaithful(Cube(3));
#! true
#! gap> IsFaithful(ToroidalMap44([1,0]));
#! false
#! @EndExampleSession

#! @Arguments maniplex
#! @Description Returns whether a maniplex is a regular polytope.
DeclareAttribute("IsRegularPolytope",IsManiplex);
#! @BeginExampleSession
#! gap> p:=24Cell();
#! 24Cell
#! gap> IsRegularPolytope(p);
#! true
#! gap> q:=CartesianProduct(Simplex(2),Cube(2));
#! CartesianProduct(Pgon(3), Pgon(4))
#! gap> IsRegularPolytope(q);
#! false
#! @EndExampleSession


#! @Chapter Combinatorics and Structure
#! @Section Basics

#! @Arguments M
#! @Returns The number of flags of the premaniplex <A>M</A>.
#! @Description Synonym: `NumberOfFlags`.
DeclareAttribute("Size", IsPremaniplex);

DeclareSynonymAttr("NumberOfFlags", Size);

#! @Arguments M
#! @Returns The rank of the premaniplex <A>M</A>.
DeclareAttribute("RankManiplex", IsPremaniplex);


DeclareGlobalFunction("MANIPLEX_STRING");
