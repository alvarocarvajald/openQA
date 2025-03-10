# Copyright 2014 SUSE LLC
# SPDX-License-Identifier: GPL-2.0-or-later

package OpenQA::WebAPI::Controller::Admin::User;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my ($self) = @_;
    my @users = $self->schema->resultset('Users')->search(undef)->all;

    $self->stash('users', \@users);
    $self->render('admin/user/index');
}

sub update {
    my ($self) = @_;
    my $set = $self->schema->resultset('Users');
    my $is_admin = 0;
    my $is_operator = 0;
    my $role = $self->param('role') // 'user';

    if ($role eq 'admin') {
        $is_admin = 1;
        $is_operator = 1;
    }
    elsif ($role eq 'operator') {
        $is_operator = 1;
    }

    my $err = 0;
    my $msg = '';

    my $user = $set->find($self->param('userid'));
    if (!$user) {
        $err = 404;
        $msg = "Can't find that user";
    }
    else {
        $user->update({is_admin => $is_admin, is_operator => $is_operator});
        $msg = 'User ' . $user->nickname . ' updated';
        $self->emit_event('user_update_res', {nickname => $user->nickname, role => $role});
    }

    if (($self->tx->req->headers->accept // '') eq 'application/json') {
        return $self->render(json => {$err ? 'error' : 'status' => $msg}, status => ($err ? $err : '200'));
    }
    else {
        $self->flash($err ? 'error' : 'info', $msg);
        $self->redirect_to($self->url_for('admin_users'));
    }
}

1;
