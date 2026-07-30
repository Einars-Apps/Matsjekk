# Mat Sjekk Landing Page

This folder contains the GitHub Pages website for matsjekk.com.

## Setup Instructions

1. **Create GitHub Repository**
   - Go to https://github.com/new
   - Name: `matsjekk-website` (or any name you prefer)
   - Make it public
   - Don't initialize with README

2. **Push Files to GitHub**
   ```powershell
   cd c:\Users\ebors\mat_sjekk\docs
   git init
   git add .
   git commit -m "Initial commit - Mat Sjekk landing page"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/matsjekk-website.git
   git push -u origin main
   ```

3. **Enable GitHub Pages**
   - Go to repository Settings → Pages
   - Source: Deploy from a branch
   - Branch: main / (root)
   - Click Save

4. **Configure Custom Domain**
   - In the same Pages settings, add custom domain: `matsjekk.com`
   - Wait for DNS check to complete

5. **Update Domain DNS Records** (at your domain registrar)
   
   Add these records:
   
   **A Records:**
   ```
   @    A    185.199.108.153
   @    A    185.199.109.153
   @    A    185.199.110.153
   @    A    185.199.111.153
   ```
   
   **CNAME Record (for www subdomain):**
   ```
   www  CNAME  YOUR_USERNAME.github.io
   ```

6. **Google Search Console Verification**
   - Go to https://search.google.com/search-console
   - Add property: matsjekk.com
   - Use "DNS record" method:
     - Add TXT record to your domain:
       ```
       @  TXT  google-site-verification=XXXXX
       ```
   - Or use "HTML tag" method:
     - Copy the verification meta tag
     - Add it to `index.html` in the `<head>` section (line marked with comment)

## Files

- **index.html** - Main landing page with SEO optimization
- **styles.css** - Styling for the website
- **CNAME** - Custom domain configuration for GitHub Pages
- **README.md** - This file

## TODO Before Going Live

- [ ] Replace app store links in index.html (currently #)
- [ ] Add Google Search Console verification meta tag
- [ ] Add app screenshots/images if desired
- [ ] Update privacy policy and terms (currently placeholder links)
- [ ] Consider adding Google Analytics or similar

## Contact

Email: matsjekk@gmail.com
