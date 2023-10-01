FROM zingodevops/ci-build:002

WORKDIR /usr/src
RUN git clone https://github.com/zingolabs/zingo-regchest.git \
    && cd zingo-regchest \
    && git checkout d2521853f81b18ecd1ee10b732c4e95a57851534
    WORKDIR /usr/src/zingo-regchest/regchest
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./regtest/bin/
RUN cargo build --release

ENTRYPOINT ["cargo", "run", "--release"]

