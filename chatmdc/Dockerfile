# Sử dụng một hình ảnh chứa Flutter
FROM mobiledevops/flutter-sdk-image:latest
# Thiết lập thư mục làm việc trong container
WORKDIR /app

# Sao chép tất cả các tệp từ thư mục gốc của dự án vào thư mục làm việc trong container
COPY . .

# Cài đặt các dependencies
RUN flutter pub get

# Xây dựng ứng dụng Flutter web
RUN flutter build web

# Sử dụng một hình ảnh cơ sở chứa web server như nginx
FROM nginx

# Sao chép các tệp build từ bước trước vào thư mục web của nginx
COPY --from=0 /app/build/web /usr/share/nginx/html

# Thiết lập cổng mặc định
EXPOSE 80

# Chạy web server
CMD ["nginx", "-g", "daemon off;"]
