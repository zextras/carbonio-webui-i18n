# Build stage - clone and organize i18n files
FROM --platform=$BUILDPLATFORM alpine/git:v2.49.1 AS builder

WORKDIR /tmp/build

# Clone all i18n repositories
RUN --mount=type=secret,id=ssh_key,target=/tmp/id_rsa \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    cp /tmp/id_rsa /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa && \
    ssh-keyscan github.com > /root/.ssh/known_hosts && \
    git clone --depth 1 git@github.com:zextras/carbonio-admin-login-ui-i18n.git carbonio-admin-login-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-admin-ui-i18n.git carbonio-admin-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-auth-ui-i18n.git carbonio-auth-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-calendars-ui-i18n.git carbonio-calendars-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-contacts-ui-i18n.git carbonio-contacts-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-files-ui-i18n.git carbonio-files-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-login-ui-i18n.git carbonio-login-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-mails-ui-i18n.git carbonio-mails-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-search-ui-i18n.git carbonio-search-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-shell-ui-i18n.git carbonio-shell-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-tasks-ui-i18n.git carbonio-tasks-ui && \
    git clone --depth 1 git@github.com:zextras/carbonio-ws-collaboration-ui-i18n.git carbonio-ws-collaboration-ui

# Create directory structure and install localization files
RUN mkdir -p /opt/zextras/admin/login-i18n \
    /opt/zextras/admin/iris/i18n \
    /opt/zextras/web/login-i18n \
    /opt/zextras/web/iris/carbonio-auth-ui/i18n \
    /opt/zextras/web/iris/carbonio-calendars-ui/i18n \
    /opt/zextras/web/iris/carbonio-contacts-ui/i18n \
    /opt/zextras/web/iris/carbonio-files-ui/i18n \
    /opt/zextras/web/iris/carbonio-mails-ui/i18n \
    /opt/zextras/web/iris/carbonio-search-ui/i18n \
    /opt/zextras/web/iris/carbonio-shell-ui/i18n \
    /opt/zextras/web/iris/carbonio-tasks-ui/i18n \
    /opt/zextras/web/iris/carbonio-ws-collaboration-ui/i18n

# Copy login localizations
RUN cp carbonio-admin-login-ui/*.json /opt/zextras/admin/login-i18n/ && \
    cp carbonio-login-ui/*.json /opt/zextras/web/login-i18n/

# Copy admin IRIS localizations
RUN cp carbonio-admin-ui/*.json /opt/zextras/admin/iris/i18n/

# Copy web IRIS localizations
RUN cp carbonio-auth-ui/*.json /opt/zextras/web/iris/carbonio-auth-ui/i18n/ && \
    cp carbonio-calendars-ui/*.json /opt/zextras/web/iris/carbonio-calendars-ui/i18n/ && \
    cp carbonio-contacts-ui/*.json /opt/zextras/web/iris/carbonio-contacts-ui/i18n/ && \
    cp carbonio-files-ui/*.json /opt/zextras/web/iris/carbonio-files-ui/i18n/ && \
    cp carbonio-mails-ui/*.json /opt/zextras/web/iris/carbonio-mails-ui/i18n/ && \
    cp carbonio-search-ui/*.json /opt/zextras/web/iris/carbonio-search-ui/i18n/ && \
    cp carbonio-shell-ui/*.json /opt/zextras/web/iris/carbonio-shell-ui/i18n/ && \
    cp carbonio-tasks-ui/*.json /opt/zextras/web/iris/carbonio-tasks-ui/i18n/ && \
    cp carbonio-ws-collaboration-ui/*.json /opt/zextras/web/iris/carbonio-ws-collaboration-ui/i18n/

# Final stage - minimal runtime image
FROM alpine:3.22.2

# Copy only the necessary files from builder
COPY --from=builder /opt/zextras /opt/zextras

WORKDIR /opt/zextras

CMD ["/bin/sh"]
