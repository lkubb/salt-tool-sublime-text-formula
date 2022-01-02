{#- There are currently no arm64 or other repos -#}
{%- if 'amd64' == grains['cpuarch'] %}
Sublime Text stable repository is available:
  pkgrepo.managed:
    - humanname: sublime-text
    - name: Sublime Text - x86_64 - Stable
    - baseurl: https://download.sublimetext.com/rpm/stable/x86_64
    - key_url: https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    - gpgcheck: 1
{%- else %}
Sublime Text RPM repository does not exist for this CPU architecture:
  test.fail_without_changes:
    - name: There is no official RPM repository for this CPU architecture.
{%- endif %}
