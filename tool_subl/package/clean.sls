# vim: ft=sls

{#-
    Removes the Sublime Text package.
    Has a dependency on `tool_subl.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as subl with context %}

include:
  - {{ sls_config_clean }}
  - {{ slsdotpath }}.repo.clean


Sublime Text is removed:
  pkg.removed:
    - name: {{ subl.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
