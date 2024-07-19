# 使用官方的 Node.js 最新镜像作为基础镜像
FROM node:latest AS builder

# 设置工作目录
WORKDIR /app

# 克隆项目
RUN git clone https://github.com/kechangdev/status.git .

# 安装 pnpm
RUN npm install -g pnpm

# 安装项目依赖
RUN pnpm install

# 构建项目
RUN pnpm build

# 生成生产环境镜像
FROM node:latest

# 设置工作目录
WORKDIR /app

# 复制构建好的文件
COPY --from=builder /app /app

# 安装 pnpm
RUN npm install -g pnpm

# 安装仅生产环境依赖
RUN pnpm install --production

# 设置环境变量，指定项目开放端口
ENV PORT=4173

# 暴露端口 4173
EXPOSE 4173

# 启动项目，并明确指定端口和主机
CMD ["pnpm", "preview", "--", "--port", "4173", "--host", "0.0.0.0"]
