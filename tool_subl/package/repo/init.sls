# vim: ft=sls

{#-
    This state will install the configured Sublime Text repository.
    This works for apt/dnf/yum/zypper-based distributions only by default.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as subl with context %}

include:
{%- if subl.lookup.pkg.manager in ["apt", "dnf", "yum", "zypper"] %}
  - {{ slsdotpath }}.install
{%- elif salt["state.sls_exists"](slsdotpath ~ "." ~ subl.lookup.pkg.manager) %}
  - {{ slsdotpath }}.{{ subl.lookup.pkg.manager }}
{%- else %}
  []
{%- endif %}
