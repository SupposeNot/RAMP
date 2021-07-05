DeclareGlobalVariable("UNIVERSAL_ROT_FREE_GROUPS");


#! @Arguments n
#! Returns the rotation subgroup of the universal Coxeter Group of rank n.
DeclareOperation("UniversalRotationGroup", [IsInt]);

#! @Arguments sym
#! Returns the rotation subgroup of the Coxeter Group with Schlafli symbol sym.
DeclareOperation("UniversalRotationGroup", [IsList]);

#!
DeclareOperation("RotaryManiplex", [IsGroup]);

#!
DeclareOperation("RotaryManiplex", [IsList]);

#!
DeclareOperation("RotaryManiplex", [IsList, IsList]);
