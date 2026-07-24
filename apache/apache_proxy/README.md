# Apache reverse proxy — multi-site portfolio

Modules: `sudo a2enmod rewrite ssl headers proxy proxy_http proxy_wstunnel deflate expires`

## Layout

```
apache_proxy/
  conf/                 # shared apache2.conf, ports, security-headers
  portfolio/
    sites-available/
    sites-enabled/
    .htaccess
  streaming/
  blog/
  api/
  dashboard/
  docs/
  shop/
  chat/
```

## Sites

| Project | Host | Backend | Notes |
|---|---|---|---|
| portfolio | `portfolio.local` | static `/var/www/portfolio` | SPA |
| streaming | `streaming.local` | `streaming-app:8080` | WebSocket `/ws`, `/socket.io` + HLS `/stream` |
| blog | `blog.local` | `blog-app:3000` | posts + `/api` |
| api | `api.local` | `api-app:4000` | REST + CORS |
| dashboard | `dashboard.local` | `dashboard-app:5000` | live metrics WebSocket |
| docs | `docs.local` | static `/var/www/docs` | read-only GET/HEAD |
| shop | `shop.local` | `shop-app:6000` | checkout proxy |
| chat | `chat.local` | `chat-app:7000` | WebSocket chat |

## Enable one project

```bash
# example: streaming
sudo ln -sf $PWD/streaming/sites-available/streaming.conf /etc/apache2/sites-enabled/streaming.conf
sudo ln -sf $PWD/streaming/sites-available/streaming-ssl.conf /etc/apache2/sites-enabled/streaming-ssl.conf
sudo apache2ctl configtest && sudo systemctl reload apache2
```

## Enable all

```bash
ROOT=$(pwd)
for site in portfolio streaming blog api dashboard docs shop chat; do
  sudo ln -sf "$ROOT/$site/sites-available/${site}.conf" /etc/apache2/sites-enabled/${site}.conf
  sudo ln -sf "$ROOT/$site/sites-available/${site}-ssl.conf" /etc/apache2/sites-enabled/${site}-ssl.conf
done
sudo apache2ctl configtest && sudo systemctl reload apache2
```
