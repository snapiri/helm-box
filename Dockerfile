FROM docker.io/alpine:latest
FROM alpine:3.11

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="helm-kubectl" \
      org.label-schema.url="https://hub.docker.com/r/dtzar/helm-kubectl/" \
      org.label-schema.vcs-url="https://github.com/dtzar/helm-kubectl" \
      org.label-schema.build-date=$BUILD_DATE

# Note: Latest version of kubectl may be found at:
# https://github.com/kubernetes/kubernetes/releases
ENV KUBE_LATEST_VERSION="v1.17.3"
# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.1.2"
# Note: Latest version of helmfile may be found at:
# https://github.com/roboll/helmfile/releases
ENV HELMFILE_VERSION="v0.104.0"
# Note: Latest version of sops may be found at:
# https://github.com/mozilla/sops/releases
ENV SOPS_VERSION="v3.5.0"
# FIXME: This should come from the system itself
ENV ARCH="amd64"

RUN apk add --no-cache ca-certificates bash git openssh curl gnupg \
    && echo "Downloading binaries" \
    && wget https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/${ARCH}/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget https://get.helm.sh/helm-${HELM_VERSION}-linux-${ARCH}.tar.gz -O - | tar -xzO linux-${ARCH}/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && wget https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_${ARCH} -O /usr/local/bin/helmfile \
    && chmod +x /usr/local/bin/helmfile \
    && wget https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_${ARCH} -O /usr/local/bin/helmfile \
    && chmod +x /usr/local/bin/helmfile \
    && wget https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux -O /usr/local/bin/sops \
    && chmod +x /usr/local/bin/sops \
    && helm plugin install https://github.com/databus23/helm-diff --version master \
    && helm plugin install https://github.com/futuresimple/helm-secrets

WORKDIR /config

CMD bash