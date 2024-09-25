FROM zingodevops/ci-build:003

WORKDIR /usr/src
RUN git clone https://github.com/zingolabs/zingo-regchest.git \
    && cd zingo-regchest \
    && git checkout 4f97aebd3d6ea77afde7dfe457ca7477918a30c2
WORKDIR /usr/src/zingo-regchest/regchest
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./libtonode-tests/regtest/bin
RUN ln -s /root/.zcash-params /usr/src
RUN cargo build --release

ENTRYPOINT ["cargo", "run", "--release"]
