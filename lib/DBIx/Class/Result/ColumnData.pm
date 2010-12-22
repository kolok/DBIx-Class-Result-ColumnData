package DBIx::Class::Result::ColumnData;

use warnings;
use strict;

=head1 NAME

DBIx::Class::Result::ColumnData - Result::ColumnData component  for DBIx::Class

This module is used to extract column data only from a data object base on DBIx::Class::Core

It defined relationships methods to extract columns data only of relationships

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

in your DBIx::Class::Core base class declare Result::ColumnData component

    Package::Schema::Result::MyClass;

    use strict;
    use warning;

    __PACKAGE__->load_component(qw/ ... Result::DataColumn /);

    #Declare here associations before register_relationships_columns_data
    __PACKAGE__->belongs_to(...);
    __PACKAGE__->has_many(...);

    __PACKAGE__->register_relationships_columns_data();

you will use columns_data functions on instance of MyClass

    $my_class->columns_data
    $my_class->I<relationships>_columns_data

=head2 columns_data

return only column_data from an object DBIx::Class::Core

=cut

sub columns_data
{
  my $obj = shift;
  my $rh_data =  $obj->{_column_data};
  foreach my $key (keys %{$rh_data})
  {
    $rh_data->{$key} = $obj->_display_date($key) if (ref($rh_data->{$key}) eq 'DateTime');
  }
  if ($obj->isa('DBIx::Class::Result::Validation') && defined($obj->result_errors))
  {
    $rh_data->{result_errors} = $obj->result_errors;
  }
  return $rh_data;
}


sub _display_date
{
  my ($obj, $key) = @_;
  my $class = ref $obj;
  return $class->column_info($key)->ymd  if $class->column_info($key)->data_type eq 'date';
  return $class->column_info($key)->ymd.' '.$class->column_info($key)->hms if $class->column_info($key)->data_type eq 'datetime';
  return '';
}

=head2 register_relationships_columns_data

declare functions for each relationship on canva : I<relationship>_columns_data which return a hash columns data for a single relationship and an list of hash columns data for multi relationships

    Package::Schema::Result::Keyboard->belongs_to( computer => "Package::Schema::Result::Computer", computer_id);
    Package::Schema::Result::Keyboard->has_many( keys => "Package::Schema::Result::Key", keyboard_id);

register_relationships_columns_data generate instance functions for Keyboard object

    $keybord->keys_columns_data()

    # return 
    #     [
    #       { id => 1, value => 'A', azerty_position => 1},
    #       { id => 2, value => 'B', azerty_position => 25},
    #       ....
    #     ];

    $keybord->cumputer_columns_data()

    # return 
    #    { id => 1, os => 'ubuntu' };

=cut


sub register_relationships_columns_data {
  my ($class) = @_;
  foreach my $relation ($class->relationships())
  {
    my $relation_type = $class->relationship_info($relation)->{attrs}->{accessor};
    if ($relation_type eq 'single')
    {
      my $method_name = $relation.'_columns_data';
      my $method_code = sub {

        my $self = shift;
        my $relobject = $self->$relation;
        return $relobject->columns_data() if defined $relobject;
        return undef;
      };
      {
        no strict 'refs';
        *{"${class}::${method_name}"} = $method_code;
      }
    }
     if ($relation_type eq 'multi')
    {
      my $method_name = $relation.'_columns_data';
      my $method_code = sub {

        my $self = shift;
        my @relobjects = $self->$relation;
        my @relobjects_columns_data = ();
        foreach my $relobject (@relobjects)
        {
          push @relobjects_columns_data, $relobject->columns_data();
        }
        return @relobjects_columns_data;
      };
      {
        no strict 'refs';
        *{"${class}::${method_name}"} = $method_code;
      }
    }
  }
}

=head1 AUTHOR

Nicolas Oudard, <nicolas@oudard.org>

=head1 BUGS

Please report any bugs or feature requests to C<bug-dbix-class-result-columndata at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DBIx-Class-Result-ColumnData>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DBIx::Class::Result::ColumnData


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Nicolas Oudard.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of DBIx::Class::Result::ColumnData
