"""
Manage Sublime Text packages with Package Control

"""

import json
import json5
import logging
import os.path
import shutil

import salt.exceptions
import salt.utils.platform


log = logging.getLogger(__name__)

__virtualname__ = "subl"


def __virtual__():
    """
    Works on Linux, MacOS and Windows (should, at least)
    """
    if salt.utils.platform.is_darwin() or salt.utils.platform.is_linux() or salt.utils.platform.is_windows():
        return __virtualname__
    return False


def is_package_installed(name, user):
    return name in _load_current(user)['installed_packages']


def install_package(name, user):
    """
    Make Package Control install a package on the next startup. Needs Package Control installed.

    CLI Example:

    .. code-block:: bash

        salt '*' subl.pkg_installed SublimeLinter elliot

    name
        The name of the package to install

    user
        The username to install the package for

    """

    current = _load_current(user)

    if name in current['installed_packages']:
        return False

    current['installed_packages'].append(name)

    return _dump_config(user, current)


def remove_package(name, user):
    """
    Make Package Control remove a package on the next startup. Needs Package Control installed.

    CLI Example:

    .. code-block:: bash

        salt '*' subl.pkg_installed SublimeLinter elliot

    name
        The name of the package to install

    user
        The username to install the package for

    """

    current = _load_current(user)

    if name not in current['installed_packages']:
        return False

    current['installed_packages'].remove(name)

    return _dump_config(user, current)


def _config_path(user):
    path = ''
    if salt.utils.platform.is_darwin():
        path = __salt__['user.info'](user)['home'] + '/Library/Application Support/Sublime Text'
    if salt.utils.platform.is_linux():
        path = __salt__['user.info'](user)['home'] + '/.config/sublime-text'
    if salt.utils.platform.is_windows():
        path = __salt__['user.info'](user)['home'] + '/AppData/Roaming/Sublime Text'

    if os.path.exists(path):
        return path

    raise salt.exceptions.CommandExecutionError('Could not find Sublime Text configuration directory.')


def _settings_path(user):
    return _config_path(user) + '/Packages/User/Package Control.sublime-settings'


def _load_current(user):
    ret = {'installed_packages': []}

    settings_path = _settings_path(user)

    log.debug("Looking for Package Control settings file at '{}'".format(settings_path))

    if os.path.exists(settings_path):
        with open(settings_path, 'r') as f:
            ret = json5.load(f) # the file is supposed to be json, but uses trailing commas. yaml is a superset and should work - it does not, the file uses tabs to indent. lol
            log.debug("Loaded Package Control settings from '{}'. Content: \n{}".format(settings_path, ret))

    return ret


def _dump_config(user, config):
    settings_path = _settings_path(user)
    with open(settings_path, 'w') as f:
        json.dump(config, f, indent=4, sort_keys=True)
    shutil.chown(settings_path, user=user)
    return True # erm yeah, json.dump and shutil.chown don't seem to return success
