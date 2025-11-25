# Aura OS GitHub Pages Setup

This `docs/` folder contains the download page for Aura OS hosted on GitHub Pages.

## Files Structure
```
docs/
├── index.html           # Main download page
├── css/
│   └── download.css     # Styling
├── js/
│   └── download.js      # Carousel and theme toggle logic
└── assets/
    ├── aura_os_light.png
    └── aura_os_dark.png
```

## Deployment

The page is automatically deployed to GitHub Pages at:
**https://motion-art.github.io/aura_os/**

### Configuration
- Repository: Motion-art/aura_os
- Branch: main
- Source folder: /docs

## Setup Steps

1. **Copy assets** - Make sure the logo images are in `docs/assets/`:
   ```bash
   cp assets/aura_os_light.png docs/assets/
   cp assets/aura_os_dark.png docs/assets/
   ```

2. **Enable GitHub Pages**:
   - Go to repository Settings → Pages
   - Select `main` branch and `/docs` folder
   - Save

3. **Wait for deployment** - GitHub will build and deploy within minutes

## Local Preview

To test locally, you can use any simple HTTP server:

```bash
# Python 3
python -m http.server 8000 --directory docs

# Or Node.js
npx http-server docs -p 8000
```

Then visit: http://localhost:8000

## Features
- ✅ Light/Dark theme toggle
- ✅ Device mockup carousel
- ✅ Responsive design
- ✅ Direct APK download link
- ✅ Feature showcase
- ✅ CTA section
