FROM alpine:3.6

ENV SQLCHECK_VERSION=1.0.5

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/mterron/sqlcheck.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.label-schema.version=$SQLCHECK_VERSION \
      org.label-schema.description="Alpine based SQLCheck image"

RUN apk --nocache upgrade &&\
	apk --no-cache add cmake curl g++ git musl-dev &&\
	git clone --recursive https://github.com/jarulraj/sqlcheck.git &&\
	cd sqlcheck &&\
	./bootstrap &&\
	cd build &&\
	cmake -DCMAKE_BUILD_TYPE=RELEASE .. &&\
	make &&\
	make install &&\
	rm -rf sqlcheck &&\
	apk --no-cache del --purge cmake curl g++ git musl-dev &&\
	sqlcheck --help
