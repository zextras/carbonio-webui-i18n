FROM alpine

RUN apk add --no-cache git

WORKDIR /tmp/build

# Clone all i18n repositories
RUN git clone --depth 1 https://github.com/zextras/carbonio-admin-login-ui-i18n.git carbonio-admin-login-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-admin-manage-ui-i18n.git carbonio-admin-manage-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-admin-ui-i18n.git carbonio-admin-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-auth-ui-i18n.git carbonio-auth-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-calendars-ui-i18n.git carbonio-calendars-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-contacts-ui-i18n.git carbonio-contacts-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-files-ui-i18n.git carbonio-files-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-login-ui-i18n.git carbonio-login-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-mails-ui-i18n.git carbonio-mails-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-search-ui-i18n.git carbonio-search-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-shell-ui-i18n.git carbonio-shell-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-tasks-ui-i18n.git carbonio-tasks-ui && \
    git clone --depth 1 https://github.com/zextras/carbonio-ws-collaboration-ui-i18n.git carbonio-ws-collaboration-ui

# Install localization files for login
RUN mkdir -p /opt/zextras/admin/login-i18n && \
    mkdir -p /opt/zextras/web/login-i18n && \
    cp carbonio-admin-login-ui/*.json /opt/zextras/admin/login-i18n/ && \
    cp carbonio-login-ui/*.json /opt/zextras/web/login-i18n/

# Install IRIS localizations for admin
RUN mkdir -p /opt/zextras/admin/iris/carbonio-admin-console-ui/i18n && \
    mkdir -p /opt/zextras/admin/iris/carbonio-admin-ui/i18n && \
    cp carbonio-admin-manage-ui/*.json /opt/zextras/admin/iris/carbonio-admin-console-ui/i18n/  && \
    cp carbonio-admin-ui/*.json /opt/zextras/admin/iris/carbonio-admin-ui/i18n/ 

# Install IRIS localizations for web
RUN mkdir -p /opt/zextras/web/iris/carbonio-auth-ui/i18n && \
    mkdir -p /opt/zextras/web/iris/carbonio-calendars-ui/i18n && \
    mkdir -p /opt/zextras/web/iris/carbonio-contacts-ui/i18n && \
    mkdir -p /opt/zextras/web/iris/carbonio-files-ui/i18n && \
    mkdir -p /opt/zextras/web/iris/carbonio-mails-ui/i18n && \
    mkdir -p /opt/zextras/web/iris/carbonio-search-ui/i18n && \
    mkdir -p /opt/zextras/web/iris/carbonio-shell-ui/i18n && \
    mkdir -p /opt/zextras/web/iris/carbonio-tasks-ui/i18n && \
    mkdir -p /opt/zextras/web/iris/carbonio-ws-collaboration-ui/i18n && \
    cp carbonio-auth-ui/*.json /opt/zextras/web/iris/carbonio-auth-ui/i18n/  && \
    cp carbonio-calendars-ui/*.json /opt/zextras/web/iris/carbonio-calendars-ui/i18n/  && \
    cp carbonio-contacts-ui/*.json /opt/zextras/web/iris/carbonio-contacts-ui/i18n/  && \
    cp carbonio-files-ui/*.json /opt/zextras/web/iris/carbonio-files-ui/i18n/  && \
    cp carbonio-mails-ui/*.json /opt/zextras/web/iris/carbonio-mails-ui/i18n/  && \
    cp carbonio-search-ui/*.json /opt/zextras/web/iris/carbonio-search-ui/i18n/  && \
    cp carbonio-shell-ui/*.json /opt/zextras/web/iris/carbonio-shell-ui/i18n/  && \
    cp carbonio-tasks-ui/*.json /opt/zextras/web/iris/carbonio-tasks-ui/i18n/  && \
    cp carbonio-ws-collaboration-ui/*.json /opt/zextras/web/iris/carbonio-ws-collaboration-ui/i18n/ 

RUN rm -rf /tmp/build && \
    apk del git

WORKDIR /opt/zextras

CMD ["/bin/sh"]
