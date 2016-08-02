package t::app::Main::Result::Cd;
use base qw/DBIx::Class::Core/;
__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->table('cd');
__PACKAGE__->add_columns('cdid',
                         { 
                           data_type => "integer", 
                           is_auto_increment => 1, 
                           is_nullable => 0 
                         },
                         'artistid',
                         {
                           data_type => 'integer', 
                           is_nullable => 0
                         },
                         'title',
                         {
                           data_type => 'varchar', 
                           is_nullable => 0,
                           hide_field => 1
                         },
                         'date',
                         {
                           data_type => 'date', 
                           is_nullable => 1,
                         },
                         'last_listen',
                         {
                           data_type => 'datetime', 
                           is_nullable => 1
                         },
                       );
__PACKAGE__->set_primary_key('cdid');
__PACKAGE__->belongs_to('artist' => 't::app::Main::Result::Artist', 'artistid');
__PACKAGE__->has_many('tracks' => 't::app::Main::Result::Track', 'cdid');


# Add Virtuals columns
__PACKAGE__->load_components(
    "InflateColumn::DateTime", "TimeStamp",
    "IntrospectableM2M",
    "VirtualColumns", "ColumnDefault"
);

__PACKAGE__->add_virtual_columns(
    real_start_date => {
        data_type          => "datetime", is_nullable => 1,
        set_virtual_column => \&_real_start_date
    },
    real_end_date => {
        data_type          => "datetime", is_nullable => 1,
        set_virtual_column => \&_real_end_date
    },
);

sub _real_end_date {
    my $self = shift;
    my $dt = DateTime->new(
        year       => 1987,
        month      => 12,
        day        => 18,
        hour       => 16,
        minute     => 12,
        second     => 47,
        nanosecond => 500000000,
        time_zone  => 'America/Los_Angeles',
    );

    my $date = $dt->ymd . ' ' . $dt->hms;
    $self->set_column( 'real_end_date', $date );
    return $self->real_end_date;
}

sub _real_start_date {
    my $self = shift;
    my $dt = DateTime->new(
        year       => 1987,
        month      => 12,
        day        => 18,
        hour       => 16,
        minute     => 12,
        second     => 47,
        nanosecond => 500000000,
        time_zone  => 'America/Los_Angeles',
    );

    my $date = $dt->ymd . ' ' . $dt->hms;
    $self->set_column( 'real_start_date', $date );
    return $self->real_start_date;
}



__PACKAGE__->load_components(qw/ Result::ColumnData /);
__PACKAGE__->register_relationships_column_data();
1;
