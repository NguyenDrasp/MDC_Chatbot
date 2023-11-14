FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip


# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade

WORKDIR /app/
# Copy files to container and build
COPY . .

RUN flutter pub get

RUN flutter build web

# Expose cổng cho ứng dụng web

FROM nginx

# Sao chép các tệp build từ bước trước vào thư mục web của nginx
COPY --from=0 /app/build/web /usr/share/nginx/html

# Thiết lập cổng mặc định
EXPOSE 80

# Chạy web server
CMD ["nginx", "-g", "daemon off;"]

#docker run -p 80:80 chatbot