import os
basedir = os.path.abspath(os.path.abspath(os.path.dirname(__file__)))

### BASIC APP CONFIG
SALT = '$2b$12$yLUMTIfl21FKJQpTkRQXCu'
SECRET_KEY = 'e951e5a1f4b94151b360f47edf596dd2'
BIND_ADDRESS = '0.0.0.0'
PORT = 9191
HSTS_ENABLED = False
OFFLINE_MODE = False
FILESYSTEM_SESSIONS_ENABLED = False

### DATABASE CONFIG
SQLA_DB_USER = 'wsadmin'
SQLA_DB_PASSWORD = 'xast890567??'
SQLA_DB_HOST = '190.168.0.14'
SQLA_DB_NAME = 'db_powerdnsadmin'
SQLALCHEMY_TRACK_MODIFICATIONS = True

### DATABASE - MySQL
SQLALCHEMY_DATABASE_URI = 'mysql://'+SQLA_DB_USER+':'+SQLA_DB_PASSWORD+'@'+SQLA_DB_HOST+'/'+SQLA_DB_NAME

### DATABASE - SQLite
# SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'pdns.db')

# SAML Authnetication
SAML_ENABLED = False
SAML_ASSERTION_ENCRYPTED = True
