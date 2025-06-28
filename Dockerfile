FROM python:3.11-slim

WORKDIR /app

COPY index.html .
COPY self.crt .
COPY domains.txt .

EXPOSE 9000

CMD ["python3", "-m", "http.server", "9000"]
