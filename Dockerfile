# 使用 Python 3.11 作为基础镜像（兼容 Python 3.8+，且不支持 3.13+）
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# 安装系统依赖（如果需要编译某些 Python 包）
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .

# 安装 Python 依赖
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# 复制项目文件
COPY . .

# 创建数据目录（用于数据库和日志）
RUN mkdir -p /app/data /app/logs && \
    chmod -R 755 /app/data /app/logs

# 暴露端口
EXPOSE 5000

# 设置默认启动命令（Web 模式）
CMD ["python", "run.py", "--web"]

