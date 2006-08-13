/*
** bib2olac.c - A bibtex to OLAC (XML) converter.
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
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <unistd.h>
#include <btparse.h>
#include "olac.h"
#include "xml.h"

#define BUFFER_SIZE 16384
#define CONTENT_ID "<GENERATED_CONTENT_HERE />"
#define REPOS_ID "<RepositoryIdentifier>"

OLAC_RECORD *parse_bibtex_entry(AST *, boolean, char *);
void print_olac_record(OLAC_RECORD *, FILE *, char*);
void usage();

/*
** main
*/

int main(int argc, char **argv) {

	char *bibtex_filename = NULL, *template_filename = NULL,
		 *output_filename = NULL, tmp_filename[L_tmpnam];
	FILE *bibtex_file = NULL, *output_file = NULL, *template_file = NULL,
		 *tmp_file = NULL;

	char buffer[BUFFER_SIZE], *content = NULL, *repository_id;

	AST *entry = NULL;
	OLAC_RECORD *olac_record = NULL;

	boolean valid;
	int c, i, failure, begin_index, end_index;

	while ((c = getopt(argc, argv, "i:o:t:")) != EOF) {

		switch(c) {

			case 't':	template_filename = optarg;
						break;

			case 'i':	bibtex_filename = optarg;
						break;

			case 'o':	output_filename = optarg;
						break;

			default:	usage();
						break;
		}
	}

	if (bibtex_filename == NULL || template_filename == NULL)
		usage();

	/* Transform the special TeX character entities in the bibliography file
	** into their Latin-1 equivalents, and then the entire file into UTF-8. */

	bibtex_file = fopen(bibtex_filename, "r");
	tmpnam(tmp_filename);

	tmp_file = fopen(tmp_filename, "w");

	if (bibtex_file == NULL) {

		fprintf(stderr,
				"Error: Unable to read from file %s.\n", bibtex_filename);
		exit(EXIT_FAILURE);
	}

	if (tmp_file == NULL) {

		fprintf(stderr, "Error: Unable to create temporary file.\n");
		exit(EXIT_FAILURE);
	}

	while ((c = getc(bibtex_file)) != EOF)
		putc(c, tmp_file);

	fclose(tmp_file);

	sprintf(buffer, "recode -d ltex..Latin-1 %s", tmp_filename);
	failure = system(buffer);

	if (failure) {

		fprintf(stderr,
				"Error: Unable to transform TeX entities to Latin-1.\n");
		exit(EXIT_FAILURE);
	}

	sprintf(buffer, "recode Latin-1..UTF-8 %s", tmp_filename);
	failure = system(buffer);

	if (failure) {

		fprintf(stderr,
				"Error: Unable to convert temporary file to UTF-8.\n");
		exit(EXIT_FAILURE);
	}

	if (output_filename != NULL) {

		output_file = fopen(output_filename, "w");

		if (output_file == NULL) {

			fprintf(stderr, "Error: Unable to open file %s for writing.\n",
					output_filename);
			exit(EXIT_FAILURE);
		}
	}

	else
		output_file = stdout;

	bt_initialize();

	/* Print out the initial portion of the template file. */

	template_file = fopen(template_filename, "r");

	if (template_file == NULL) {

		fprintf(stderr, "Error: Unable to read from template file %s.\n",
				template_filename);
		exit(EXIT_FAILURE);
	}

	while (fgets(buffer, BUFFER_SIZE, template_file) != NULL) {

		/* For comparison purposes, prune any prefixing whitespace. */

		content = buffer;

		for (i = 0; buffer[i] != '\0'; i++) {

			content = &buffer[i];

			if (!isspace(buffer[i]))
				break;
		}

		if (strncasecmp(content, REPOS_ID, strlen(REPOS_ID)) == 0) {

			begin_index = strlen(REPOS_ID);

			for (i = begin_index; content[i] != '<'; i++)
				;

			end_index = i;

			repository_id = malloc(sizeof(char) * (end_index - begin_index) + 1);

			if (repository_id == NULL) {

				fprintf(stderr, "Error: Not enough memory.\n");
				exit(EXIT_FAILURE);
			}

			memcpy(repository_id, &content[begin_index],
				   end_index - begin_index);
			repository_id[end_index-begin_index] = '\0';

			fprintf(output_file, "%s", buffer);
		}

		else if (strncasecmp(content, CONTENT_ID, strlen(CONTENT_ID)) == 0) {

			if (repository_id == NULL) {

				fprintf(stderr,
						"Error: Repository identifier not found in template.\n");
				exit(EXIT_FAILURE);
			}

			break;
		}

		else
			fprintf(output_file, "%s", buffer);
	}

	/* Read in the Bibtex records using the btparse module, and print out the
	** OLAC XML records. */

	tmp_file = fopen(tmp_filename, "r");

	if (!tmp_file) {

		fprintf(stderr, "Error: Unable to read from temporary file.\n");
		exit(EXIT_FAILURE);
	}

	i = 1;

	while (entry = bt_parse_entry(tmp_file, bibtex_filename, 0, &valid)) {

		sprintf(buffer, "oai:%s:%.2d", repository_id, i);

		olac_record = parse_bibtex_entry(entry, valid, bibtex_filename);
		print_olac_record(olac_record, output_file, buffer);

		i++;
	}

	while (fgets(buffer, BUFFER_SIZE, template_file) != NULL)
		fprintf(output_file, "%s", buffer);

	bt_cleanup();

	free(repository_id);
	exit(EXIT_SUCCESS);
}

/*
** parse_bibtex_entry
**
**	Uses the btparse module to parse the supplied bibtex entry and construct
**	an OLAC_RECORD struct, which is then resturned.
*/

OLAC_RECORD *parse_bibtex_entry(AST *entry, boolean valid,
								char *bibtex_filename) {

	OLAC_RECORD *olac_record;
	OLAC_CREATOR *creator;
	bt_stringlist *name_list = NULL;
	AST *field = NULL;
	char *field_name = NULL;
	int i;

	if (valid && bt_entry_metatype(entry) == BTE_REGULAR) {

		olac_record = malloc(sizeof(OLAC_RECORD));

		if (olac_record == NULL) {

			fprintf(stderr, "Error: Not enough memory.\n");
			exit(EXIT_FAILURE);
		}

		olac_record->title.name = NULL;
		olac_record->title.journal = NULL;
		olac_record->title.volume = NULL;
		olac_record->title.number = NULL;
		olac_record->title.edition = NULL;
		olac_record->author = olac_record->editor = NULL;
		olac_record->desc.abstract = NULL;
		olac_record->desc.contents = NULL;
		olac_record->desc.location = NULL;
		olac_record->desc.pages = NULL;
		olac_record->desc.price = NULL;
		olac_record->desc.size = NULL;
		olac_record->howpublished = NULL;
		olac_record->publisher.publisher = NULL;
		olac_record->publisher.address = NULL;
		olac_record->type = NULL;
		olac_record->subject = NULL;
		olac_record->language = NULL;
		olac_record->rights = NULL;
		olac_record->url = NULL;
		olac_record->isbn = NULL;
		olac_record->issn = NULL;

		while (field = bt_next_field(entry, field, &field_name)) {

			if (strcasecmp(field_name, "abstract") == 0)
				olac_record->desc.abstract = bt_get_text(field);

			else if (strcasecmp(field_name, "author") == 0 ||
					 strcasecmp(field_name, "editor") == 0) {

				name_list = bt_split_list(bt_get_text(field), "and",
										  bibtex_filename, -1, "name");

				for (i = 0; i < name_list->num_items; i++) {

					creator = malloc(sizeof(OLAC_CREATOR));

					if (creator == NULL) {

						fprintf(stderr, "Error: Not enough memory.\n");
						exit(EXIT_FAILURE);
					}

					creator->name = name_list->items[i];

					/* Push the author/editor to the front of the OLAC
					** record's list. */

					if (strcasecmp(field_name, "author") == 0) {

						creator->next = olac_record->author;
						olac_record->author = creator;
					}

					else {

						creator->next = olac_record->editor;
						olac_record->editor = creator;
					}
				}
			}

			else if (strcasecmp(field_name, "booktitle") == 0) {

				/* If a title has already been read in from a 'title'
				** field, do _not_ overwrite it. */

				if (olac_record->title.name == NULL)
					olac_record->title.name = bt_get_text(field);
			}

			else if (strcasecmp(field_name, "contents") == 0)
				olac_record->desc.contents = bt_get_text(field);

			else if (strcasecmp(field_name, "copyright") == 0)
				olac_record->rights = bt_get_text(field);

			else if (strcasecmp(field_name, "howpublished") == 0)
				olac_record->howpublished = bt_get_text(field);

			else if (strcasecmp(field_name, "keywords") == 0)
				olac_record->subject = bt_get_text(field);

			else if (strcasecmp(field_name, "language") == 0)
				olac_record->language = bt_get_text(field);

			else if (strcasecmp(field_name, "location") == 0)
				olac_record->desc.location = bt_get_text(field);

			else if (strcasecmp(field_name, "pages") == 0)
				olac_record->desc.pages = bt_get_text(field);

			else if (strcasecmp(field_name, "price") == 0)
				olac_record->desc.price = bt_get_text(field);

			else if (strcasecmp(field_name, "size") == 0)
				olac_record->desc.size = bt_get_text(field);

			else if (strcasecmp(field_name, "title") == 0)
				olac_record->title.name = bt_get_text(field);

			else if (strcasecmp(field_name, "type") == 0)
				olac_record->type = bt_get_text(field);

			else if (strcasecmp(field_name, "url") == 0)
				olac_record->url = bt_get_text(field);
		}
	}

	return olac_record;
}

/*
** print_olac_record
**
**	Prints the supplied OLAC record as OLAC XML to the supplied file stream.
*/

void print_olac_record(OLAC_RECORD *record, FILE *output_file, char *id) {

	OLAC_CREATOR *creator = NULL;
	XML_NODE *record_node, *header_node, *metadata_node, *new_node, *olac_node;
	char *buffer = malloc(sizeof(char) * BUFFER_SIZE);
	bt_stringlist *subject_list = NULL;
	int i;

	time_t now = time(NULL);
	struct tm *currtime = localtime(&now);

	if (buffer == NULL) {

		fprintf(stderr, "Error: Not enough memory.\n");
		exit(EXIT_FAILURE);
	}

	buffer[0] = '\0';

	/* Create a new record node and add in the metadata. */

	record_node = xml_new_node("oai:record", NULL);

	header_node = xml_new_node("oai:header", NULL);
	xml_add_child(record_node, header_node);

	new_node = xml_new_node("oai:identifier", id);
	xml_add_child(header_node, new_node);

	strftime(buffer, BUFFER_SIZE, "%Y-%m-%d", currtime);
	new_node = xml_new_node("oai:datestamp", buffer);
	xml_add_child(header_node, new_node);

	metadata_node = xml_new_node("oai:metadata", NULL);
	xml_add_child(record_node, metadata_node);

	olac_node = xml_new_node("olac:olac", NULL);
	xml_add_child(metadata_node, olac_node);

	buffer[0] = '\0';

	/* Populate this record, beginning with the work's title, if present. */

	if (record->title.name != NULL) {

		strcat(buffer, record->title.name);

		if (record->title.journal != NULL) {

			strcat(buffer, ", ");
			strcat(buffer, record->title.journal);
		}

		if (record->title.volume != NULL) {

			strcat(buffer, " ");
			strcat(buffer, record->title.volume);

			if (record->title.number != NULL) {

				strcat(buffer, " (");
				strcat(buffer, record->title.number);
				strcat(buffer, ")");
			}
		}

		if (record->title.edition != NULL) {

			strcat(buffer, ", Edition ");
			strcat(buffer, record->title.edition);
		}

		new_node = xml_new_node("dc:title", buffer);
		xml_add_child(olac_node, new_node);
	}

	/* Add in all authors. */

	creator = record->author;

	while (creator != NULL) {

		new_node = xml_new_node("dc:creator", creator->name);
		xml_add_attr(new_node, "xsi:type", "olac:role");
		xml_add_attr(new_node, "olac:code", "author");
		xml_add_child(olac_node, new_node);
		creator = creator->next;
	}

	/* Add in all editors. */

	creator = record->editor;

	while (creator != NULL) {

		new_node = xml_new_node("dc:contributor", creator->name);
		xml_add_attr(new_node, "xsi:type", "olac:role");
		xml_add_attr(new_node, "olac:code", "editor");
		xml_add_child(olac_node, new_node);
		creator = creator->next;
	}

	buffer[0] = '\0';

	if (record->desc.abstract != NULL) {

		strcat(buffer, "Abstract: ");
		strcat(buffer, record->desc.abstract);
	}

	if (record->desc.contents != NULL) {

		if (strlen(buffer) > 0)
			strcat(buffer, " ");

		strcat(buffer, "Contents: ");
		strcat(buffer, record->desc.contents);
	}

	if (record->desc.location != NULL) {

		if (strlen(buffer) > 0)
			strcat(buffer, " ");

		strcat(buffer, "Location: ");
		strcat(buffer, record->desc.location);
		strcat(buffer, ".");
	}

	if (record->desc.pages != NULL) {

		if (strlen(buffer) > 0)
			strcat(buffer, " ");

		strcat(buffer, "Pages: ");
		strcat(buffer, record->desc.pages);
		strcat(buffer, ".");
	}

	if (record->desc.price != NULL) {

		if (strlen(buffer) > 0)
			strcat(buffer, " ");

		strcat(buffer, "Price: ");
		strcat(buffer, record->desc.price);
		strcat(buffer, ".");
	}

	if (record->desc.size != NULL) {

		if (strlen(buffer) > 0)
			strcat(buffer, " ");

		strcat(buffer, "Size: ");
		strcat(buffer, record->desc.size);
		strcat(buffer, ".");
	}

	if (strlen(buffer) > 0) {

		new_node = xml_new_node("dc:description", buffer);
		xml_add_child(olac_node, new_node);
	}

	if (record->publisher.publisher != NULL) {

		buffer[0] = '\0';
		strcat(buffer, record->publisher.publisher);

		if (record->publisher.address != NULL) {

			strcat(buffer, " (");
			strcat(buffer, record->publisher.address);
			strcat(buffer, ")");
		}

		new_node = xml_new_node("dc:publisher", buffer);
		xml_add_child(olac_node, new_node);
	}

	if (record->howpublished != NULL) {

		new_node = xml_new_node("dc:format", record->howpublished);
		xml_add_child(olac_node, new_node);
	}

	if (record->type != NULL) {

		new_node = xml_new_node("dc:type", record->type);
		xml_add_child(olac_node, new_node);
	}

	if (record->subject != NULL) {

		subject_list = bt_split_list(record->subject, ",", "", -1, "keyword");

		for (i = 0; i < subject_list->num_items; i++) {

			new_node = xml_new_node("dc:subject", subject_list->items[i]);
			xml_add_child(olac_node, new_node);
		}
	}

	if (record->language != NULL) {

		new_node = xml_new_node("olac:language", record->language);
		xml_add_child(olac_node, new_node);
	}

	if (record->rights != NULL) {

		new_node = xml_new_node("dc:rights", record->rights);
		xml_add_child(olac_node, new_node);
	}

	if (record->url != NULL) {

		new_node = xml_new_node("dc:identifier", record->url);
		xml_add_child(olac_node, new_node);
	}

	if (record->isbn != NULL) {

		buffer[0] = '\0';
		strcat(buffer, "ISBN: ");
		strcat(buffer, record->isbn);

		new_node = xml_new_node("dc:identifier", buffer);
		xml_add_child(olac_node, new_node);
	}

	if (record->issn != NULL) {

		buffer[0] = '\0';
		strcat(buffer, "ISSN: ");
		strcat(buffer, record->issn);

		new_node = xml_new_node("dc:identifier", buffer);
		xml_add_child(olac_node, new_node);
	}

	xml_emit(output_file, record_node, 0);
	xml_free(record_node);
	free(buffer);
}

/*
** usage
**
**	Prints out a message to stderr detailing how the program should be run.
*/

void usage(void) {

	fprintf(stderr,
			"Usage: %s%s\n", "bib2olac -i bibtex_file -t template_xml_file ",
			"[-o output_file]");
	exit(EXIT_FAILURE);
}
