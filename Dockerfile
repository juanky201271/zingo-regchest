FROM zingodevops/ci-build:002

WORKDIR /usr/src
RUN git clone https://github.com/zingolabs/zingo-regchest.git \
    && cd zingo-regchest \
    && git checkout f6428447d915e22d40b6f7c5823bc4ed81b1bc09
    WORKDIR /usr/src/zingo-regchest/regchest
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./regtest/bin/
RUN cargo build --release

ENTRYPOINT ["cargo", "run", "--release"]

