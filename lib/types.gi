
InstallTrueMethod(IsReflexibleManiplex, IsManiplex and IsReflexible);
InstallTrueMethod(IsManiplex and IsReflexible, IsReflexibleManiplex);
InstallTrueMethod(IsRotaryManiplex, IsManiplex and IsRotary);
InstallTrueMethod(IsManiplex and IsRotary, IsRotaryManiplex);
InstallTrueMethod(IsPolytope, IsManiplex and IsPolytopal);
InstallTrueMethod(IsManiplex and IsPolytopal, IsPolytope);
InstallTrueMethod(IsRegularPolytope, IsPolytope and IsReflexible);
InstallTrueMethod(IsPolytope and IsReflexible, IsRegularPolytope);
