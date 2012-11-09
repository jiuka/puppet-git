
# Set alias.st global
gitconfig { 'set alias.st global':
    key   => 'alias.st',
    value => 'status';
}

# Set alias.st for repo
gitconfig { 'set alias.st for repo':
    repo  => '/tmp/newrepo.git',
    key   => 'alias.st',
    value => 'status';
}

# Unset alias.st global
gitconfig { 'unset alias.st global':
    ensure => unset,
    key    => 'alias.st';
}

# Unset alias.st for repo
gitconfig { 'unset alias.st for repo':
    ensure => unset,
    repo   => '/tmp/newrepo.git',
    key    => 'alias.st';
}

# Add some values for single key
gitconfig { 'add some values for single key_1':
    ensure => add,
    repo   => '/tmp/newrepo.git',
    key    => 'remote.slaves.url',
    value  => '../remote1.git';
}
gitconfig { 'add some values for single key_2':
    ensure => add,
    repo   => '/tmp/newrepo.git',
    key    => 'remote.slaves.url',
    value  => '../remote2.git';
}
gitconfig { 'add some values for single key_3':
    ensure => add,
    repo   => '/tmp/newrepo.git',
    key    => 'remote.slaves.url',
    value  => '../remote3.git';
}
