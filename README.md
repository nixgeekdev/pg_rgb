# pg_rgb 0.0.1

This library contains a single PostgreSQL extension, a RGB color data type, along with convenience 
functions for constructing, converting, and indexing RGB colors.

To build it, just do this:

```bash
    make
    make installcheck
    make install
```

### Dependencies:

The RGB data type has no dependencies other than PostgreSQL.

### Requirements:

- PostgreSQL 13 or higher installed with development headers (`postgresql-server-dev-13` or equivalent).
- `pg_config` available in your PATH.
- GCC and GNU Make

### Development:

The recommended development workflow is to start the provided database container using docker compose:

```bash
    docker compose up db
```

And then access the container via shell:

```bash
    docker exec -it <ID> /bin/bash
```

The container already has all dependencies and a GNU build toolchain installed. 
The container mounts this source directory at `/app`. A development convenience 
script is available in the `scripts` directory and is called `compose.sh`.

### Documentation:

For more information, please read the [documentation](./doc/rgb.md).