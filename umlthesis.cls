% This class will implement all of the formatting specifications in
% the UML Thesis guide.
% https://www.uml.edu/registrar/docs/thesis_guide.pdf
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{umlthesis}[01/23/2019]

\newif\if@umlcentering
\DeclareOption{centering}{\@umlcenteringtrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

% Default geometry
\ExecuteOptions{letterpaper,12pt}

\ProcessOptions\relax

\LoadClass{report}
\RequirePackage{calc}
\RequirePackage{etoolbox}

%% MARGINS
% Margins should be 1.5 in on the left and 1 in on all other sides.
% Paper size is 8.5x11 in.
\RequirePackage{geometry}
\geometry{vmargin=1in,textwidth=6in}
\ifbool{@umlcentering}{
  \geometry{bindingoffset=0in,centering} 
}{
  \geometry{bindingoffset=0.5in}
}

%% TYPING
% Double space the document
\RequirePackage{setspace}
\doublespacing

% This is not in the thesis guide, but frenchspacing is nicer.
\frenchspacing

% Indent first line of paragraphs by 10 spaces
\newlength{\spacewidth}
\newlength{\fivespaces}
% Set these lengths inside the document so that the font is correct
\AtBeginDocument{
  \setlength{\spacewidth}{1\fontdimen2\font - .3\fontdimen4\font }
  \setlength{\fivespaces}{5\spacewidth}
  \setlength{\parindent}{2\fivespaces}
}
% Always indent the first paragraph of a section/chapter
\RequirePackage{indentfirst}

%% Set chapter heading size (Huge) to 14 pt and all others to 12 pt
\renewcommand{\Huge}{\fontsize{14}{16.8}\selectfont}
\renewcommand{\huge}{\normalsize}
\renewcommand{\LARGE}{\normalsize}
\renewcommand{\Large}{\normalsize}
\renewcommand{\large}{\normalsize}
\renewcommand{\small}{\fontsize{10}{12}\selectfont}
\renewcommand{\footnotesize}{\normalsize}
% \renewcommand{\scriptsize}{\normalsize}
\renewcommand{\tiny}{\fontsize{6}{7.2}\selectfont}


% "The first page of a new chapter should begin 2 in. from the top of the page."
% My interpretation of this is that the heading begins 2 in from the top.
\newcommand*\firstchaptersetup{
  \ifnumgreater{\value{chapter}}{0}{
    \global\booltrue{@maintext}
    %% Only reset page numbers themselves on Chapter 1
    %% (handy when \include'ing only later chapters)
    \ifnumodd{\value{page}}{}{
      \thispagestyle{empty}\clearpage{
        \pagestyle{empty}
        \cleardoublepage
      }
    }
    \pagenumbering{arabic}
    \ifnumequal{\value{chapter}}{1}{\setcounter{page}{1}}{}
  }{}
  % undefine this macro once it has been used
  \ifbool{@maintext}{\global\let\firstchaptersetup\relax}{}
}
\newcommand{\chapterheadingfont}[1]{\Huge \bfseries \underline{#1}}
\apptocmd\appendix{
  \patchcmd{\@makechapterhead}{\thechapter.}{\umlupper{\appendixname} \thechapter.}{}{}
}{}{
  \ClassWarning{umlthesis}{Error prefixing \noexpand\@makechapterhead with \noexpand\appendixname.}
}
\newcommand*{\@makeanychapterhead}[2]{%
  \vspace*{1in}%
  %% Uncomment below to make the text start 2 in down, rather than the heading
  % \newlength{\chapterheadingheight}
  % \settoheight{\chapterheadingheight}{\chapterheading}
  % \vskip -40\p@ \vskip -\chapterheadingheight
  {\parindent \z@ \centering \normalfont \singlespacing
    \chapterheadingfont{#1#2} \par\nobreak
    \vskip 40\p@
  }
}
\renewcommand*{\@makechapterhead}[1]{\firstchaptersetup \@makeanychapterhead{\thechapter. }{#1}}  % Numbered chapters
\renewcommand*{\@makeschapterhead}[1]{\@makeanychapterhead{}{#1}}  % Unnumbered chapters
  


%% PAGE NUMBERING
% This defines a flag that will change the pagestyle. This flag will
% be set automatically when creating the first chapter heading.
\global\newif\if@maintext
\global\@maintextfalse
\pagenumbering{roman}  % Begin the document with lowercase roman numbers

\renewcommand*{\ps@plain}{
  \renewcommand*{\@oddfoot}{\if@maintext\empty\else \hfil \em \thepage \hfil \fi}
  \renewcommand*{\@evenhead}{\if@maintext \rm \thepage \fi \hfil\sl\leftmark\hbox {}}	%
  \renewcommand*{\@oddhead}{\hbox{}\sl\rightmark \hfil \if@maintext \rm\thepage \fi}	%
  \let\@evenfoot\@oddfoot
}
\pagestyle{plain} % reload the plain page style to apply changes
\newcommand*{\ps@chapterpage}{
  \renewcommand*{\@oddfoot}{\hfil \thepage \hfil}
  \let\@evenfoot\@oddfoot
  \let\@oddhead\empty
  \let\@evenhead\@oddhead
}

%% TABLES AND FIGURES
%% TODO: Edit \@makecaption to make Table numbers centered and underlined.
%%       Currently, this affects both Figures and Tables, so it should be
%%       split into two flavors depending on \@captype, which is either
%%       'figure' or 'table'.
% \renewcommand\@makecaption[2]{\vskip \abovecaptionskip \sbox \@tempboxa {\textsc{#1}: #2}\ifdim \wd \@tempboxa > \hsize \textsc{#1}: #2\par \else \global \@minipagefalse \hb@xt@ \hsize {\hfil \box \@tempboxa \hfil }\fi \vskip \belowcaptionskip}
\RequirePackage[labelfont={sc,singlespacing},labelsep=colon,width=\textwidth]{caption}
%% Continuous numering
\RequirePackage{chngcntr}
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}

%% HEADINGS
% Chapter headings are numbered with roman numerals, capitalized,
% horizontally centered on the page, and underlined

% Uppercase Titles
% The \MakeUppercase command is very delicate, and does not play with
% hyperref at all. To handle this, define a command that will *just
% work* in these cases.
\newcommand\umlupper[1]{%
\ifdef{\texorpdfstring}{% hyperref has been loaded:
\texorpdfstring{\MakeUppercase{#1}}{#1}
}{% hyperref has not been loaded:
\MakeUppercase{#1}%
}%
}
\let\ORIGchapter\chapter
\renewcommand*{\chapter}{\@ifstar\@umlchapterstar\@umlchapter}
\newcommand*{\@umlchapter}[1]{\ORIGchapter{\umlupper{#1}}}
\newcommand*{\@umlchapterstar}[1]{\ORIGchapter*{\umlupper{#1}}}

% Roman chapter numbering:
\renewcommand{\thechapter}{\Roman{chapter}}

%% EQUATIONS
% Equation numbering should be a single Arabic numeral.
\renewcommand{\theequation}{\arabic{equation}}


%% FOOTNOTES AND QUOTATIONS
% Footnote spacing
\newlength\footnotemargin
\newlength\footnoteindent
\AtBeginDocument{
  \setlength\footnotemargin{\fivespaces}
  \setlength{\footnoteindent}{\footnotemargin - 1.8em}
  \setlength{\skip\footins}{\parskip + 2\baselineskip}
}

% Add a parbox around the footnote text to control the width.
\global\long\def\@makefntext#1{\hspace*{\footnoteindent}\noindent \hb@xt@ 1.8em{\hss \@makefnmark }\parbox[t]{\textwidth - 2\footnotemargin}{#1}}
\def\@textbottom{ \vskip \z@ \@plus 999fil }
\let\@texttop\relax

% Remove the rule between text and footnotes
\let\footnoterule\relax

% Footnote numbering
\renewcommand{\thefootnote}{\alph{footnote}}

% Change the indentation of quotations
\AtBeginDocument{
  \renewenvironment{quotation}
    {\list{}{\leftmargin=\fivespaces%
             \rightmargin=\fivespaces%
             \itemindent=\parindent}%
     \singlespacing \item\relax}
    {\endlist}
  % \quote is the unindented version, intended for short quotes.
  \renewenvironment{quote}
    {\list{}{\leftmargin=\fivespaces%
             \rightmargin=\fivespaces%
             \itemindent=\z@}%
     \singlespacing \item\relax}
    {\endlist}
}

%% VERBATIM ENVIRONMENT
%% Use single spacing for code blocks.
\RequirePackage{verbatim}
\addto@hook\every@verbatim{\singlespacing}

%% BIBLIOGRAPHY
% Change the default bibliography name
\renewcommand{\bibname}{\umlupper{Literature Cited}}

% Include in table of contents; single spaced entries
\AtBeginEnvironment{thebibliography}{%
  \addcontentsline{toc}{chapter}{{\bibname}}
  \singlespacing
}
\AtEndPreamble{
  \ifdef{\defbibheading}{
    \ClassWarning{umlthesis}{Defining biblatex bibliography headings "bibliography" and "bibintoc"}
    \defbibheading{bibliography}[\bibname]{%
      \chapter*{#1}%
    }
    \defbibheading{bibintoc}[\bibname]{%
      \chapter*{#1}%
      \addcontentsline{toc}{chapter}{\umlupper{#1}}
    }
  }{}
}

% Double spaces between references
% Redefine item separation macros for natbib and biblatex.
\AtEndPreamble{
  % natbib:
  \ifdeflength{\bibsep}{\setlength\bibsep{\parsep}}{}
  % biblatex:
  \ifdeflength{\bibitemsep}{\setlength\bibitemsep{\parsep}}{}
}


%% TABLE OF CONTENTS
\RequirePackage{tocloft}
\renewcommand*\contentsname{\umlupper{Table of Contents}}
\renewcommand*\listfigurename{\umlupper{List of Figures}}
\renewcommand*\listtablename{\umlupper{List of Tables}}

%% Give a little more room to the chapter numbers
\newlength\chapnumextra
\setlength\chapnumextra{1mm}
\addtolength\cftchapnumwidth\chapnumextra
\addtolength\cftsecindent\chapnumextra
\addtolength\cftsubsecindent\chapnumextra

%% Put the LOT and LOF headings into TOC
%% \cftaddtitleline does not insert an entry into the PDF index
\renewcommand\cftlofprehook{%
  \phantomsection%
  \addcontentsline{toc}{chapter}{{\listfigurename}}}
\renewcommand\cftlotprehook{
  \phantomsection%
  \addcontentsline{toc}{chapter}{{\listtablename}}}
%% Also add TOC to PDF index
\renewcommand\cfttocprehook{\phantomsection\ifdefined\pdfbookmark{\pdfbookmark{\contentsname}{chap:tableofcontents}}\fi}

%% Chapter headings in list of figures, tables. This will put /every/
%% chapter in, regardless of whether it contains any tables or
%% figures.
% My best solution for this so far is something like:
%   \immediate\write18{sed -ni -f remove-duplicate-chapters.sed build/main.lof}
% Store chapter titles for later
\newcommand*\chaptertitle{}
\pretocmd{\@chapter}{\renewcommand*\chaptertitle{#1}}{%
}{%
  \ClassError{umlthesis}{Failed to patch \noexpand \@chapter. Chapter titles will not appear correctly in the list of figures or list of tables.}{}%
}
\newcounter{FiguresInChapter}[chapter]
\newcounter{TablesInChapter}[chapter]
\AfterEndEnvironment{figure}{%
  \ifnumequal{\value{FiguresInChapter}}{0}{%
    \stepcounter{FiguresInChapter}%
    \addcontentsline {lof}{chapter}{\protect \numberline {\thechapter }\chaptertitle}%
    \addtocontents {lof}{\protect \nopagebreak}%
  }{%
  }
}
\AtBeginEnvironment{table}{%
  \ifnumequal{\value{TablesInChapter}}{0}{%
    \stepcounter{TablesInChapter}%
    \addcontentsline {lot}{chapter}{\protect \numberline {\thechapter }\chaptertitle}%
    \addtocontents {lot}{\protect \nopagebreak}%
  }{%
  }
}


%% AUTHOR BIOGRAPHY
\newenvironment{authorbio}[1][\umlupper{Author Biography}]{%
  \chapter*{#1}%
  \addcontentsline{toc}{chapter}{{#1}}}%
{}


%% ABSTRACT
\renewenvironment{abstract}{%
  \abstracttitlepage
  \chapter*{\abstractname}
}{}

%% ACKNOWLEDGMENTS
\newenvironment{acknowledgments}{%
\chapter*{Acknowledgments}%
}{%
\clearpage}


%% TITLE PAGE
% All caps, so it's extra ugly
\let\choosecase\umlupper

% Some macros to input information
\newcommand*{\department}[1]{\gdef\@department{#1}}
\newcommand*{\concentration}[1]{\gdef\@concentration{#1}}
\newcommand*{\supervisor}[1]{\gdef\@supervisor{#1}}
\newcommand*{\supervisortitle}[1]{\gdef\@supervisortitle{#1}}
\newcommand*{\supervisorposition}[1]{\gdef\@supervisorposition{#1}}
\newcommand*{\supervisordegree}[1]{\gdef\@supervisordegree{#1}}
\newcommand*{\supervisordepartment}[1]{\gdef\@supervisordepartment{#1}}
\newcommand*{\chair}[1]{\gdef\@chair{#1}}
\newcounter{reader}
\newcommand*{\reader}[1]{%
  \stepcounter{reader}%
  \expandafter\gdef\csname @reader\roman{reader}\endcsname{#1}%
}

% default values
\concentration{\@department}
\supervisortitle{Thesis Supervisor}
\supervisordegree{Ph.D.}
\supervisorposition{Professor}
\supervisordepartment{\@department}
\newcommand*\@chairtitle{Department Chair}

% The current degree(s)
\newcounter{degrees}
\newcommand*{\degree}[1]{\stepcounter{degrees}%
\expandafter\gdef\csname @deg\roman{degrees}\endcsname{#1}%
\ifnum \value{degrees} =1\relax\long\gdef\@degree{\@degi}%
\else%
\xdef\@degree{\@degree\ AND \csname @deg\roman{degrees}\endcsname}%
\fi}
\newcommand*{\@degreeword}{\ifnum \value{degrees} >1 degrees\else degree\fi\ }
\newcounter{degnum}

% Previous degrees are a little trickier
\newcounter{prevdegrees}
\newcommand*\previousdegree[3]{% store the degree to a numbered macro
\stepcounter{prevdegrees}%
\expandafter\gdef\csname @prevdegree\roman{prevdegrees}\endcsname{#1\ {#2} (#3)}\relax%
\ifnum \value{prevdegrees} =1\relax%
\long\gdef\@prevdegrees{\@prevdegreei\relax}%
\else%
\long\xdef\@prevdegrees{\@prevdegrees\par\relax\csname @prevdegree\roman{prevdegrees}\endcsname}%
\fi%
}
% \newcommand{\@prevdegrees}{% Print each degree that has been stored.
% \stepcounter{prevdegreenum}%
% \ifcsname @prevdegree\roman{prevdegreenum}\endcsname%
%   \ifnum \value{prevdegreenum} =1%
%     \@prevdegreei % Print the first with no \par
%   \else%
%     \par \csname @prevdegree\roman{prevdegreenum}\endcsname%
%   \fi%
%   \@prevdegrees % recursively call until we reach an undefined \@prevdegreen
% \else%
%   \setcounter{prevdegreenum}{0}%
% \fi}%

% \let\ORIGmaketitle\maketitle
% \def\maketitle{\pagenumbering{roman}\ORIGmaketitle}
\newcommand*\university{University of Massachusetts Lowell}
\newcommand*{\uni}{UML}

%% Title Page
\newlength\siglinewidth
\setlength\siglinewidth{0.8\textwidth}
\newcommand*{\sigline}[2][]{
  % Begin with some room for the signature
  \vspace{1cm}

  % Create the signature box with name underneath
  \begin{minipage}[t][][l]{\siglinewidth}
    \hrulefill

    {#2\\
      % Print the optional title below the name without adding vertical space
      #1\vspace*{-\baselineskip}\\}
  \end{minipage}
  % Insert a flexible space after the signature block
  \vskip 12pt plus 36pt
}

\renewcommand*{\maketitle}{
  \begin{titlepage}
    \let\name\textsc
    \centering
    \singlespacing
    \vspace*{0pt}\vfill
    {\Huge \choosecase{\@title}}\par

    \vspace{\baselineskip}

    \choosecase{by}

    \vspace{\baselineskip}

    \choosecase{\@author}
    
    \choosecase{\@prevdegrees}

    \vspace{\baselineskip}

    \vfill

    \choosecase{Submitted in partial fulfillment of the requirements}\\
    \choosecase{for the \@degreeword of \@degree}

    \vspace{1.5\baselineskip}
    
    \choosecase{Department of \@department}

    \vspace{1.5\baselineskip}

    \choosecase{\university}
    
    \vfill

    \raggedright
    \hspace*{1cm}\hbox{Author}

    \centering
    \sigline{\name{\@author}\hfill\@date}

    \raggedright
    \hspace*{1cm}\hbox{Thesis Committee}

    \centering
    \sigline[\@supervisortitle]{\name{\@supervisor}}
    \ifdefined\@readeri\sigline{\name{\@readeri}}\fi
    \ifdefined\@readerii\sigline{\name{\@readerii}}\fi
    \ifdefined\@readeriii\sigline{\name{\@readeriii}}\fi
    \ifdefined\@readeriv\sigline{\name{\@readeriv}}\fi
    \ifdefined\@readerv\sigline{\name{\@readerv}}\fi

    %% \vspace{\baselineskip}
    %% \makebox[\siglinewidth][l]{Accepted by}
    
    %% \sigline[\@chairtitle]{\name{\@chair}}
  \end{titlepage}
}

\newcommand*\@degreeyear{2019}
\newcommand*\abstracttitlepage{
  \clearpage
  \thispagestyle{empty}
  \centering
  \singlespacing
  \vspace*{1in}
  {\Huge \choosecase{\@title}}
  
  \vspace{\baselineskip}
  
  \choosecase{by}

  \vspace{\baselineskip}

  \choosecase{\@author}

  \vspace{2\baselineskip}

  \choosecase{Abstract of a dissertation submitted to the faculty of the}

  \choosecase{Department of \@department}

  \choosecase{in partial fulfillment of the requirements}
  \vspace{2\baselineskip}
  
  \choosecase{for the \@degreeword of}

  \choosecase{\@degree}

  \choosecase{\@concentration}

  \choosecase{\university}

  \choosecase{\@degreeyear}

  \vspace{2\baselineskip}
  \raggedright
  Dissertation Supervisor: \@supervisor, \@supervisordegree
  
  \@supervisorposition, \@supervisordepartment
  \newpage
}

\RequirePackage{geometry}