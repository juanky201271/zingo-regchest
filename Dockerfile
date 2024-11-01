FROM zingodevops/ci-build:004

WORKDIR /usr/src
RUN git clone https://github.com/zingolabs/zingo-regchest.git \
    && cd zingo-regchest \
    && git checkout a102e04295863113dfb094f08cb9ef4b1207027f

WORKDIR /usr/src/zingo-regchest
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./test_binaries/bins

WORKDIR /usr/src/zingo-regchest/regchest
#RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./regtest/bin
RUN ln -s /root/.zcash-params /usr/src
RUN cargo build --release

ENTRYPOINT ["cargo", "run", "--release"]
