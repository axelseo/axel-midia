# axel-midia

Hospedagem pública de arquivos de mídia (vídeos e capas dos Reels) para o robô
de publicação automática da Axel (`axelseo/axel-social-direto`).

A API da Meta só baixa mídia de uma URL pública — por isso os vídeos ficam
aqui, servidos pelo GitHub Pages, e não no repositório privado do robô.

Este repositório não tem conteúdo de navegação: `robots.txt` bloqueia tudo e
`index.html` tem `noindex`. Ele existe só para servir arquivo.

## Estrutura

- `/v/<codigo>.mp4` — vídeo (Reel)
- `/c/<codigo>.jpg` — capa (quando existir)

Código é o identificador usado em `agenda.json` (ex.: `A1`, `B10`, `K3`) —
sempre ASCII, sem espaço ou acento.

## Subir um lote novo

```
scripts/subir_midia.sh <codigo> <caminho-do-mp4> [caminho-do-jpg]
```

O script copia o arquivo para `v/` (e `c/`, se houver capa), comita e dá
push. Depois disso, as URLs públicas são:

```
https://axelseo.github.io/axel-midia/v/<codigo>.mp4
https://axelseo.github.io/axel-midia/c/<codigo>.jpg
```

O GitHub Pages leva alguns minutos para publicar depois do push. Confira
com `curl -I <url>` — tem que vir `200` e sem redirecionamento.

Depois de subir a mídia, adicione a entrada correspondente em
`agenda.json`, no repositório `axel-social-direto`.
