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
