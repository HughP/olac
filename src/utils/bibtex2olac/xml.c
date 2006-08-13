/*
** xml.c - Simple XML writing functions.
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

#include <stdlib.h>
#include <string.h>
#include "xml.h"

#define BUFFER_SIZE 16384

void xml_free_attr(XML_ATTR *);

XML_NODE *xml_new_node(char *name, char *value) {

	XML_NODE *new_node = malloc(sizeof(XML_NODE));

	if (new_node == NULL) {

		fprintf(stderr, "Error: xml_new_node: Not enough memory.\n");
		exit(EXIT_FAILURE);
	}

	new_node->name = strdup(name);

	if (value != NULL)
		new_node->value = strdup(value);

	else
		new_node->value = NULL;

	new_node->children = new_node->parent = NULL;
	new_node->left_sibling = new_node->right_sibling = NULL;
	new_node->attributes = NULL;

	return new_node;
}

XML_NODE *xml_add_attr(XML_NODE *node, char *name, char *value) {

	XML_ATTR *new_attr = malloc(sizeof(XML_ATTR));

	if (new_attr == NULL) {

		fprintf(stderr, "Error: xml_add_attr: Not enough memory.\n");
		exit(EXIT_FAILURE);
	}

	new_attr->name = strdup(name);
	new_attr->value = strdup(value);

	new_attr->next = node->attributes;
	node->attributes = new_attr;

	return node;
}

void xml_add_child(XML_NODE *parent, XML_NODE *new_child) {

	XML_NODE *curr_child = parent->children;

	new_child->parent = parent;

	if (curr_child == NULL) {

		parent->children = new_child;
		return;
	}

	while (curr_child->right_sibling != NULL)
		curr_child = curr_child->right_sibling;

	curr_child->right_sibling = new_child;
	new_child->left_sibling = curr_child;
}

void xml_emit(FILE *output, XML_NODE *node, int indent) {

	int i;
	XML_ATTR *curr_attr = node->attributes;
	char *buffer = malloc(sizeof(char) * BUFFER_SIZE);

	if (buffer == NULL) {

		fprintf(stderr, "Error: xml_emit: Not enough memory.\n");
		exit(EXIT_FAILURE);
	}

	for (i = 0; i < indent; i++)
		buffer[i] = '\t';

	buffer[i] = '\0';

	strcat(buffer, "<");
	strcat(buffer, node->name);

	while (curr_attr != NULL) {

		strcat(buffer, " ");
		strcat(buffer, curr_attr->name);
		strcat(buffer, "=\"");
		strcat(buffer, curr_attr->value);
		strcat(buffer, "\"");

		curr_attr = curr_attr->next;
	}

	strcat(buffer, ">");

	if (node->value != NULL)
		strcat(buffer, node->value);

	fprintf(output, buffer);

	if (node->children != NULL) {

		fprintf(output, "\n");

		xml_emit(output, node->children, indent + 1);

		for (i = 0; i < indent; i++)
			buffer[i] = '\t';

		buffer[i] = '\0';
	}

	else
		buffer[0] = '\0';

	strcat(buffer, "</");
	strcat(buffer, node->name);
	strcat(buffer, ">\n");

	fprintf(output, buffer);

	free(buffer);

	if (node->right_sibling != NULL)
		xml_emit(output, node->right_sibling, indent);
}

void xml_free(XML_NODE *node) {

	if (node->children != NULL)
		xml_free(node->children);

	if (node->right_sibling != NULL)
		xml_free(node->right_sibling);

	if (node->attributes != NULL)
		xml_free_attr(node->attributes);

	if (node->left_sibling != NULL)
		node->left_sibling->right_sibling = NULL;

	free(node->name);
	free(node->value);

	free(node);
}

void xml_free_attr(XML_ATTR *attr) {

	if (attr->next != NULL)
		xml_free_attr(attr->next);

	free(attr->name);
	free(attr->value);
	free(attr);
}
