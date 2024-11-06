# vim: ft=sls

{#-
    Removes the configuration of the Sublime Text package.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as subl with context %}


{%- for user in subl.users %}

Sublime Text config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_subl"].confdir }}
{%- endfor %}
