# Copyright (C) 2014-2020 SUSE LLC
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, see <http://www.gnu.org/licenses/>.

use Test::Most;
use Test::Mojo;
use Test::Warnings ':report_warnings';

use FindBin;
use lib "$FindBin::Bin/lib", "$FindBin::Bin/../external/os-autoinst-common/lib";
use OpenQA::Test::Database;
use OpenQA::Test::TimeLimit '8';

OpenQA::Test::Database->new->create;
Test::Mojo->new('OpenQA::WebAPI')->get_ok('/')->status_is(200)->content_like(qr/Welcome to openQA/i);

done_testing;
