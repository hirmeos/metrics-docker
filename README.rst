HIRMEOS Metrics Docker
======================

This is a docker-compose setup and databases to run all HIRMEOS Work Package 6
services. It assumes the services listed below have been set up in the current
directory.

The following env files will need to be set for the containers

.. code-block:: bash

    db.env
    hirmeos-altmetrics.env
    hirmeos-crossref-uri-import.env
    hirmeos-metrics-api.env
    hirmeos-metrics-broker.env
    hirmeos-tokens.env
    hirmeos-translator.env

After this, docker-compose can be run with

.. code-block:: bash

    $ docker-compose up


Setup - more detailed
---------------------

The following is written as a set of steps

Set up values in the databases
..............................

Since the different databases are all set up and populated in the `postgres_db`
service, it can be easier to set up certain values before starting the service.
Particularly the metrics-api database.

In the `db` directory, there are subdirectories for each database. Each contain
SQL files for the database schema, as well as values to pre-populate the
different tables with.

For the metrics-api (`db/sql/hirmeos_metrics_api/`), it is worth adding to the
following files:

 - 50-sources.sql
 - 60-namespaces.sql
 - 70-uploaders.sql
 - 80-namespace_uploaders.sql
 - 90-measures.sql

Use the values already in these files as a guide.


Set up token authentication
...........................

First, create the `.env` files specified above.

Then run docker-compose:

.. code-block:: bash

    $ docker-compose up


*Note: Please see the `Notes on Services` section below if the database does
not seem to be set up properly.*

Use the instructions specified in the tokens project
(https://github.com/hirmeos/tokens_api) to create an account in the tokens api.
Use smae the email and password used in the `.env` files mentioned as
`verified_tokens_user@account.com` and `very_secure_tokens_password` in the
example files.


Send data to the translator
...........................

For any given book, please send as many identifiers as possible. ISBNs are
required when using the `crossref_uri_import` tool, and URLs are needed by the
google analytics driver.

The code below shows an example of sending ISBN, doi and URL data for a book.
Note the call to the tokens api.

.. code-block:: python

    #!/usr/bin/python2
    import json
    import requests


    tokens_url = "http://localhost:8001/tokens"
    translator_url = "http://localhost:8002/works"

    credentials = {
        'email': 'verified_tokens_user@account.com',
        'password': 'very_secure_tokens_password'
    }

    # First retrieve token before making requests tot he translator
    response = requests.post(tokens_url, json=credentials)
    token = json.loads(response.content)['data'][0]['token']

    header = {"Authorization": "Bearer " + token}

    data = {  # Book data to send to the translator
        'title': u'Animal (De)liberation',
        'type': 'monograph',
        'uri': [
            {'URI': 'urn:isbn:978-1-909188-84-6', 'canonical': False},
            {'URI': 'urn:isbn:978-1-909188-83-9', 'canonical': False},
            {'URI': 'urn:isbn:978-1-909188-85-3', 'canonical': False},
            {'URI': 'urn:isbn:978-1-909188-87-7', 'canonical': False},
            {'URI': 'urn:isbn:978-1-909188-86-0', 'canonical': False},
            {'URI': 'https://www.ubiquitypress.com/site/books/10.5334/bay'},
            {'URI': 'info:doi:10.5334/bay', 'canonical': True}
        ]
    }

    requests.post(translator_url, json=data, headers=header)


Services are ready to be used
.............................

You can now run the `crossref_uri_import` tool, as well as the google analytics
driver.

Notes on Services:
------------------

postgres_db
...........

This has been adapted from the hirmeos-metrics-api project (listed below).
Where necessary, this container will host all databases used by the
different wp6 services.

The first time this container is started it should create the databases
specified in `db.env` (variable POSTGRES_MULTIPLE_DATABASES), and populate
these with the content in the sql folder.

If the tables are not created, you may need run this manually using docker exec

.. code-block:: bash

    $ docker exec -it postgres_db bash
    $ cd docker-entrypoint-initdb.d/
    $ ./create-multiple-databases.sh
    $ ./create-database-extensions.sh
    $ exit

------------

The following WP6 services are also included so far in the docker-compose config
file:

hirmeos-tokens
..............

https://github.com/hirmeos/tokens_api

The database for this is included in the `db/` directory

**Impotant**:
Please follow the instructions listed at https://github.com/hirmeos/tokens_api
to register an email and password with the token api, since many of the
services require this to be set up.


hirmeos-translator
..................

https://github.com/hirmeos/identifier_translation_service

The database for this is included in the `db/` directory


hirmeos-metrics-broker
......................

https://github.com/hirmeos/metrics_broker

This also includes `metrics_broker_web`


hirmeos-crossref-uri-import
...........................

https://github.com/hirmeos/crossref_uri_import

* Not implemented yet; still needs to be set up to run as a cron-job


hirmeos-metrics-api
...................

https://github.com/hirmeos/metrics-api

The database for this is included in the `db/` directory


hirmeos-altmetrics
..................

https://github.com/hirmeos/metrics
