# --- Stage 1: Extraction & Minimal Asset Prepping ---
FROM alpine:latest AS builder

# Added rpm2cpio so Alpine can unpack the inner installer
RUN apk add --no-cache curl unzip rpm2cpio

WORKDIR /tmp

# Download the genuine Broadcom target package archive
RUN curl -L -o storcli_rel.zip "https://docs.broadcom.com/docs-and-downloads/007.2705.0000.0000_storcli_rel.zip" \
    && unzip storcli_rel.zip \
    && unzip storcli_rel/Unified_storcli_all_os.zip

# Create the folder and cleanly extract the binary payload
RUN mkdir extract \
    && cd extract \
    && rpm2cpio ../Unified_storcli_all_os/Linux/storcli-007.2705.0000.0000-1.noarch.rpm | cpio -idmv

# --- Stage 2: Final Ultra-Lightweight Production Image ---
FROM alpine:latest

# Install gcompat layer so the glibc-compiled storcli binary functions on musl-based Alpine
RUN apk add --no-cache gcompat

# Extract ONLY the standalone 64-bit production binary into our active system path
COPY --from=builder /tmp/extract/opt/MegaRAID/storcli/storcli64 /usr/local/bin/storcli64

# Simple sanity test verifying the compilation path works during image build
RUN storcli64 -v

CMD ["/bin/sh"]
