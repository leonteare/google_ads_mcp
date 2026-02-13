# --- Build stage ---
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

WORKDIR /app

# Install dependencies first (cached layer)
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project

# Copy source and install the project itself
COPY . .
RUN uv sync --frozen --no-dev

# --- Runtime stage ---
FROM python:3.12-slim-bookworm AS runtime

WORKDIR /app

# Copy the virtual environment and project from builder
COPY --from=builder /app /app

# Railway sets PORT; FastMCP reads FASTMCP_PORT
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
