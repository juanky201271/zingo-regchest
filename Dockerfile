FROM zingodevops/ci-build:010 AS builder

WORKDIR /usr/src
RUN git clone https://github.com/zingolabs/zingo-regchest.git \
    && cd zingo-regchest \
    && git checkout d2c75687165ab7be241aa8df0097c8689f2f9320

WORKDIR /usr/src/zingo-regchest/regchest
RUN cargo build --release

FROM zingodevops/ci-build:010 AS runtime

COPY --from=builder /usr/src/zingo-regchest/regchest/target/release/regchest /usr/local/bin/regchest

RUN mkdir -p /usr/src/zingo-regchest/test_binaries/bins
WORKDIR /usr/src/zingo-regchest
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./test_binaries/bins

ENTRYPOINT ["/usr/local/bin/regchest"]
