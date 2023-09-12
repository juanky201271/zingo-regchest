FROM zingodevops/ci-build:001

# Copy rust into docker image and build (to be replaced with git clone)
RUN mkdir /usr/src/regchest
WORKDIR /usr/src/regchest
COPY regchest/Cargo.lock ./Cargo.lock
COPY regchest/Cargo.toml ./Cargo.toml
COPY regchest/regtest ./regtest
COPY regchest/src ./src
RUN rm -f ./regtest/bin/*
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./regtest/bin/
RUN cargo build --release

# EXPOSE 20000
ENTRYPOINT ["cargo", "run", "--release"]

