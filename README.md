# My UMass Lowell Thesis Class #

This is a Latex document class that matches the
[requirement](https://www.uml.edu/Catalog/Graduate/Policies/Dissertation-Thesis/Technical-Specifications.aspx
"UMass Lowell dissertation technical specifcations") for dissertations
at UML (last updated Spring 2020). At some point it was forked off of
[umlthesis](https://github.com/engaging-computing/umlthesis
"msherman's umlthesis"), but it is quite different now.

To use this class, either put `umlthesis.cls` in the working directory
of your thesis or somewhere in your TeX path (`kspewhich tex`).

## Fonts ##

  The thesis guide does not require any specific font, although it
  does recommend Times New Roman. A simple way to get a nice Times
  font for text and math is to load the [newtx](https://ctan.org/pkg/newtx "CTAN: Package newtx")
  packages.

  ```latex
  \usepackage{newtxtext}
  \usepackage{newtxmath}
  ```
