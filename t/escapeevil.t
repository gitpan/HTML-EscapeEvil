
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl HTML-EscapeEvil.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 10;
use strict;
use Data::Dumper;
use warnings;

# ==================================================== #
# 1
# Require Check
# ==================================================== #
use_ok('HTML::EscapeEvil');

my($escapeevil,%option,$html,$htmlfile,$writehtmlfile);
%option = (
			allow_comment => 1,
			allow_declaration => 1,
			allow_process => 1,
			allow_style => 1,
			allow_script => 1,
			allow_entity_reference => 1,
			collection_process => 1,
			allow_tags => [qw(html head title body)],
		);

$html = <<HTML;
<html>
<head>
<title>test</title>
</head>

<body>
hello
<?PI?>
<a href="hello.html">a</a>
</body>
</html>
HTML

$htmlfile = "t/escapeevil.html";
$writehtmlfile = "write.html";

# ==================================================== #
# 2
# Create Instance Check
# ==================================================== #
ok($escapeevil = HTML::EscapeEvil->new(%option));

# ==================================================== #
# 3
# Accessor Method Check
# ==================================================== #
can_ok($escapeevil,qw(allow_comment allow_declaration allow_process allow_entity_reference allow_script allow_style collection_process processes));

# ==================================================== #
# 4
# Definition Method Check
# ==================================================== #
can_ok($escapeevil,qw(set_allow_tags add_allow_tags deny_tags get_allow_tags is_allow_tags deny_all filtered_html filtered_file clear clear_process parse parse_file));

# ==================================================== #
# 5 - 10
# Operation Check
# ==================================================== #
my @tags = $escapeevil->get_allow_tags;
is(scalar @tags,6);

$escapeevil->add_allow_tags("a");
ok($escapeevil->is_allow_tags("a"));
$escapeevil->deny_tags("a");
ok(!$escapeevil->is_allow_tags("a"));

$escapeevil->parse($html);
isnt($escapeevil->filtered_html,$html);

$escapeevil->parse_file($htmlfile);
$escapeevil->filtered_file($writehtmlfile);
ok(-e $writehtmlfile);
unlink $writehtmlfile;

ok(@{$escapeevil->processes});

$escapeevil->clear;
