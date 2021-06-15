# Code Architecture #

## Reflexible maniplexes ##
To build a reflexible maniplex, there is only one essential ingredient: the automorphism group.
If G is any group, then ReflexibleManiplex(G) will return the reflexible maniplex with automorphism
group G, using GeneratorsOfGroup(G) as if they are the privileged generators rho_0, rho_1, etc.
Note that this function does not, at the moment, check whether G is an sggi, so you will get
unpredictable results if you give it a non-sggi.

The function AbstractRegularPolytope(G) is the same as ReflexibleManiplex(G), except that it
additionally marks its output as polytopal. (i.e. IsPolytopal(AbstractRegularPolytope(G)) = true).
Again, G is not actually checked for whether it is a string C-group. Eventually, we should build
in an option to check whether these groups are the right type.

Sometimes we want the automorphism group in a particular form -- usually either a finitely-presented
group or a permutation group. You can get these from AutomorphismGroupFpGroup(p) and
AutomorphismGroupPermGroup(p). So you should use these if you care about the exact form of the
automorphism group -- otherwise, AutomorphismGroup(p) is fine.

## (Non-reflexible) maniplexes ##
To build a maniplex with no particular symmetry constraints, we need the connection group.
At the moment, we assume that the connection group really is an encoding of the flag graph.
That is, it is a concrete permutation group G, NrMovedPoints(G) is the number of flags,
and r0 represents the edges of color 0, etc. Eventually we want to allow for other forms
of the connection group. In any case, Maniplex(G) is the maniplex with the given connection
group, and AbstractPolytope(G) is the same except that the result is marked IsPolytopal.

As with reflexible maniplexes, no checks on G are made to make sure that it is an sggi.

Note that if G is a concrete permutation group representing a connection group, then
Maniplex(G) will be the (probably not reflexible) maniplex with that flag graph,
whereas ReflexibleManiplex(G) will be the reflexible maniplex with automorphism
group G. In particular, ReflexibleManiplex(G) = SmallestRegularCover(Maniplex(G)).

## Utility functions ##
    TranslatePerm(perm, k) -- Translates a permutation by adding k to every point.
    Ex: TranslatePerm((1,2,3)(4,5), 10) = (11,12,13)(14,15)
    
    MultPerm(perm, multiplier, offset)
    Multiplies together perm, TranslatePerm(perm, offset), TranslatePerm(perm, 2*offset), ..., with multiplier terms.
    Ex: MultPerm((1,2), 5, 10) = (1,2)(11,12)(21,22)(31,32)(41,42)

# Adding new files #
When a package is loaded, first the file init.g is read. This should contain all of the .gd files. 
Types.gd is first so that the later declarations can refer to those types. Then the file read.g
is read, and this should contain all of the .gi files. Thanks to the .gd / .gi split, the order
of .gi files shouldn't matter, and so I have just put them in alphabetical order.

# Making a new type #
Will Gabe finish this before Gordon makes his poset type? It's anyone's guess!
## Categories, Representations, and Families
A **category** in GAP is pretty close to the mathematical sense of the word.
The category of an object is essentially the logical type of object. Most functions
care only about the categor(y/ies) of an object and not how it is represented
internally. So, for example, we can ask NumberOfVertices(p) for any maniplex p,
regardless of whether it is represented via its connection group or automorphism group.

## Operations, Attributes, and all that ##

