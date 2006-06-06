%% This is LaTeX class `nsf', for NSF proposals
%%
%% Written by Steven Bird, University of Pennsylvania <Steven.Bird@ldc.upenn.edu>.
%%
%% $Id: nsf.cls,v 1.0 1999/05/28 12:53:00 sb Exp $

\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{nsf}[1999/05/28 v1.0 NSF class (SGB)]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}
\usepackage{times}

\oddsidemargin 0in
\evensidemargin 0in
\topmargin 0pt
\headheight 0pt
\headsep 0pt
\hoffset 0pt
\voffset 0pt
\headheight 0pt
\textwidth 6.5in
\textheight 8.5in
\footskip .5in

% Captions in \small\sf
\long\def\@caption#1[#2]#3{\par\begingroup
    \@parboxrestore
    \scriptsize\sf
    \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
  \endgroup}
