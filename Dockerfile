FROM zingodevops/ci-build:001

# Copy rust into docker image and build (to be replaced with git clone)
RUN mkdir /usr/src/zingo-regchest
WORKDIR /usr/src/zingo-regchest
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
COPY ./regtest ./regtest
COPY ./src ./src
RUN rm -f ./regtest/bin/*
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./regtest/bin/
RUN cargo build

EXPOSE 20000
ENTRYPOINT ["cargo", "run"]

