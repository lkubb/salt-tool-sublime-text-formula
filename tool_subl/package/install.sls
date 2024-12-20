# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as subl with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ slsdotpath }}.repo


Sublime Text is installed:
  pkg.installed:
    - name: {{ subl.lookup.pkg.name }}
{%- if "Darwin" != grains["kernel"] %}
    - version: {{ subl.get("version") or "latest" }}
    {#- do not specify alternative return value to be able to unset default version #}
{%- endif %}

{%- for user in subl.users %}

Package Control is also installed for user '{{ user.name }}' (to make Sublime whole again):
  file.managed:
    - name: {{ user._subl.datadir | path_join("Installed Packages", "Package Control.sublime-package") }}
    - source: {{ (
                    files_switch(
                      ["Package Control.sublime-package"],
                      lookup="Package Control is also installed for user '{}' (to make Sublime whole again)".format(user.name),
                      config=subl,
                      custom_data={"users": [user.name]},
                    ) | load_json
                    + ["https://packagecontrol.io/Package%20Control.sublime-package"]
                 ) | json
              }}
    # currently, does not change too often
    - source_hash: 817937144c34c84c88cd43b85318b2656f9c3fac02f8f72cbc18360b2c26d139 # was at the time of writing, might change
    # It updates itself. The distributed version is not the latest release for some reason.
    - replace: false
    - makedirs: true
    - mode: '0644'
    - user: {{ user.name }}
    - group: {{ user.group }}
    - require:
      - Sublime Text is installed
    - require_in:
      - Sublime Text setup is completed
{%- endfor %}

Sublime Text setup is completed:
  test.nop:
    - name: Hooray, Sublime Text setup has finished.
    - require:
      - pkg: {{ subl.lookup.pkg.name }}
