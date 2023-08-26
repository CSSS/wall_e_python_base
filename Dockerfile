FROM python:3.8.5-alpine

ARG CONTAINER_HOME_DIR

ENV CONTAINER_HOME_DIR=$CONTAINER_HOME_DIR

WORKDIR $CONTAINER_HOME_DIR


# pg_config is required to build psycopg2 from source.  Please add the directory
#    containing pg_config to the $PATH or specify the full executable path with the
#    option:

RUN apk add postgresql-dev

# * The following required packages can not be built:
# * freetype, png
RUN apk add freetype-dev


# Traceback (most recent call last):
#   File "/tmp/easy_install-2ga6txzl/numpy-1.18.1/tools/cythonize.py", line 61, in process_pyx
#     from Cython.Compiler.Version import version as cython_version
# ImportError: No module named 'Cython'
RUN pip install --no-cache-dir Cython


# RuntimeError: Broken toolchain: cannot link a simple C program
RUN apk add --update alpine-sdk

# The headers or library files could not be found for jpeg,
#     a required dependency when compiling Pillow from source.
RUN apk add jpeg-dev

COPY layer-1-requirements.txt .
RUN pip install --no-cache-dir -r layer-1-requirements.txt
RUN rm layer-1-requirements.txt

COPY layer-2-requirements.txt .

RUN apk add --update libffi-dev && \
    pip install --no-cache-dir -r layer-2-requirements.txt &&  \
    apk --update add postgresql-client
RUN rm layer-2-requirements.txt