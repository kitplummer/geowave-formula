{%- set p  = salt['pillar.get']('geowave', {}) %}
{%- set pc = p.get('config', {}) %}
{%- set g  = salt['grains.get']('geowave', {}) %}
{%- set gc = g.get('config', {}) %}

{%- set targeting_method = salt['grains.get']('geowave:targeting_method', salt['pillar.get']('geowave:targeting_method', 'grain')) %}
{%- set namenode_target  = g.get('namenode_target', p.get('namenode_target', 'roles:accumulo_master')) %}
{%- set appserver_target = g.get('appserver_target', p.get('appserver_target', 'roles:geoserver_host')) %}
{%- set is_namenode  = salt['match.' ~ targeting_method](namenode_target) %}
{%- set is_appserver = salt['match.' ~ targeting_method](appserver_target) %}

#{%- set geowave_version    = '0.8.7-201505292121' %}
{%- set geowave_version    = '0.8.5-201504101854' %}
#{%- set accumulo_classpath = 'geowave/0.8.7-cdh5' %}
{%- set accumulo_classpath = 'geowave' %}
{%- set name_node_port     = '8020' %}
#TODO: use the ones set in the actual accumulo formula
{%- set accumulo_user      = 'root' %}
{%- set accumulo_pswd      = 'root' %}

{%- set accumulo_pkg  = 'geowave-cdh5-accumulo' %}
{%- set geoserver_pkg = 'geowave-cdh5-jetty' %}
{%- set tools_pkg     = 'geowave-cdh5-ingest' %}
{%- set repo_pkg_url  = 'http://s3.amazonaws.com/geowave-rpms/release/noarch/geowave-repo-1.0-3.noarch.rpm' %}

{%- set geowave = {} %}
{%- do geowave.update({ 
                        'is_namenode'        : is_namenode,
                        'is_appserver'       : is_appserver,
                        'geowave_version'    : geowave_version,
                        'accumulo_classpath' : accumulo_classpath,
                        'name_node_port'     : name_node_port,
                        'accumulo_user'      : accumulo_user,
                        'accumulo_pswd'      : accumulo_pswd,
                        'accumulo_pkg'       : accumulo_pkg,
                        'geoserver_pkg'      : geoserver_pkg,
                        'tools_pkg'          : tools_pkg,
                        'repo_pkg_url'       : repo_pkg_url,
                      }) %}