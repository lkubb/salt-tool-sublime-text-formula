"""
Managing Sublime Text packages with Package Control
======================================================

This module needs the ``json5`` library, which **does not come with
Salt by default**.
"""

import logging

import salt.utils.platform

log = logging.getLogger(__name__)

__virtualname__ = "subl"


def __virtual__():
    """
    Works on Linux, MacOS and Windows (should, at least)
    """
    if (
        salt.utils.platform.is_darwin()
        or salt.utils.platform.is_linux()
        or salt.utils.platform.is_windows()
    ):
        return __virtualname__
    return False


def pkg_installed(name, user):
    """
    Make sure Sublime Text has a package installed. Needs Package Control.

    name
        The name of the package to install, if not installed already

    user
        The username to install the package for

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if __salt__["subl.is_package_installed"](name, user):
            ret["comment"] = "Package is already installed."
        elif __opts__["test"]:
            ret[
                "comment"
            ] = "Package {} would have been installed by Package Control once user '{}' started Sublime Text.".format(
                name, user
            )
            ret["changes"] = {"installed": name}
        elif __salt__["subl.install_package"](name, user):
            ret[
                "comment"
            ] = "Package {} will be installed by Package Control once user '{}' starts Sublime Text.".format(
                name, user
            )
            ret["changes"] = {"installed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong in configuring Package Control."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def pkg_absent(name, user):
    """
    Make sure Sublime Text does not have a package installed. Needs Package Control.

    name
        The name of the package to remove, if present

    user
        The username to remove the package for

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if not __salt__["subl.is_package_installed"](name, user):
            ret["comment"] = "Package is already absent."
        elif __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = "Package {} would have been removed by Package Control once user '{}' started Sublime Text.".format(
                name, user
            )
            ret["changes"] = {"removed": name}
        if __salt__["subl.remove_package"](name, user):
            ret[
                "comment"
            ] = "Package {} will be removed by Package Control once user '{}' starts Sublime Text.".format(
                name, user
            )
            ret["changes"] = {"removed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong in configuring Package Control."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret
