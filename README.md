Puppet module for GIT
=====================

This module allows you to manage and configure git repositories.

Basic usage
-----------

Create a new repo
```puppet
git { '/var/git/puppet.git':
  bare => true;
}
```

Clone a remote repository
```puppet
git { 'git://github.com/nine/puppet-git':
  ensure => present,
  path   => '/var/git/puppet-git';
}
```

Dependencies
------------

Depends on the availability of the git binary.

Notes
-----

Contributors
------------

 * Marius Rieder <marius.rieder@nine.ch>

Copyright and License
---------------------

Copyright (C) 2012 [Nine Internet Solutions AG](https://www.nine.ch/)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
