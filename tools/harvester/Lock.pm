#!/usr/bin/perl -w -I.
use strict;

#  ----------------------------------------------------------------------
# | Simple UNIX Semaphores                                               |
# | Hussein Suleman                                                      |
# | July 2001                                                            |
#  ----------------------------------------------------------------------
# |  Virginia Polytechnic Institute and State University                 |
# |  Department of Computer Science                                      |
# |  Digital Libraries Research Laboratory                               |
#  ----------------------------------------------------------------------

package Lock;

sub new
{
   my ($classname, $key) = @_;
   my $self = {};
   bless $self, $classname;
   $self->lock ($key);
   return $self;
}

sub lock
{
   my ($self, $key) = @_;
   open (LOCKLOCK, ">$key");
   flock (LOCKLOCK, 2);
   $self->{lock} = *LOCKLOCK;
}
   
sub unlock
{
   my ($self) = @_;
   close ($self->{lock});
}

sub DESTROY
{
   my ($self) = @_;
   $self->unlock;
}

1;


=head1 NAME

Lock - Simple UNIX Semaphores

=head1 SYNOPSIS

  use Lock;
  
  my $l = new Lock ('lockfile');
  
  # critical section
  
  $l->unlock;
  

=head1 DESCRIPTION

Mutual exclusion implementation using file locks.

=head1 METHODS

=over 4

=item new (key)

=item lock (key)

Locks the specified key - if the key is already locked,
blocks until the key is available.

=item unlock ()

Unlocks the key and makes it available to other waiting
processes as necessary.

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

