# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as subl with context %}


{%- if subl.lookup.pkg.manager not in ['apt', 'dnf', 'yum', 'zypper'] %}
{%-   if salt['state.sls_exists'](slsdotpath ~ '.' ~ subl.lookup.pkg.manager ~ '.clean') %}

include:
  - {{ slsdotpath ~ '.' ~ subl.lookup.pkg.manager ~ '.clean' }}
{%-   endif %}

{%- else %}


{%-   for reponame, repodata in subl.lookup.pkg.repos.items() %}

Sublime Text {{ reponame }} repository is absent:
  pkgrepo.absent:
{%-     for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-       if conf in repodata %}
    - {{ conf }}: {{ repodata[conf] }}
{%-       endif %}
{%-     endfor %}
{%-   endfor %}
{%- endif %}
