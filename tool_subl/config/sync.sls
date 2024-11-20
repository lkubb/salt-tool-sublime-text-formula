# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as subl with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}


{%- for user in subl.users | selectattr("dotconfig", "defined") | selectattr("dotconfig") %}
{%-   set dotconfig = user.dotconfig if user.dotconfig is mapping else {} %}

Sublime Text configuration is synced for user '{{ user.name }}':
  file.recurse:
    # conffile in this case is actually the Packages/User directory
    - name: {{ user["_subl"].conffile }}
    - source: {{ files_switch(
                    ["sublime-text"],
                    lookup="Sublime Text configuration is synced for user '{}'".format(user.name),
                    config=subl,
                    path_prefix="dotconfig",
                    files_dir="",
                    custom_data={"users": [user.name]},
                 )
              }}
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
{%-   if dotconfig.get("file_mode") %}
    - file_mode: '{{ dotconfig.file_mode }}'
{%-   endif %}
    - dir_mode: '{{ dotconfig.get("dir_mode", "0700") }}'
    - clean: {{ dotconfig.get("clean", false) | to_bool }}
    - makedirs: true
{%- endfor %}
