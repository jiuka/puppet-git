
# Create repo
git { '/tmp/newrepo': }

# Create bare repo
git { '/tmp/newrepo.git':
    bare => true;
}

# Clone repo
git { 'git://github.com/jiuka/puppet-git.git':
    path => '/tmp/puppet-git';
}

# Clone repo as bare
git { 'clone same repo again':
    source =>'git://github.com/jiuka/puppet-git.git',
    path   => '/tmp/puppet-git.git',
    bare   => true;
}
