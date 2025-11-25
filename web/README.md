# Download page (local preview)

This folder contains a standalone download page for Aura OS that follows the app theme.

Files:
- `download.html` — main page
- `css/download.css` — styles (light + dark)
- `js/download.js` — interactive bits (theme toggle, carousel)

How to preview locally:
1. From the project root run a simple static server. Example using PowerShell + .NET: `Start-Process "powershell" -ArgumentList "-NoExit","python -m http.server 8080"` or using `npx http-server` if you have Node installed.
2. Open `http://localhost:8080/web/download.html` in your browser.

Notes:
- The page references the app logos at `/assets/aura_os_light.png` and `/assets/aura_os_dark.png`.
- Replace placeholder download links with real APK/App Store links.
- The page is responsive and adapts to light/dark preference; users can toggle theme with the top-right button.
