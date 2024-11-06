# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as subl with context %}


{%- if grains["os"] in ["Debian", "Ubuntu"] %}

Ensure Sublime Text APT repository can be managed:
  pkg.installed:
    - pkgs:
      - python-apt                    # required by Salt
      - apt-transport-https           # needs to support https repositories
{%-   if "Ubuntu" == grains["os"] %}
      - python-software-properties    # to better support PPA repositories
{%-   endif %}
{%- endif %}

{%- if subl.lookup.pkg.manager in ["yum", "dnf", "zypper"] and "amd64" != grains["cpuarch"] %}

Sublime Text RPM repository does not exist for this CPU architecture:
  test.fail_without_changes:
    - name: There is no official RPM repository for this CPU architecture.
{%- else %}

{%-   for reponame in subl.lookup.pkg.enablerepo %}

Sublime Text {{ reponame }} repository is available:
  pkgrepo.managed:
{%-     for conf, val in subl.lookup.pkg.repos[reponame].items() %}
    - {{ conf }}: {{ val }}
{%-     endfor %}
{%-     if subl.lookup.pkg.manager in ["dnf", "yum", "zypper"] %}
    - enabled: 1
{%-     endif %}
    - require_in:
      - Sublime Text is installed
{%-   endfor %}

{%-   for reponame, repodata in subl.lookup.pkg.repos.items() %}

{%-     if reponame not in subl.lookup.pkg.enablerepo %}
Sublime Text {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-       for conf in ["name", "ppa", "ppa_auth", "keyid", "keyid_ppa", "copr"] %}
{%-         if conf in repodata %}
    - {{ conf }}: {{ repodata[conf] }}
{%-         endif %}
{%-       endfor %}
    - require_in:
      - Sublime Text is installed
{%-     endif %}
{%-   endfor %}
{%- endif %}
