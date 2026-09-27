FROM node:20-alpine

WORKDIR /app

COPY package.json ./
RUN npm install

COPY index.js index.html ./

# 预下载 argo 依赖二进制到 index.js 的运行目录 .tmp/
# (Go 静态编译, musl 兼容); 构建期验证可执行, 排除缺库问题
RUN apk add --no-cache curl ca-certificates && \
    mkdir -p .tmp && \
    curl -sSL -o .tmp/web https://amd64.ssss.nyc.mn/web && \
    curl -sSL -o .tmp/bot https://amd64.ssss.nyc.mn/bot && \
    curl -sSL -o .tmp/v1 https://amd64.ssss.nyc.mn/v1 && \
    chmod +x .tmp/web .tmp/bot .tmp/v1 && \
    ./.tmp/web version 2>&1 | head -2 && \
    ./.tmp/bot version 2>&1 | head -2 && \
    echo "binaries OK"

ENV FILE_PATH=/app/.tmp

EXPOSE 3000

CMD ["node", "index.js"]
