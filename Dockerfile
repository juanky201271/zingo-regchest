FROM zingodevops/ci-build:002

WORKDIR /usr/src
RUN git clone https://github.com/zingolabs/zingo-regchest.git \
    && cd zingo-regchest \
    && git checkout 338a798920ae7242d200fe1e717e5b21e5b2f6de
    WORKDIR /usr/src/zingo-regchest/regchest
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./regtest/bin/
RUN cargo build --release

ENTRYPOINT ["cargo", "run", "--release"]

