FROM debian:stretch-slim

ENV GITHUB_TOKEN

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential ca-certificates gnupg2 apt-transport-https apt-utils curl git jq gcc make golang-1.8
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/src/app /go/bin

ENV PATH "$PATH:/usr/lib/go-1.8/bin/:/go/bin"
ENV GOPATH /go

# Get ghr tool to make new release on github
RUN go get -v github.com/tcnksm/ghr

WORKDIR /usr/src/app

COPY package.json .
RUN yarn

COPY release_note.js .

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

