#!/usr/bin/perl -w -I.
use strict;

#  ----------------------------------------------------------------------
# | test-and-set Semaphore                                               |
# | Hussein Suleman                                                      |
# | July 2001                                                            |
#  ----------------------------------------------------------------------
# |  Virginia Polytechnic Institute and State University                 |
# |  Department of Computer Science                                      |
# |  Digital Libraries Research Laboratory                               |
#  ----------------------------------------------------------------------

package TS;

use Lock;

sub new 
{
   my ($classname, $filename) = @_;
   my $self = {
      filename => $filename
   };
   bless $self, $classname;
   return $self;
}

sub test
{
   my ($self) = @_;
   my $l = new Lock ('TS.lock');
   if (-e $self->{filename})
   {
      $l->unlock;
      return 0;
   }
   else
   {
      system "touch $self->{filename}";
      $l->unlock;
      return 1;
   }
}

sub clear
{
   my ($self) = @_;
   my $l = new Lock ('TS.lock');
   unlink $self->{filename};
   $l->unlock;
}

1;


=head1 NAME

TS - test-and-set Semaphore

=head1 SYNOPSIS

  use TS;
  
  my $l = new TS ('lockfile');
  
  if ($l->test == 1)
  {
     # critical section
  }
  
  $l->clear;

=head1 DESCRIPTION

Non-blocking atomic test-and-set operation to ensure that while only
one process may be in the critical section at a time, others skip 
over the critical section rather than block.

=head1 METHODS

=over 4

=item new (key)

Creates a new file-based semaphore with the given name.

=item test ()

Attempts to set the semaphore by creating the file. It successful,
returns 1 - otherwise returns 0 - does not block!

=item clear ()

Resets the semaphore by removing the file.

=back

=head1 NOTES

This is part of the larger effort to build componentized digital libraries.

=head1 CAVEATS

Of course this is largely untested :)

=head1 BUGS

None that I found yet.

=head1 AUTHOR

Hussein Suleman <hussein@vt.edu>

=head1 HISTORY

This is the first release version.

=cut

