# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as subl with context %}


{%- for user in subl.users | selectattr('subl.plugins', 'defined') %}

  {%- for plugin in user.subl.plugins.get('wanted', []) %}

Sublime Package Control makes sure {{ plugin }} is absent for user {{ user.name }}:
  subl.pkg_absent:
    - name: {{ plugin }}
    - user: {{ user.name }}
  {%- endfor %}
{%- endfor %}
