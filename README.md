# API Docs for Tito

Forked from [Slatedocs](https://github.com/slatedocs/slate), this app provides the documentation at https://ti.to/docs/api. It runs on Heroku and is proxied to from Kubernetes.

## Install with Docker

Build the Docker image:

```
docker build . -t slatedocs/slate
```

## Run in Docker

```
docker run --rm --name slate -p 4567:4567 -v $(pwd)/source:/srv/slate/source slatedocs/slate serve
```

If you change `DocBuilder` or any of the `data` then you need to build the image again (which is quick):

```
docker build . -t slatedocs/slate
```

## Generating the data

You can generate the data for `3.0` and `3.1` using dashboard:

```
rails write_docs
```

That will write the files to `api-docs`. From this project, you can then copy them over:

```
rm -Rf data/3.*; mv ../dashboard-tito/api-docs/3.* data/
```

(don't forget to rebuild the Docker image afterwards).

## DocBuilder

This is a helper file that allows us to DRY up our documentation.
