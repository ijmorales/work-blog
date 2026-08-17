# work.ignaciomorales.ar

Hand written static HTML. No build step, no framework, no JavaScript, no tracking.
Coolify builds the Docker image on push and nginx serves `public/`.

```
public/
├── index.html          # the archive, grouped by year, newest first
├── style.css           # the whole stylesheet, ~230 lines
├── feed.xml            # RSS 2.0, hand maintained
├── 404.html
└── posts/
    └── hello-world.html   # the template post, copy this one
```

## Adding a post

1. `cp public/posts/hello-world.html public/posts/<slug>.html` and write it.
2. Add its row to the top of the list in `index.html`. Keep newest first.
3. Add its `<item>` to the top of the items in `feed.xml`. Match the `guid` to the URL.
4. Commit and push to `main`. A GitHub push webhook tells Coolify to redeploy.
   To deploy by hand instead: `./bin/coolify deploy work-blog` from `nmr-infrastructure`.

URLs are extensionless: `posts/hello-world.html` serves at `/posts/hello-world`.
That comes from `try_files $uri $uri.html $uri/index.html` in `nginx.conf`.

Conventions in the index:
- `[ES]` prefix for a post in Spanish, and `lang="es"` on that file.
- `[External]` prefix for a post hosted somewhere else, with `target="_blank" rel="noopener"`.
- One hand written sentence under each title. Never a truncated body.

## Deployment

| Piece | Value |
|---|---|
| Domain | `https://work.ignaciomorales.ar` |
| DNS | A record `work` -> `138.197.27.33` (`nmr-apps-1`), declared in `nmr-infrastructure/dns.tf` |
| Coolify | project NMR, environment production, server `nmr-apps-1` |
| Build | Dockerfile, `nginx:alpine`, port 80 |
| TLS | Let's Encrypt through Coolify's Traefik |

## Design notes

The look is not invented from nothing. It copies decisions from three engineering
blogs that HN featured in August 2026, checked against their real CSS:

- **gruhn.me** ("Don't be a meat proxy", 1849 points, 03-08-26). 1.6 KB of CSS for
  the whole site, one serif, no dark mode, nothing that needs JavaScript to read.
  What I took: keep the stylesheet small enough to read in one sitting.
- **seangoedecke.com** ("LLMs reward expertise", 1416 points, 03-08-26).
  `max-width: 42rem`, `font: 100%/1.75 serif`, zero webfont requests, and both
  `prefers-color-scheme` halves written out. What I took: the measure, the serif
  reading column, and declaring light mode instead of leaving it to the browser.
- **tailscale.com/blog** ("Tracking down the 16-year-old WAL-reset SQLite bug",
  1212 points, 12-08-26). Near black underlined prose links instead of link blue,
  inline code as a bordered chip, and syntax highlighting baked at build time
  rather than shipped to the browser. What I took: all three.

Runner up, for the index shape: **mayerowitz.io** ("Mario Meets Pareto", 1186
points, 06-08-26), which groups the archive by year and puts a mono month-and-day
next to each title.

Rules this repo holds itself to:
- Three type roles: serif for reading copy, sans for chrome, mono for dates and code.
- One accent colour, used on link underlines only.
- Every colour is a token, defined for light and for dark.
- `pre` always gets `overflow-x: auto`, so the page never scrolls sideways.
- No client side syntax highlighter. If a post needs highlighting, bake the spans in.
