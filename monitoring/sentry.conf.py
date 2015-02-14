DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'sentry',
        'USER': 'sentry'
    }
}

SENTRY_URL_PREFIX = 'http://sentry.habhub.org'

# NB: These settings probably not used since we run gunicorn ourselves
SENTRY_WEB_HOST = '127.0.0.1'
SENTRY_WEB_PORT = 9000
SENTRY_WEB_OPTIONS = {
    'workers': 2,
    'secure_scheme_headers': {'X-FORWARDED-PROTO': 'https'}
}

SENTRY_REDIS_OPTIONS = {
    'hosts': {
        0: {
            'host': '127.0.0.1',
            'port': 6379
        }
    }
}

EMAIL_HOST = 'localhost'
EMAIL_HOST_PASSWORD = ''
EMAIL_HOST_USER = ''
EMAIL_PORT = 25
EMAIL_USE_TLS = False

# TODO: GitHub integration for auth
SENTRY_ALLOW_REGISTRATION = False
