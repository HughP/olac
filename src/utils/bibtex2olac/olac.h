/*
** olac.h - Structs that represent OLAC records.
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

typedef struct OLAC_title {

	char *name;
	char *journal;
	char *volume;
	char *number;
	char *edition;
} OLAC_TITLE;

typedef struct OLAC_creator {

	char *name;
	struct OLAC_creator *next;
} OLAC_CREATOR;

typedef struct OLAC_description {

	char *abstract;
	char *contents;
	char *location;
	char *pages;
	char *price;
	char *size;
} OLAC_DESCRIPTION;

typedef struct OLAC_publisher {

	char *publisher;
	char *address;
} OLAC_PUBLISHER;

typedef struct OLAC_record {

	OLAC_TITLE title;
	OLAC_CREATOR *author;
	OLAC_CREATOR *editor;
	OLAC_DESCRIPTION desc;
	OLAC_PUBLISHER publisher;
	char *howpublished;
	char *type;
	char *subject;
	char *language;
	char *rights;
	char *url;
	char *isbn;
	char *issn;
} OLAC_RECORD;
