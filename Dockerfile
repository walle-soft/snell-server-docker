# 使用Tonistiigi的xx基础镜像作为构建层
FROM tonistiigi/xx AS xx

# 使用Alpine作为构建镜像
FROM alpine as build

# 从xx基础镜像复制文件
COPY --from=xx / /

# 复制get_url.sh脚本到容器中
COPY get_url.sh /get_url.sh

# 设置环境变量VERSION
ENV VERSION 4.0.1

# 下载和验证snell-server
RUN xx-info env && wget -q -O "snell-server.zip" $(/get_url.sh ${VERSION} $(xx-info arch)) && \
    unzip snell-server.zip && rm snell-server.zip && \
    xx-verify /snell-server

# 使用Ubuntu最新版作为最终镜像
FROM ubuntu:latest

# 设置环境变量
ENV TZ=UTC

# 设置工作目录
WORKDIR /app

# 从构建层复制snell-server到/usr/bin目录下
COPY --from=build /snell-server /usr/bin/snell-server

# 复制start.sh脚本到容器中
COPY start.sh /start.sh

# 创建用户deploy，并确保/usr/bin/snell-server和/start.sh可执行
RUN useradd -m deploy && \
    mkdir -p /etc/snell && \
    chown -R deploy:deploy /etc/snell && \
    chmod +x /usr/bin/snell-server /start.sh && \
    chown -R deploy:deploy /usr/bin/snell-server /start.sh

# 切换至deploy用户
USER deploy

# 暴露9102端口
EXPOSE 9102

# 运行start.sh脚本以启动服务
CMD ["/start.sh"]