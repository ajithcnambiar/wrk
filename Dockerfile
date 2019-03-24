FROM ubuntu:latest as builder
RUN apt-get update && apt-get install netbase -y && apt-get install build-essential -y
WORKDIR /StressTest
COPY . .
RUN make

FROM ubuntu:latest
RUN apt-get update && apt-get install netbase -y
WORKDIR /StressTest
COPY --from=builder /StressTest/wrk .
RUN chmod +x wrk
COPY request.lua .
CMD [ "./wrk" ]