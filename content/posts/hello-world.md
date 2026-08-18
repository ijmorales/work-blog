---
title: "Hello world"
date: 2026-08-17
description: "The template post. Every element this blog styles, on one page."
slug: "hello-world"
---

This is the template post. Copy this file, change the slug, and delete what you do not need. It carries every element the stylesheet knows how to render, so you can see the shape before you write.

## A section heading

Body copy is a serif, the chrome is a sans, and dates and code are mono. Links are a near black underline instead of a colored accent, so a paragraph full of them still reads as a paragraph. Inline code looks like `try_files $uri $uri.html` and never like a link.

- A list item.
- Another one, because one is never enough.

### A subsection

Blockquotes are for other people's words:

> Nodes are automated with LLMs while edges remain human.

Code blocks are styled by hand. No highlighter runs in the browser, so nothing here needs JavaScript:

```text
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/
EXPOSE 80
```

Images go full column width, with a caption when the image needs one.

To publish the next one: add the file under `posts/`, add its line to the index, add its item to `feed.xml`, then push. Coolify builds the image and reloads.
