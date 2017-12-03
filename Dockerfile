FROM alpine:latest

ENV SQLCHECK_VERSION=1.0.5

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/mterron/sqlcheck.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.label-schema.version=$SQLCHECK_VERSION \
      org.label-schema.description="SQLCheck: Automatically identify anti-patterns in SQL queries"

RUN	apk --no-cache upgrade &&\
	apk --no-cache add cmake gcc g++ git libstdc++ make musl-dev &&\
	git clone --recursive https://github.com/jarulraj/sqlcheck.git &&\
	cd sqlcheck &&\
	./bootstrap &&\
	cd build &&\
	cmake -DCMAKE_BUILD_TYPE=RELEASE .. &&\
	make &&\
	make check &&\
	make install &&\
	rm -rf sqlcheck &&\
	apk --no-cache del --purge cmake gcc g++ git make musl-dev &&\
	echo DONE

ENTRYPOINT ["sqlcheck"]
