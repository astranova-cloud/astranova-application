FROM python:3.11-slim

# Create non-root user
RUN useradd -m appuser

WORKDIR /app

COPY app.py .

# Change ownership
RUN chown -R appuser:appuser /app

# Run container as non-root
USER appuser

CMD ["python", "app.py"]