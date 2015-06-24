{%- set p  = salt['pillar.get']('geowave', {}) %}
{%- set pc = p.get('config', {}) %}
{%- set g  = salt['grains.get']('geowave', {}) %}
{%- set gc = g.get('config', {}) %}

{%- set targeting_method = salt['grains.get']('geowave:targeting_method', salt['pillar.get']('geowave:targeting_method', 'grain')) %}
{%- set namenode_target  = g.get('namenode_target', p.get('namenode_target', 'roles:accumulo_master')) %}
{%- set appserver_target = g.get('appserver_target', p.get('appserver_target', 'roles:geoserver_host')) %}
{%- set is_namenode  = salt['match.' ~ targeting_method](namenode_target) %}
{%- set is_appserver = salt['match.' ~ targeting_method](appserver_target) %}

{%- set geowave_version    = '0.8.8-201506221313' %}
{%- set accumulo_classpath = 'geowave/0.8.8-cdh5' %}
{%- set name_node_port     = '8020' %}
#TODO: use the ones set in the actual accumulo formula
{%- set accumulo_user      = 'root' %}
{%- set accumulo_pswd      = 'root' %}

{%- set from_pkg_repo = false %}
{%- set repo_pkg_url  = 'http://s3.amazonaws.com/geowave-rpms/release/noarch/geowave-repo-1.0-3.noarch.rpm' %}
{%- set core_pkg      = 'geowave-core' %}
{%- set accumulo_pkg  = 'geowave-0.8.8-cdh5-accumulo' %}
{%- set geoserver_pkg = 'geowave-0.8.8-cdh5-jetty' %}
{%- set tools_pkg     = 'geowave-0.8.8-cdh5-tools' %}

{%- set core_pkg_url      = 'http://s3.amazonaws.com/geowave-rpms/dev/noarch/geowave-core.201506221313.noarch.rpm' %}
{%- set accumulo_pkg_url  = 'http://s3.amazonaws.com/geowave-rpms/dev/noarch/geowave-0.8.8-cdh5-accumulo.201506221313.noarch.rpm' %}
{%- set geoserver_pkg_url = 'http://s3.amazonaws.com/geowave-rpms/dev/noarch/geowave-0.8.8-cdh5-jetty.201506221313.noarch.rpm' %}
{%- set tools_pkg_url     = 'http://s3.amazonaws.com/geowave-rpms/dev/noarch/geowave-0.8.8-cdh5-tools.201506221313.noarch.rpm' %}

{%- set geowave = {} %}
{%- do geowave.update({ 
                        'is_namenode'        : is_namenode,
                        'is_appserver'       : is_appserver,
                        'geowave_version'    : geowave_version,
                        'accumulo_classpath' : accumulo_classpath,
                        'name_node_port'     : name_node_port,
                        'accumulo_user'      : accumulo_user,
                        'accumulo_pswd'      : accumulo_pswd,
                        'from_pkg_repo'      : from_pkg_repo,
                        'repo_pkg_url'       : repo_pkg_url,
                        'core_pkg'           : core_pkg,
                        'accumulo_pkg'       : accumulo_pkg,
                        'geoserver_pkg'      : geoserver_pkg,
                        'tools_pkg'          : tools_pkg,
                        'core_pkg_url'       : core_pkg_url,
                        'accumulo_pkg_url'   : accumulo_pkg_url,
                        'geoserver_pkg_url'  : geoserver_pkg_url,
                        'tools_pkg_url'      : tools_pkg_url
                      }) %}