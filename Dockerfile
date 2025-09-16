FROM zingodevops/ci-build:009

WORKDIR /usr/src
RUN git clone https://github.com/zingolabs/zingo-regchest.git \
    && cd zingo-regchest \
    && git checkout f4a3c1b652daa2a6786d12decb2e3bbeda60dc92

WORKDIR /usr/src/zingo-regchest
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./test_binaries/bins

WORKDIR /usr/src/zingo-regchest/regchest
RUN ln -s /root/.zcash-params /usr/src
RUN cargo build --release

ENTRYPOINT ["cargo", "run", "--release"]
