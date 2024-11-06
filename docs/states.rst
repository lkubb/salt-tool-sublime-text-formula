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



