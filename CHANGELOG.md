# Changelog

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y el versionado [Semantic Versioning](https://semver.org/lang/es/).

Cada tag de este repositorio es un esquema que el backend puede fijar. Un cambio incompatible de lectura o de escritura incrementa el minor hasta el primer `v1.0.0`; a partir de ahí, un cambio incompatible incrementa el major.

## [Unreleased]

## [0.1.0] - 2026-09-30

### Added

- Estructura del repositorio de esquemas versionados.
- Tablas `users`, `lots`, `lot_images`, `auctions`, `bids`, `transactions`, `audit_summaries` y `follows`.
- Índice único de `bids.idempotency_key` y enlace de la puja ganadora.
- Índices de catálogo público, cierre de subastas activas y seguidores.
- Restricciones de dinero, puntuación de autenticidad y seguimiento.
- Trigger que impide que `current_price` o `ends_at` retrocedan.
