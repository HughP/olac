/*
** xml.h - Structs and function declarations for outputting simple XML.
** David Ormiston-Smith
** badenh@csse.unimelb.edu.au, daosmith@csse.unimelb.edu.au
** 2006-07-25
** Version 1

** Copyright (C) 2006 David Ormiston-Smith and Baden Hughes

** This program is free software; you can redistribute it and/or modify it
** under the terms of the GNU General Public License as published by the Free
** Software Foundation; either version 2 of the License, or (at your option)
** any later version.

** This program is distributed in the hope that it will be useful, but WITHOUT
** ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License at
** http://www.opensource.org/licenses/gpl-license.php for more details.

** You should have received a copy of the GNU General Public License along
** with this program (file: LICENSE); if not, write to the Free Software
** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

#include <stdio.h>

typedef struct XML_node {

	char *name;
	char *value;
	struct XML_node *children;
	struct XML_node *parent;
	struct XML_node *left_sibling;
	struct XML_node *right_sibling;
	struct XML_attr *attributes;
} XML_NODE;

typedef struct XML_attr {

	char *name;
	char *value;
	struct XML_attr *next;
} XML_ATTR;

XML_NODE *xml_new_node(char *, char *);
XML_NODE *xml_add_attr(XML_NODE *, char *, char *);
void xml_add_child(XML_NODE *, XML_NODE *);
void xml_emit(FILE *, XML_NODE *, int);
void xml_free(XML_NODE *);
