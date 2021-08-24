
#! @Chapter Constructions
#! @Section Products

#! @Arguments M
#! Returns the pyramid over <A>M</A>.
DeclareOperation("PyramidOver", [IsManiplex]);

#! @Arguments k
#! Returns the pyramid over a <A>k</A>-gon.
DeclareOperation("Pyramid", [IsInt]);

#! @Arguments M
#! Returns the prism over <A>M</A>.
DeclareOperation("PrismOver", [IsManiplex]);

#! @Arguments k
#! Returns the prism over a <A>k</A>-gon.
DeclareOperation("Prism", [IsInt]);

#! @Arguments M
#! Returns the antiprism over <A>M</A>.
DeclareOperation("Antiprism", [IsManiplex]);

#! @Arguments k
#! Returns the antiprism over a <A>k</A>-gon.
DeclareOperation("Antiprism", [IsInt]);
