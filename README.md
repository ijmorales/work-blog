# work.ignaciomorales.ar

Hugo site, terminal theme, no JavaScript, no tracking. Coolify builds the image
on push and nginx serves it.

```
content/posts/*.md      # the posts
layouts/                # baseof, home, single, list, 404
layouts/shortcodes/     # step, example, done, warn, card, fig
assets/css/site.css     # terminal-css by panr, vendored, plus this site's layer
static/img/*.svg        # the diagrams, one per theme
hugo.toml
Dockerfile              # hugo build stage, then nginx
nginx.conf
```

## Writing a post

```bash
hugo new content posts/my-slug.md   # or copy an existing file
hugo server -D                      # live preview at localhost:1313, drafts included
```

Front matter:

```yaml
---
title: "The title"
date: 2026-08-17
description: "One hand written line. It shows on the index and in the feed."
slug: "my-slug"
draft: true
---
```

Commit and push to `main`. That is the whole publish step: the index, the feed and
the archive order all follow from the front matter.

## Shortcodes

The long form recipe post uses these. Plain posts need none of them.

| Shortcode | Use |
|---|---|
| `{{%/* step num="01" title="Ramble" */%}}` | a numbered step with its own heading |
| `{{%/* example chip="Real session · 04-08" */%}}` | a real prompt: quote it, then say what it teaches |
| `{{%/* done */%}}` | how you know the step is finished |
| `{{%/* warn */%}}` | the trap in that step |
| `{{%/* card title="..." */%}}` | a boxed checklist |
| `{{</* fig name="01-loop" caption="..." */>}}` | a diagram, light and dark |

Code fences take `prompt` as a language when the block is a prompt you typed.

## Diagrams

They are Excalidraw scenes, rendered by Excalidraw's own renderer, one SVG per
theme. Each SVG carries its scene, so dropping it into excalidraw.com reopens it
as editable elements. Sources and the render pipeline live in the vault, at
`Resources/Flujo de desarrollo/diagrams`.

## Theme

[terminal-css](https://panr.github.io/terminal-css/) by panr, vendored at the top
of `assets/css/site.css`. Light and dark come from `prefers-color-scheme`, so the
site follows the OS. There is no toggle, which is why there is no JavaScript.

Tokens, if you want to repaint it:

| Token | Light | Dark |
|---|---|---|
| `--background` | `#f6f2e7` | `#1a170f` |
| `--foreground` | `#1a170f` | `#eceae5` |
| `--accent` | `#8a5e00` | `#eec35e` |

## Deployment

| Piece | Value |
|---|---|
| Domain | `https://work.ignaciomorales.ar` |
| DNS | A record `work` -> `138.197.27.33` (`nmr-apps-1`), declared in `nmr-infrastructure/dns.tf` |
| Coolify | project NMR, environment production, build pack Dockerfile, port 80 |
| TLS | Let's Encrypt through Coolify's Traefik |

Traefik terminates TLS and routes the domain to the container. It does not read
files, so the container still needs nginx inside it to serve them.
