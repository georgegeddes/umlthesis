This is a Latex document class that attempts to follow the [UML Thesis Guide](https://www.uml.edu/registrar/docs/thesis_guide.pdf "UML Thesis Guide"). At some point it was forked off of [umlthesis](https://github.com/engaging-computing/umlthesis "msherman's umlthesis"), but it is quite different now.

To use this class, either put `umlthesis.cls` in the working directory of your thesis or somewhere in your TeX path (`kspewhich tex`).

# Fonts
  The thesis guide does not require any specific font, although it does recommend Times New Roman. There are many ways to achieve this, so do something like the following in the preamble:
  ```latex
  \usepackage{unicode-math}
  \setmainfont{TeX Gyre Termes}
  \setmathfont{TeX Gyre Termes Math}
  ```
  
  This requires the TeX Gyre Termes (Math) fonts and either xelatex or lualatex to compile.

# TODO
	- Table numbers should be centered and underlined.
	- Table of Contents, List of Figures, List of Tables should be formatted with upper case titles, I think.
	- Title Page.
	- Abstract Title Page
