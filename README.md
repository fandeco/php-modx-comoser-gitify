# Docker для modx

Билд образа

```bash
# только для amd64
docker buildx build --platform linux/amd64 -t php-modx-composer-gitify:latest .
# push через phpstorm в webnitros/php-modx-composer-gitify:latest

# для включение поддержки amd64
docker buildx create --use

# Сборка и публикация образа
# перед выполнением проверить авторизации на docker hub "docker login"
docker buildx build --platform linux/arm64,linux/amd64 -t webnitros/php-modx-composer-gitify:latest --push .

```
