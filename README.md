# LQPL - a functional quantum programming language. #

LQPL is a functional quantum programming language based on the semantics as
presented in "Towards a Quantum Programming Language" by Peter Selinger. LQPL is
available as a source distribution as well, at http://pll.cpsc.ucalgary.ca/lqpl

The binary distribution contains the following items:

1. bin - The backend binaries - lqpl, lqpl-compiler-server, lqpl-emulator.
   * The back end is written in Haskell and is comprised of two main components
     * The Emulator (binary: lqpl-emulator)
     * The Compiler (command line binary: lqpl; server binary: lqpl-compiler-server)
   * Each of the server pieces are required and are included in this binary distribution.

2. lib - Contains the redistributed jars required to run the front end UI.

3. LICENSE - The license file.

4. lqplcode - LQPL source files that can be used with the front end UI.

5. lqpl_gui.jar - The executable of the front end UI(this is written in Java and JRuby).
                  lqpl_gui is a front end for the Linear Quantum Programming
                  Language developed at the University of Calgary.

6. lqplManual.pdf - The manual of the LQPL language.

7. README - This read me file.


### SYSTEM REQUIREMENTS: ###
You will need to have a copy of the Java 6 runtime environment installed and
add the path of bin directory of the JRE into your system path.

### HOW TO RUN: ###
1. You may leave the binary servers as they are and use them through the lqpl_gui, or
you can copy the command line binary(lqpl) into a directory on your path and then
use it to compile lqpl programs.

2. To run LQPL, open a terminal, change to the directory where you expanded the tar file
and type 'java -jar lqpl_gui.jar' (without quotes).



### RELEASE NOTES: ###
#### Key Features ####
1. The modularized compiler, emulator and front end.
2. Graphical User Interface front end.

#### Release 0.9.0 ####
This is the first release of LQPL to be made up of a separated GUI and back-end.
ChangeLog:
1. Modularization of the Compiler / Emulator / Front End.
2. Removal of dependency on Alex and Happy for the Compiler(Moved to Parsec). The assembler in the emulator still
requires Alex and Happy
3. Removal of dependency on Gtk2Hs for the front end - moved to a JRuby/Java/Swing based interface.


### Reporting Issues ###

Please report any issues to brett.giles@ucalgary.ca
If you prefer, you may also enter issues directly at:

      https://bitbucket.org/BrettGilesUofC/lqpl/issues


### How You Can Contribute ####

Fork, issue a pull request. Or, get in touch with brett.giles@ucalgary.ca
