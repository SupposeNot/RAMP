# 	This is for spherical groups in 3 and 4 D
# 	
# 	! @Chapter Groups for Maps, Polytopes, and Maniplexes
# 	! @Section Real Spherical Groups
# 	
# 	! Here we provide representations as matrix groups acting on $\mathbb R^3$ and $\mathbb R^4$ 
# 	! the finite spherical groups.
# 	
# 	gap> null:=NullspaceMat([[1,2,3],[0,5,6],[0,10,12]]);
# 	[ [ 0, -2, 1 ] ]
# 	gap> Display(null);
# 	[ [   0,  -2,   1 ] ]
# 	gap> [[1,2,3],[0,5,6],[0,10,12]]*[0,-2,1];
# 	[ -1, -4, -8 ]
# 	gap> [0,2,-1]*[[1,2,3],[0,5,6],[0,10,12]];
# 	[ 0, 0, 0 ]

# #! @Chapter Groups for Maps, Polytopes, and Maniplexes
# 
# #! @Arguments vector
# #! @Returns a matrix reflecting through the plane with normal <A>vector</A>.
# #! @Description
# #! 
# #! @BeginExampleSession
# #! @EndExampleSession
DeclareOperation("ReflectionMatrix",[IsVector]);

# DeclareOperation("RotationMatrix",[IsInt]);