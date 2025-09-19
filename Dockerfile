FROM zingodevops/ci-build:009 AS builder

WORKDIR /usr/src
RUN git clone https://github.com/zingolabs/zingo-regchest.git \
    && cd zingo-regchest \
    && git checkout 20658c1740a123b393d9c7e0a1740731b169d20b

WORKDIR /usr/src/zingo-regchest/regchest
RUN cargo build --release

FROM zingodevops/ci-build:009 AS runtime

COPY --from=builder /usr/src/zingo-regchest/regchest/target/release/regchest /usr/local/bin/regchest

RUN mkdir -p /usr/src/zingo-regchest/test_binaries/bins
WORKDIR /usr/src/zingo-regchest
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./test_binaries/bins

ENTRYPOINT ["/usr/local/bin/regchest"]
