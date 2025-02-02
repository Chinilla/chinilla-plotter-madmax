# Compiler image
# -------------------------------------------------------------------------------------------------
FROM alpine:3.16.2 AS compiler

WORKDIR /root

RUN apk --no-cache add \
    gcc \
    g++ \
    build-base \
    cmake \
    gmp-dev \
    git

COPY . .
RUN /bin/sh ./make_devel.sh

# Runtime image
# -------------------------------------------------------------------------------------------------
FROM alpine:3.16.2 AS runtime

WORKDIR /root

RUN apk --no-cache add \
    gmp-dev \
    libsodium-dev

COPY --from=compiler /root/build /usr/lib/chinilla-plotter
RUN ln -s /usr/lib/chinilla-plotter/chinilla_plot /usr/bin/chinilla_plot

ENTRYPOINT ["/usr/bin/chinilla_plot"]
