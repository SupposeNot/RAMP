# RAMP 0.7 Release Notes

This is a beta release of *The Research Assistant for Maniplexes and Polytopes*, a package for working with maps on surfaces, abstract polytopes, and related discrete geometric objects in GAP 4.11.0 or greater. More information about GAP is available at https://www.gap-system.org/. You will need to install the RAMP folder in your GAP package directory to use the included functions, and documentation on all of RAMP's features is available through the GAP help system after you have run `LoadPackage("ramp");`. We recommend adding this command to the end of your `gaprc` file.

The easiest way to access the full documentation once you have loaded RAMP is to type `?ramp:title` into GAP.

**RAMP** package is free software; you can redistribute it and/or modify it under the terms of the [GNU General Public License](http://www.fsf.org/licenses/gpl.html) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

## Changes since 0.6.3

- Fix to allow directed graphs as imputs to ViewGraph.
- Added ConnectionGroup as an attribute of an IsEdgeLabeledGraph and method for computing it.
- Added EdgeLabeledGraphFromLabeledEdges.
- Added representation IsManiplexFlagGraphRep.
- Added method Maniplex for IsEdgeLabeledGraph.
- Added commands IsRelationOfReflexibleManiplex, SimplifiedSggiElement.
- Added support for interpolated strings to polytope and sggi constructors, InterpolatedString method.
- Added a variety of code modifications to support reading and writing polytopes and manipexes from and to files. Data is now stored in appropriately labeled subfolder of package.
- Added GreatDodecahedron, ToroidalMap36 and ToroidalMap63, GrandAntiprism,
- Additional functionality for 
  - bicontactual regular maps
  - Tetrahedron
  - Octahedron
  - ToroidalMap44, ToroidalMap36, and ToroidalMap63, including knowing when the resulting map is a polytope.
- Added methods IsFaithful, IsStringRotationGroup.
- Added extensive support for voltage operations.
- Interface for SmallReflexibleManiplexes.
- Support for Premaniplexes.
- Bug fixes for Petrial, Sggis, package loading errors on some systems, ViewGraph, ConnectionGroup of EdgeLabeledGraph, quotient testing for maniplexes with infinity in their Schläfli symbol, RotationGroup and EnantiomorphicForm, String for toroidal maps, COXETER_GROUPS_SIZES.
- Wythoff operations!!!
- Extensive improvements to graph representations and bug fixes to existing graph code.
- Made RotationGroupFpGroup work for infinite polytopes, AutomorphismGroupFpGroup work gracefully with chiral maniplexes.
- Syncing of attributes after isomorphism testing.
- Support for rooted covers, quotients, and isomorphism.
- Reworked maniplex string and display code.
- String interpolation improvements, e.g., to RotaryManiplex
- Documentation for how to extend and contribute to RAMP.
- Added significant numbers of tests for the package to verify functionality.
- Lots of edits and improvements to documentation.