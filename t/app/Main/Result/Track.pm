package t::app::Main::Result::Track;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('track');
__PACKAGE__->add_columns(qw/ trackid cdid title /);
__PACKAGE__->set_primary_key('trackid');
__PACKAGE__->belongs_to('cd' => 't::app::Main::Result::Cd', 'cdid');

__PACKAGE__->load_components(qw/ Result::ColumnData /);
__PACKAGE__->register_relationships_columns_data();
1;
