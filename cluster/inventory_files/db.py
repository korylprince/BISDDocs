# -*- coding: utf-8 -*-

db = DAL('mysql://<user>:<password>@<server>/<database name>', migrate=False)

## (optional) optimize handling of static files
response.optimize_css = 'concat,minify,inline'
response.optimize_js = 'concat,minify,inline'

db.define_table('devices',Field('Inventory_Number','string',unique=True),Field('Serial_Number','string'),\
Field('Campus','string'),Field('User','string'),Field('Vendor','string'),Field('Room','string'),\
Field('Network','boolean'),Field('Computer_Present','boolean'),Field('Memo','text'))

# Authentication - http://www.web2pyslices.com/slice/show/1468/how-to-set-up-web2py-ldap-with-windows-active-directory
from gluon.tools import Auth
auth = Auth(db, hmac_key=Auth.get_or_create_key())
auth.define_tables(username=True)
auth.settings.create_user_groups=False
# all we need is login
auth.settings.actions_disabled=['register','change_password','request_reset_password','retrieve_username','profile']
# you don't have to remember me
auth.settings.remember_me_form = False
# ldap authentication and not save password on web2py
from gluon.contrib.login_methods.ldap_auth import ldap_auth
auth.settings.login_methods = [ldap_auth(mode='ad',
allowed_groups = ['Domain Group1','Domain Group2'],
bind_dn = 'CN=Admin User,OU=baseou,DC=example,DC=com',
bind_pw = 'pass',
group_dn = 'OU=Domain Groups,OU=baseou,DC=example,DC=com',
group_name_attrib = 'cn',
group_member_attrib = 'member',
group_filterstr = 'objectClass=Group',
server='server.example.com,
base_dn='OU=baseou,DC=example,DC=com')]

# set Title for all pages
response.title = 'Change Me!'
