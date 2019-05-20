% This class will implement all of the formatting specifications in
% the UML Thesis guide.
% https://www.uml.edu/registrar/docs/thesis_guide.pdf
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{umlthesis}[01/23/2019]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

\ExecuteOptions{12pt}

\ProcessOptions\relax

\LoadClass{report}
\RequirePackage{calc}
\RequirePackage{natbib}


%% TYPING
% Double space the document
\RequirePackage{setspace}
\doublespacing

% Indent first line of paragraphs by 10 spaces
\newlength{\spacewidth}
\newlength{\fivespaces}
\settowidth{\spacewidth}{\space}
\setlength{\fivespaces}{5\spacewidth}
\setlength{\parindent}{2\fivespaces}

% Always indent the first paragraph of a section/chapter
\RequirePackage{indentfirst}

%% Set chapter heading size (Huge) to 14 pt and all others to 12 pt
\renewcommand{\Huge}{\fontsize{14}{16.8}\selectfont}
\renewcommand{\footnotesize}{\normalsize}
\renewcommand{\scriptsize}{\normalsize}
\renewcommand{\small}{\normalsize}
\renewcommand{\tiny}{\normalsize}
\renewcommand{\large}{\normalsize}
\renewcommand{\Large}{\normalsize}
\renewcommand{\LARGE}{\normalsize}
\renewcommand{\huge}{\normalsize}


%% MARGINS
% Margins should be 1.5 in on the left and 1 in on all other sides.
% Paper size is 8.5x11 in. 
% Option includefoot makes footnotes respect the bottom margin
\usepackage[letterpaper,left=1.5in,right=1in,top=1in,bottom=1in,includefoot]{geometry}

% "The first page of a new chapter should begin 2 in. from the top of the page."
% My interpretation of this is that the heading begins 2 in from the top.
\newcommand*{\chapterheading}{}
\newcommand*{\@makeanychapterhead}[2]{%
  \renewcommand*{\chapterheading}{\Huge \bfseries \underline{#1#2}}
  \vspace*{1in}%
  %% Uncomment below to make the text start 2 in down, rather than the heading
  % \newlength{\chapterheadingheight}
  % \settoheight{\chapterheadingheight}{\chapterheading}
  % \vskip -40\p@ \vskip -\chapterheadingheight
  {\parindent \z@ \centering \normalfont \singlespacing
    \chapterheading \par\nobreak
    \vskip 40\p@
  }
  % On the first chapter, reset the page numbering
  \ifnum \value{chapter}=1
  {\if@maintext\else%  If we are beginning chapter 1 and not appendix A:
    \global\@maintexttrue
    \pagenumbering{arabic}
    \setcounter{page}{1}
  \fi}\fi }
\renewcommand*{\@makechapterhead}[1]{\@makeanychapterhead{\thechapter. }{#1}}  % Numbered chapters
\renewcommand*{\@makeschapterhead}[1]{\@makeanychapterhead{}{#1}}  % Unnumbered chapters
  


%% PAGE NUMBERING
% This defines a flag that will change the pagestyle. This flag will
% be set automatically when creating the first chapter heading.
\global\newif\if@maintext
\global\@maintextfalse
\pagenumbering{roman}  % Begin the document with lowercase roman numbers

\renewcommand*{\ps@plain}{
  \renewcommand*{\@oddfoot}{\if@maintext\empty\else \hfil \em \thepage \hfil \fi}
  \renewcommand*{\@evenhead}{\if@maintext \rm \thepage\hfil\sl\leftmark\hbox {} \fi}	%
  \renewcommand*{\@oddhead}{\if@maintext \hbox{}\sl\rightmark \hfil \rm\thepage \fi}	%
  \renewcommand*{\@evenfoot}{\@oddfoot}
}
\pagestyle{plain} % reload the plain page style to apply changes

\typeout{TODO: Define the abstract title page here}


%% TABLES AND FIGURES
% I have implemented the necessary changes somewhere. I think it is on
% the laptop. Paste those here.


%% HEADINGS
% Chapter headings are numbered with roman numerals, capitalized,
% horizontally centered on the page, and underlined

% Capitalize
\let\ORIGchapter\chapter
\renewcommand*{\chapter}{\@ifstar\@umlchapterstar\@umlchapter}
\newcommand*{\@umlchapter}[1]{\ORIGchapter{\protect\MakeUppercase{#1}}}
\newcommand*{\@umlchapterstar}[1]{\ORIGchapter*{\protect\MakeUppercase{#1}}}

% Roman chapter numbering:
\renewcommand{\thechapter}{\Roman{chapter}}
\RequirePackage{tocloft}
\newlength\chapnumextra
\setlength\chapnumextra{1mm}
\addtolength\cftchapnumwidth\chapnumextra
\addtolength\cftsecindent\chapnumextra
\addtolength\cftsubsecindent\chapnumextra

%% EQUATIONS
% Equation numbering should be a single Arabic numeral.
\renewcommand{\theequation}{\arabic{equation}}


%% FOOTNOTES AND QUOTATIONS
% Narrower footnote
% First, we define our desired textwidth for footnotes
\newlength\footnotewidth
\setlength{\footnotewidth}{\textwidth - 10\spacewidth}
\renewcommand{\@footnotetext}[1]{% This monster is copied from report.cls
\insert \footins {\reset@font \footnotesize \interlinepenalty \interfootnotelinepenalty \splittopskip \footnotesep \splitmaxdepth \dp \strutbox \floatingpenalty \@MM \hsize \columnwidth \@parboxrestore \protected@edef \@currentlabel {\csname p@footnote\endcsname \@thefnmark }\color@begingroup%  Everything above this is default
\centering\begin{minipage}{\footnotewidth} \singlespacing %  This line is added
{\@makefntext {\rule \z@ \footnotesep \ignorespaces #1\@finalstrut \strutbox }\color@endgroup }%
\end{minipage}% close the minipage.
}}

% Change the indentation of quotations
\renewenvironment{quotation}
               {\list{}{\leftmargin=\fivespaces%
                        \rightmargin=\fivespaces%
                        \itemindent=\fivespaces}%
                \singlespacing \item\relax}
               {\endlist}
\renewenvironment{quote}% \quote is the unindented version, intended for short quotes.
               {\list{}{\leftmargin=\fivespaces%
                        \rightmargin=\fivespaces%
                        \itemindent=0\p@}%
                \singlespacing \item\relax}
               {\endlist}

% Footnote spacing. I think the current spacing is correct, but if not
% edit this:
%\addtolength{\skip\footins}{12pt}

% Remove rule. \vfill pushes the footnotes to the bottom of the page
\renewcommand{\footnoterule}{\vfill}

% Footnote numbering
\renewcommand{\thefootnote}{\alph{footnote}}


%% BIBLIOGRAPHY
% Change the default bibliography name
\renewcommand{\bibname}{Literature Cited}

% Include in table of contents
\let\ORIGbibliography\bibliography
\renewcommand\bibliography[1]{\ORIGbibliography{#1}\addcontentsline{toc}{chapter}{\MakeUppercase{\bibname}}}

% Single spaced
\let\ORIGthebibliography\thebibliography
\renewcommand\thebibliography[1]{\ORIGthebibliography{#1}\singlespacing}


%% TABLE OF CONTENTS
%% TODO: Figure out why figures and tables aren't showing up
% \let\ORIGlof\listoffigures
% \def\listoffigures{\ORIGlof\protect{\protect\addcontentsline{toc}{section}{\listfigurename}}}
% \let\ORIGlot\listoftables
% \def\listoftables{FOO BAR baz}
% \def\ORIGtoc\tableofcontents
% \def\mytableofcontents{\ORIGtoc\listoffigures\listoftables}


%% AUTHOR BIOGRAPHY
\newenvironment{authorbio}[1][Author Biography]{%
  \chapter*{#1}%
  \addcontentsline{toc}{chapter}{\MakeUppercase{#1}}}%
{}


%% ABSTRACT
\renewenvironment{abstract}{%
\chapter*{\abstractname}
}{}

%% ACKNOWLEDGMENTS
\newenvironment{acknowledgments}{%
\chapter*{Acknowledgments}%
}{%
\clearpage}


%% TITLE PAGE
% All caps, so it's extra ugly
\let\choosecase\MakeUppercase

% Some macros to input information
\newcommand*{\department}[1]{\gdef\@department{#1}}
\newcommand*{\supervisor}[1]{\gdef\@supervisor{#1}}
\newcommand*{\supervisortitle}[1]{\gdef\@supervisortitle{#1}}
\newcommand*{\chair}[1]{\gdef\@chair{#1}}
\newcounter{reader}
\newcommand*{\reader}[1]{%
  \stepcounter{reader}%
  \expandafter\gdef\csname @reader\roman{reader}\endcsname{#1}%
}

% default titles
\newcommand*\@supervisortitle{Thesis Supervisor}
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
\gdef\@prevdegrees{\@prevdegreei\relax\relax}%
\else%
\xdef\@prevdegrees{\@prevdegrees\par\relax\csname @prevdegree\roman{prevdegrees}\endcsname}%
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
  \vspace{1cm}
  \begin{minipage}[t][1cm][l]{\siglinewidth}
  \rule{\linewidth}{0.1pt}

  {#2}
  
  \emph{#1}
  \end{minipage}

}

\renewcommand*{\maketitle}{
  \begin{titlepage}
    \let\name\relax
    \centering
    \singlespacing
    \vspace*{}\vfill
    {\Huge \choosecase{\@title}}\par
    \vfill
    \choosecase{by}

    \vfill
    \choosecase{\@author}
    %\@prevdegrees\relax                   % TODO
    \vfill

    \choosecase{Submitted in partial fulfillment of the requirements}\\
    \choosecase{for the \@degreeword of \@degree}

    \vspace{1.5\baselineskip}
    
    \choosecase{\@department}

    \vspace{1.5\baselineskip}

    \choosecase{\university}
    
    \vfill

    \sigline{Author\hfill\@date}
    \sigline[\@supervisortitle]{\name{\@supervisor}}
    \ifdefined\@readeri\sigline{\name{\@readeri}}\fi
    \ifdefined\@readerii\sigline{\name{\@readerii}}\fi
    \ifdefined\@readeriii\sigline{\name{\@readeriii}}\fi
    \ifdefined\@readeriv\sigline{\name{\@readeriv}}\fi
    \ifdefined\@readerv\sigline{\name{\@readerv}}\fi

    \vspace{\baselineskip}
    \makebox[\siglinewidth][l]{Accepted by}
    
    \sigline[\@chairtitle]{\name{\@chair}}
  \end{titlepage}
}

% https://github.com/umasscs/umassthesis/issues/1
\RequirePackage[colorlinks=false]{hyperref}
\pdfstringdefDisableCommands{%
  \let\MakeUppercase\relax
  \let\MakeLowercase\relax
}
