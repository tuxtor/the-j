# Copilot Instructions

## Project Overview

**the-j** is a JBake static site project for the personal blog at https://www.vorozco.com. There is **no Java/Kotlin application code** — the project consists entirely of Markdown content, Freemarker templates, and static assets.

## Build Commands

```bash
# Generate static site → build/output/
./gradlew bake

# Start local dev server (JBake watch mode via Jetty)
./gradlew bakePreview

# Publish to gh-pages branch (GitHub Pages)
./gradlew publish

# Fetch and integrate external CV/resume repo
./cv.sh
```

There are no tests or linters.

## Architecture

- **`src/jbake/content/`** — Markdown source files. Pages are in the root; blog posts are under `blog/{YEAR}/`.
- **`src/jbake/templates/`** — Freemarker (`.ftl`) templates that render each content type.
- **`src/jbake/assets/`** — Static files copied as-is to output (CSS, JS, fonts, images).
- **`src/jbake/jbake.properties`** — Site-wide config (host URL, rendering flags, Facebook app ID).
- **`build/output/`** — Generated site (gitignored, deployed to `gh-pages` branch via CI).

The CI workflow (`.github/workflows/gradle.yaml`) builds with JDK 11, runs `bake`, integrates the CV, then deploys to GitHub Pages.

## Content Conventions

### Blog post front matter

Every blog post starts with JBake front matter followed by `~~~~~~`:

```markdown
title=Post Title Here
date=YYYY-MM-DD
type=post
tags=tag1,tag2
status=published
~~~~~~

Post content starts here...
```

- `status` must be `published` to appear on the site (use `draft` to hide).
- `tags` are comma-separated, lowercase.

### File naming

Blog posts: `src/jbake/content/blog/{YEAR}/YYYY-MM-DD-Kebab-Case-Title.md`

### Images

Post images go in `src/jbake/assets/images/posts/{post-slug}/` and are referenced as `/images/posts/{post-slug}/filename.jpg`.

### Templates

- `post.ftl` — individual blog post pages
- `blog.ftl` — blog listing
- `index.ftl` — homepage
- `archive.ftl` — full archive
- `feed.ftl` — RSS feed
- Shared partials: `header.ftl`, `footer.ftl`, `menu.ftl`, `share_links.ftl`
