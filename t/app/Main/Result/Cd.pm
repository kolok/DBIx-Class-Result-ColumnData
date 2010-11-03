package t::app::Main::Result::Cd;
use base qw/DBIx::Class::Core/;
__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->table('cd');
__PACKAGE__->add_columns(qw/ cdid artistid title/);
__PACKAGE__->set_primary_key('cdid');
__PACKAGE__->belongs_to('artist' => 't::app::Main::Result::Artist', 'artistid');
__PACKAGE__->has_many('tracks' => 't::app::Main::Result::Track', 'cdid');

__PACKAGE__->load_components(qw/ Result::ColumnData /);
__PACKAGE__->register_relationships_columns_data();
1;
