FROM node:20-alpine

WORKDIR /app

COPY package.json ./
RUN npm install

COPY index.js index.html ./

# 预下载 argo 依赖二进制 (Go 静态编译, musl 兼容), 避免运行时下载失败
# 并在构建期验证可执行, 排除缺库问题
RUN apk add --no-cache curl ca-certificates && \
    curl -sSL -o /usr/local/bin/web https://amd64.ssss.nyc.mn/web && \
    curl -sSL -o /usr/local/bin/bot https://amd64.ssss.nyc.mn/bot && \
    chmod +x /usr/local/bin/web /usr/local/bin/bot && \
    /usr/local/bin/web version 2>&1 | head -2 && \
    /usr/local/bin/bot version 2>&1 | head -2 && \
    echo "binaries OK"

EXPOSE 3000

CMD ["node", "index.js"]
