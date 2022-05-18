#! @Chapter Installation
#! @Section Basics
#! Some quick notes on installation:
#! - RAMP is confirmed to work with version 4.11.1 of GAP, but is known not to work with some earlier versions. 
#! - Copy the RAMP folder and its contents to your GAP `/pkg` folder.
#!   - If using the GAP.app on macOS, this should be your user `Library/Preferences/GAP/pkg` folder. Probably the easiest way to do this if you have received RAMP as a `.zip` file is to copy the file into this location, and then unpack it. After that, you can delete the `.zip` file.
#! 

#! @Chapter Using RAMP
#! @Section Assumptions
#! There are a few assumptions that many methods make.
#!
#! 1. The connection group of a maniplex with N flags is often assumed to act on [1..N].
#! This is gradually being rewritten to allow any set of integers as flags, but use caution
#! when working with such connection groups.
#!
#! 2. When working with a connection group  $\langle r_0, \ldots, r_{n-1} \rangle$, some methods may
#! have strange behavior if any $r_i$ or $r_i r_j$ has any fixed points. Indeed, Sggis
#! of that type define pre-maniplexes rather than maniplexes. Eventually, the methods that
#! build maniplexes will verify that no $r_i$ or $r_i r_j$ has fixed points.
#!
#! @Section Extending RAMP
#! Suppose you want to add a new operation on maniplexes to RAMP. We will see how to accomplish that
#! with a hypothetical example. Let's pretend that there's a mathematical operation on maniplexes called "Stretch".
#!
#! Our first step will be to create two new files in the lib/ directory: stretch.gd and stretch.gi. The first
#! file is for the declaration of the new operation, and the second is for the implementation.
#!
#! In stretch.gd, we want to add a line that declares the new operation, something like this:
#! @BeginExampleSession
#! DeclareOperation("Stretch", IsManiplex);
#! @EndExampleSession
#! Now we will write the implementation in stretch.gi:
#! @BeginExampleSession
#! InstallMethod(Stretch, 
#! 		[IsManiplex],
#!		function(M)
#!		...actual code goes here...
#! 		end);
#! @EndExampleSession
#! Finally, we need to make sure that these new files are read when RAMP is loaded up. Open up init.g (in the root RAMP
#! directory) and add the line
#! @BeginExampleSession
#! ReadPackage( "ramp", "lib/stretch.gd" ); 
#! @EndExampleSession
#! (We recommend that you put that line in alphabetical order with the rest.) Similarly, open up read.g and
#! add the line
#! @BeginExampleSession
#! ReadPackage( "ramp", "lib/stretch.gi" ); 
#! @EndExampleSession
#! Now your code is available in your copy of RAMP!
#!
#! Here are two more things you should do. First, test your code. Create a new file called stretch.tst in the
#! tst directory of RAMP. The format of the tests is that you first write a line that starts with "gap> "
#! and continues with some input, as if you actually typed it in to the GAP prompt. Then, on the following line,
#! put the expected output.
#! 
#! To run your tests, run the following command in RAMP:
#! @BeginExampleSession
#! gap> TestRamp("stretch.tst");
#! @EndExampleSession
#! If any tests fail (that is, if the output from GAP does not match the expected output from your test file),
#! then GAP will alert you to the discrepancies. Otherwise, when the tests are complete, there will be no output
#! and you will just see the gap> prompt again. 
#!
#! You can also call TEST_RAMP() to run all of the tests in the /tst directory.
#! 
#! Finally, you should document your operation! Take a look at one of the .gd files included with RAMP to see
#! what you should include. To actually build the documentation, you will need the package AutoDoc. For
#! example, the following will rebuild the documentation:
#! @BeginExampleSession
#! gap> LoadPackage("AutoDoc");
#! gap> AutoDoc("ramp", rec( scaffold := true, autodoc := true));
#! @EndExampleSession
#! To see your updated documentation, you can either navigate to the html file in the doc/ directory, or
#! you can quit GAP and restart it, and then your documentation will be available in the inline help.
#! If you have LaTeX set up properly, then it will also build a pdf manual.
#!

#! @Chapter Groups for Maps, Polytopes, and Maniplexes
#! @Chapter Regular Maps
#! @Chapter Families of Polytopes
#! @Chapter Maniplexes
#! @Section Constructors
#! @Chapter Maniplex Properties
#! @Chapter Comparing maniplexes
#! @Chapter Posets
#! @Section Poset constructors
#! @Section Poset attributes
#! @Section Working with posets
#! @Section Element constructors
#! @Section Element operations
#! @Chapter Polytope Constructions and Operations
#! @Chapter Regular Maps
#! @Chapter Combinatorics and Structure
#! @Chapter Graphs for Maniplexes
#! @Chapter Databases
#! @Chapter Stratified Operations
#! @Chapter Maps On Surfaces
#! @Chapter Utility Functions


#! @Chapter Synonyms for Commands
#! Here we list, in alphabetical order, synonyms for common commands.
#! * `Ambo` for <Ref Func='Medial' BookName='ramp'/>
#! * `AreIncidentFaces` for <Ref Func='AreIncidentElements' BookName='ramp'/>
#! * `ARP` for <Ref Func='AbstractRegularPolytope' BookName='ramp'/>
#! * `Faces` for <Ref Func='ElementsList' BookName='ramp'/>
#! * `FacesList` for <Ref Func='ElementsList' BookName='ramp'/>
#! * `Flags` for <Ref Func='MaximalChains' BookName='ramp'/>
#! * `FlagsList` for <Ref Func='MaximalChains' BookName='ramp'/>
#! * `IsDiamondCondition` for <Ref Func='IsP4' BookName='ramp'/>
#! * `IsStronglyFlagConnected` for <Ref Func='IsP3' BookName='ramp'/>
#! * `MapJoin` for <Ref Func='Angle' BookName='ramp'/>
#! * `MonodromyGroup` for <Ref Func='ConnectionGroup' BookName='ramp'/>
#! * `NumberOfFlags` for <Ref Func='Size' BookName='ramp'/>
#! * `PetrieDual` for <Ref Func='Petrial' BookName='ramp'/>
#! * `RankPosetFaces` for <Ref Func='RankPosetElements' BookName='ramp'/>
#! * `RefMan` for <Ref Func='ReflexibleManiplex' BookName='ramp'/>
