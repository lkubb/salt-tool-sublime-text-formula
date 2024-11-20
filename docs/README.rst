.. _readme:

Sublime Text Formula
====================

Manages Sublime Text, Package Control and plugins in the user environment.

.. contents:: **Table of Contents**
   :depth: 1

Usage
-----
Applying ``tool_subl`` will make sure Sublime Text is configured as specified.

Plugins
~~~~~~~
To be able to manage plugins, you will need the ``json5`` library for the salt minion since the execution module relies on it.

Execution and state module
~~~~~~~~~~~~~~~~~~~~~~~~~~
This formula provides a custom execution module and state to manage packages installed with Sublime Text. The functions are self-explanatory, please see the source code or the rendered docs at :ref:`em_subl` and :ref:`sm_subl`.

Configuration
-------------

This formula
~~~~~~~~~~~~
The general configuration structure is in line with all other formulae from the `tool` suite, for details see :ref:`toolsuite`. An example pillar is provided, see :ref:`pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in :ref:`map.jinja`.

User-specific
^^^^^^^^^^^^^
The following shows an example of ``tool_subl`` per-user configuration. If provided by pillar, namespace it to ``tool_global:users`` and/or ``tool_subl:users``. For the ``parameters`` YAML file variant, it needs to be nested under a ``values`` parent key. The YAML files are expected to be found in

1. ``salt://tool_subl/parameters/<grain>/<value>.yaml`` or
2. ``salt://tool_global/parameters/<grain>/<value>.yaml``.

.. code-block:: yaml

  user:

      # Force the usage of XDG directories for this user.
    xdg: true

      # Sync this user's config from a dotfiles repo.
      # The available paths and their priority can be found in the
      # rendered `config/sync.sls` file (currently, @TODO docs).
      # Overview in descending priority:
      # salt://dotconfig/<minion_id>/<user>/sublime-text
      # salt://dotconfig/<minion_id>/sublime-text
      # salt://dotconfig/<os_family>/<user>/sublime-text
      # salt://dotconfig/<os_family>/sublime-text
      # salt://dotconfig/default/<user>/sublime-text
      # salt://dotconfig/default/sublime-text
    dotconfig:              # can be bool or mapping
      file_mode: '0600'     # default: keep destination or salt umask (new)
      dir_mode: '0700'      # default: 0700
      clean: false          # delete files in target. default: false

      # Persist environment variables used by this formula for this
      # user to this file (will be appended to a file relative to $HOME)
    persistenv: '.config/zsh/zshenv'

      # Add runcom hooks specific to this formula to this file
      # for this user (will be appended to a file relative to $HOME)
    rchook: '.config/zsh/zshrc'

      # This user's configuration for this formula. Will be overridden by
      # user-specific configuration in `tool_subl:users`.
      # Set this to `false` to disable configuration for this user.
    subl:
        # manage plugins installed by Package Control
      plugins:
          # make sure those plugins are not installed
        absent:
          - Emmet
          # make sure those plugins are installed
        wanted:
          - Jinja2
          - SaltStack-related syntax highlighting and snippets
          - SublimeLinter
          - SublimeLinter-contrib-salt-lint

Formula-specific
^^^^^^^^^^^^^^^^

.. code-block:: yaml

  tool_subl:

      # Specify an explicit version (works on most Linux distributions) or
      # keep the packages updated to their latest version on subsequent runs
      # by leaving version empty or setting it to 'latest'
      # (again for Linux, brew does that anyways).
    version: latest

      # Default formula configuration for all users.
    defaults:
      plugins: default value for all users

Dotfiles
~~~~~~~~
``tool_subl.config.sync`` will recursively apply templates from

* ``salt://dotconfig/<minion_id>/<user>/sublime-text``
* ``salt://dotconfig/<minion_id>/sublime-text``
* ``salt://dotconfig/<os_family>/<user>/sublime-text``
* ``salt://dotconfig/<os_family>/sublime-text``
* ``salt://dotconfig/default/<user>/sublime-text``
* ``salt://dotconfig/default/sublime-text``

to the user's config dir for every user that has it enabled (see ``user.dotconfig``). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).

The URL list above is in descending priority. This means user-specific configuration from wider scopes will be overridden by more system-specific general configuration.


Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_subl``
~~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_subl.package``
~~~~~~~~~~~~~~~~~~~~~
Installs the Sublime Text package only.


``tool_subl.package.repo``
~~~~~~~~~~~~~~~~~~~~~~~~~~
This state will install the configured Sublime Text repository.
This works for apt/dnf/yum/zypper-based distributions only by default.


``tool_subl.xdg``
~~~~~~~~~~~~~~~~~
Ensures Sublime Text adheres to the XDG spec
as best as possible for all managed users.
Has a dependency on `tool_subl.package`_.


``tool_subl.config``
~~~~~~~~~~~~~~~~~~~~
Manages the Sublime Text package configuration by

* recursively syncing from a dotfiles repo

Has a dependency on `tool_subl.package`_.


``tool_subl.plugins``
~~~~~~~~~~~~~~~~~~~~~



``tool_subl.clean``
~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_subl`` meta-state
in reverse order.


``tool_subl.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the Sublime Text package.
Has a dependency on `tool_subl.config.clean`_.


``tool_subl.package.repo.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This state will remove the configured Sublime Text repository.
This works for apt/dnf/yum/zypper-based distributions only by default.


``tool_subl.xdg.clean``
~~~~~~~~~~~~~~~~~~~~~~~



``tool_subl.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the configuration of the Sublime Text package.


``tool_subl.plugins.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~




Development
-----------

Contributing to this repo
~~~~~~~~~~~~~~~~~~~~~~~~~

Commit messages
^^^^^^^^^^^^^^^

Commit message formatting is significant.

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``.

.. code-block:: console

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.

Todo
----
* symlink ``subl`` on non-MacOS systems
