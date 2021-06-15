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


## Categories, Representations, and Families ##
A **category** in GAP is pretty close to the mathematical sense of the word.
The category of an object is essentially the logical type of object. Most functions
care only about the categor(y/ies) of an object and not how it is represented
internally. So, for example, we can ask NumberOfVertices(p) for any maniplex p,
regardless of whether it is represented via its connection group or automorphism group.

A **representation** of an object describes the way that the object is represented
internally. For example, a Maniplex object might be represented internally by its
Connection Group, or it might be represented by a poset. Some functions may need
to know how the object is actually represented in order to perform computations.

Most function _declarations_ should only care about the category of the inputs.
On the other hand, some function _implementations_ (i.e. InstallMethod) will
need to care about the category _and_ representation.

An object also belongs to a **family**. This part is still slightly mysterious
to me, but here is an example -- the elements of two finitely presented groups
belong to different families, and so they can't be multiplied together.
In RAMP, maniplexes of different ranks belong to different families, which
prohibits some operations from taking maniplexes of different rank as input.

### More about Representations ###

Let's look at an example of a representation.

    DeclareRepresentation("IsManiplexConnGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["conn_gp", "fvec"]);

First, note that there is no explicit connection between IsManiplexConnGpRep and IsManiplex.
I have used the naming convention that the representations of a category consist of the category name,
followed by a description of the representation.

Next, "IsComponentObjectRep" says that an object of this type is stored with named
components. (The alternative is IsPositionalObjectRep, in which case the object is just
stored as a list.)

"IsAttributeStoringRep" says that for any declared Attributes, the object remembers their values
once they are computed. You can see this for groups in GAP; if you set G to be some
group and call Size(G) twice in a row, the second call just returns the memorized value.

Finally, the list at the end consists of the named internal components. In general, you
want this list to be as small as possible -- most of the attributes of the object will be
accessed "externally" using DeclareAttribute and related functions.
The sorts of things that it makes sense to store internally are:
* Defining data for the object. In the example above, we need the connection group
to even make a maniplex.
* Messy state variables that we don't want the user to see. For example, when
we build a maniplex, we initially set the fvector to be a list of n blanks.
As we learn about the number of vertices etc, we fill in the blanks.
But this is done just for performance reasons -- a user probably doesn't want
a partial fvector. So Fvector(p) doesn't return this partial fvector; rather,
it computes the Fvector first and then returns it.

### Actually creating objects ###

Let's say you've set up your new category and at least one representation of that category.
How do you actually make a new object in that category? Let's look at an example from RAMP:

    InstallMethod(Maniplex,
	    [IsPermGroup],
	    function(g)
	    local n, fam, p;
	    n := Size(GeneratorsOfGroup(g));
	    fam := NewFamily(Concatenation(String(n), "-maniplex"), IsManiplex);
	    fam!.rank := n;
	
	    p := Objectify( NewType( fam, IsManiplex and IsManiplexConnGpRep), rec( conn_gp := g, fvec := List([1..n], i -> fail) ));
        ....
        return p;
        
Let's break this down:
1. When we call Maniplex(g), we create a new family at runtime, which stores the rank. (The notation fam!.rank is essentially just fam.rank;
I think the extra ! is just because we are accessing internal state or something.) I'm not entirely sure if this
is the "right" approach, but it works for now.
2. Now, Objectify is what does all the magic. We start with NewType( family, category and representation). 
In principle, that second component could be any combination of _filters_ (unary functions that return true or false).
The last part is a data record that sets up the components of the representation.

That's it! Now p is an object which IsManiplex and IsManiplexConnGpRep, and all of the attributes
and methods you've coded to work with maniplexes will work with p.

## Operations, Attributes, and all that ##

### Operations ###
An **operation** is essentially a function that may have multiple different implementations depending
on the type of its inputs. So, if you have a function that there is only one sensible way
to compute, then we probably want to just make that a global function rather than an operation.
(This is not completely adhered to in RAMP at present, because I only just understood this
recently myself.) 

Here is an example: consider the problem of determining the size of a group.
The way we find the size of a finitely-presented group is completely different
from how we find the size of a permutation group. So somewhere we want to declare
an operation, and then two different implementations:

    DeclareOperation("Size", [IsGroup]);
    
    InstallMethod(Size, [IsFpGroup],
    	function(g) ... );
	
    InstallMethod(Size, [IsPermGroup],
    	function(g) ... );
	
Then when we call Size(g), GAP figures out which method to use.

It might happen that there are multiple installed methods that apply to a given object.
In that case, roughly speaking, GAP will choose the method with the
_most specific_ restrictions. For example, if we also had:

    InstallMethod(Size, [IsGroup],
    	function(g) ... );
	
then this new method would only be used for groups that are neither
FpGroups nor PermGroups. 

In cases where the above heuristic is not enough to determine which method to use,
GAP has a whole "ranking system" for methods, but I haven't needed to
even think about that yet, and I hope never to.

### Attributes and Properties ###

An **attribute** of an object can be any kind of information about the object.
A **property** is just a boolean attribute.
Whenever you declare an attribute of an object, you get two functions for free:
HasATTRIBUTE and SetATTRIBUTE. For example, we have:

    DeclareAttribute("SchlafliSymbol", IsManiplex);
    
So we can call SchlafliSymbol(m), HasSchlafliSymbol(m), and SetSchlafliSymbol(m, [3, 4]).

Since we have set up maniplexes as IsAttributeStoringRep, the value of all attributes
is stored. In particular, if you SetATTRIBUTE(m, something), then the computation of
that attribute is never run. We often run this when building maniplexes that we know
something about.

Note that, **once the value of an attribute is set, it cannot be reset**.
Attempts (by calling SetATTRIBUTE) will fail.

### Declaration and Implementation ###

DeclareOperation, DeclareAttribute etc set up a read-only name for the operation / 
attribute etc, and tell us what type of object(s) the operation works on.

When we use InstallMethod to set up the actual method, we may be _more_ specific
than the declaration was. Thus we can have things like:

    DeclareAttribute("AutomorphismGroup", IsManiplex);
    
    InstallMethod(AutomorphismGroup, [IsReflexibleManiplex], ...)
    
