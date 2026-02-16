# Next.js on Netlify Platform Starter

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/netlify-templates/next-platform-starter)

> A comprehensive starter template showcasing Next.js 16 with full Netlify platform integration. Features Turbopack, React Compiler, App Router, and extensive examples of Netlify Core Primitives.

## 🚀 Overview

This starter template demonstrates how to build modern web applications with **Next.js 16** and **Netlify** with zero configuration. It includes real-world examples of:

- 🎨 **Next.js 16** (App Router) with **React 19** and **React Compiler**
- ⚡ **Turbopack** for blazing-fast development builds
- 🎯 **Tailwind CSS 4** with custom styling and animations
- 🌐 **Netlify Edge Functions** for geo-based routing and middleware
- 📦 **Netlify Blobs** for serverless object storage
- 🖼️ **Netlify Image CDN** for automatic image optimization
- 🔄 **Advanced caching** with on-demand revalidation
- 📝 **Netlify Forms** for easy form handling
- 🛡️ **Security headers** via Next.js middleware

## ✨ Features & Demo Pages

### Core Features

| Feature | Route | Description |
|---------|-------|-------------|
| **Home** | `/` | Introduction with dynamic content and Netlify context detection |
| **Blobs Storage** | `/blobs` | Interactive blob shape generator with Netlify Blobs upload/storage |
| **Edge Functions** | `/edge` | Geography-based routing (Australia vs. non-Australia visitors) |
| **Image CDN** | `/image-cdn` | Next.js Image component + Netlify Image CDN optimization comparison |
| **Middleware** | `/middleware` | Security headers, logging, path protection, API versioning |
| **Revalidation** | `/revalidation` | On-demand cache invalidation with Wikipedia article fetching |
| **Routing** | `/routing` | Redirects & rewrites examples (internal and external) |
| **Forms** | `/classics` | Netlify Forms integration for email submissions |

### API Routes

- `/quotes/random` - Server-side random quote generator
- `/api/health` - Health check endpoint (rewrites to quotes)

## 🛠️ Tech Stack

### Framework & Core
- **Next.js 16.0.8** - React framework with App Router
- **React 19.2.4** - Latest React with concurrent features
- **React Compiler** - Automatic optimization for React components

### Styling
- **Tailwind CSS 4.1.15** - Utility-first CSS framework
- **PostCSS 8.4** - CSS transformations
- Custom animations and gradient backgrounds

### Netlify Integration
- **@netlify/blobs 10.6.0** - Serverless object storage
- **Netlify Image CDN** - Automatic image optimization
- **Edge Functions** - Serverless edge compute
- **Netlify CLI** - Local development environment

### Additional Libraries
- **markdown-to-jsx 7.7.16** - Markdown rendering
- **bright 1.0.0** - Code syntax highlighting
- **blobshape 1.0.0** - SVG blob shape generation
- **unique-names-generator 4.7.1** - Random name generation

## 📋 Prerequisites

- **Node.js 18+** (recommended: latest LTS)
- **npm** or **yarn** package manager
- **Netlify CLI** for local development with full feature support

## 🚀 Quick Start

### 1. Deploy to Netlify (Fastest)

Click the button below to deploy this template instantly:

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/netlify-templates/next-platform-starter)

### 2. Local Development

**Clone the repository:**

```bash
git clone https://github.com/netlify-templates/next-platform-starter.git
cd next-platform-starter
```

**Install dependencies:**

```bash
npm install
```

**Install Netlify CLI (if not already installed):**

```bash
npm install netlify-cli@latest -g
```

**Link to Netlify (optional but recommended):**

```bash
netlify link
```

This ensures you're using the same runtime version locally and in production.

**Start the development server:**

```bash
netlify dev
```

The site will open automatically at [http://localhost:8888](http://localhost:8888).

> **Note:** Using `netlify dev` instead of `next dev` enables full Netlify feature support including Edge Functions, Blobs, and Image CDN.

### Alternative: Standard Next.js Development

If you don't need Netlify-specific features during development:

```bash
npm run dev
```

This runs Next.js on [http://localhost:3000](http://localhost:3000).

## 📖 Usage Examples

### Netlify Blobs (Object Storage)

Server action to upload data to Netlify Blobs:

```javascript
'use server';
import { getStore } from '@netlify/blobs';

export async function uploadShape({ shapeData }) {
  const blobStore = getStore('shapes');
  const key = shapeData.name;
  await blobStore.setJSON(key, shapeData);
}
```

### Netlify Image CDN

Automatic optimization with `next/image`:

```jsx
import Image from 'next/image';

<Image 
  src="/images/corgi.jpg" 
  alt="Optimized image"
  width={800}
  height={600}
  sizes="(max-width: 1024px) 100vw, 1024px"
/>
```

Or use the CDN directly:

```jsx
<img 
  srcSet="/.netlify/images?url=/images/corgi.jpg&w=640 640w,
          /.netlify/images?url=/images/corgi.jpg&w=1280 1280w"
  sizes="(max-width: 1024px) 100vw, 1024px"
  alt="Manually optimized"
/>
```

### On-Demand Revalidation

```javascript
import { revalidateTag } from 'next/cache';

export async function refreshData() {
  'use server';
  revalidateTag('wikipedia-article');
}
```

### Next.js Middleware

```javascript
import { NextResponse } from 'next/server';

export function middleware(request) {
  const response = NextResponse.next();
  
  // Add security headers
  response.headers.set('X-Frame-Options', 'DENY');
  response.headers.set('X-Content-Type-Options', 'nosniff');
  
  return response;
}
```

## 🏗️ Project Structure

```
├── app/                    # Next.js App Router pages
│   ├── page.jsx           # Homepage
│   ├── layout.jsx         # Root layout
│   ├── blobs/             # Netlify Blobs demo
│   ├── edge/              # Edge Functions demo
│   ├── image-cdn/         # Image CDN demo
│   ├── middleware/        # Middleware examples
│   ├── revalidation/      # Cache revalidation demo
│   ├── routing/           # Redirects & rewrites
│   ├── classics/          # Netlify Forms demo
│   └── quotes/            # API routes
├── components/            # Reusable React components
├── styles/                # Global styles and Tailwind config
├── public/                # Static assets
├── netlify/               # Netlify-specific configuration
│   └── edge-functions/    # Edge Function definitions
├── middleware.js          # Next.js middleware
├── next.config.js         # Next.js configuration
├── netlify.toml           # Netlify build configuration
└── package.json           # Dependencies and scripts
```

## 🔧 Configuration

### Environment Variables

Set in Netlify UI or `.env.local`:

- `NEXT_PUBLIC_DISABLE_UPLOADS` - Set to `"true"` to disable blob uploads

### Netlify Configuration

The `netlify.toml` file configures build settings:

```toml
[build]
  publish = ".next"
  command = "npm run build"
```

### Next.js Configuration

Key configurations in `next.config.js`:
- React Compiler enabled
- Redirects for external/internal routing
- Rewrites for API aliasing

## 📜 Available Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start Next.js development server |
| `npm run build` | Build production bundle |
| `npm run start` | Start production server |
| `npm run lint` | Run ESLint |
| `netlify dev` | Start Netlify development environment (recommended) |

## 🌐 Netlify Features Explained

### Implicit Usage
Features that work automatically when deploying Next.js to Netlify:
- **Serverless Functions** - Server Actions and API Routes
- **Image Optimization** - `next/image` uses Netlify Image CDN
- **Edge Functions** - Next.js Middleware runs on Netlify Edge

### Explicit Usage
Framework-agnostic Netlify features used directly:
- **Netlify Blobs** - Object storage via `@netlify/blobs`
- **Image CDN** - Direct `/.netlify/images` endpoint usage
- **Edge Functions** - Custom geographic routing
- **Cache Control** - Fine-grained revalidation with tags

## 🔒 Security Features

- **X-Frame-Options**: DENY - Prevents clickjacking
- **X-Content-Type-Options**: nosniff - Prevents MIME sniffing
- **Referrer-Policy**: strict-origin-when-cross-origin
- **Path Protection**: Example admin route blocking
- **API Versioning**: Custom headers for API routes

## 🐛 Troubleshooting

### Netlify Functions Not Working Locally

Make sure you're using `netlify dev` instead of `next dev`:

```bash
netlify dev
```

### Blob Store Not Accessible

Ensure you've linked to a Netlify site:

```bash
netlify link
```

### Images Not Optimizing

In development, Netlify Image CDN runs locally with limited features. Deploy to Netlify for full optimization including automatic format detection.

## 📚 Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Next.js on Netlify Docs](https://docs.netlify.com/frameworks/next-js/overview/)
- [Netlify Edge Functions](https://docs.netlify.com/edge-functions/overview/)
- [Netlify Blobs Documentation](https://docs.netlify.com/blobs/overview/)
- [Netlify Image CDN](https://docs.netlify.com/image-cdn/overview/)
- [Netlify Forms](https://docs.netlify.com/forms/setup/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Built with [Next.js](https://nextjs.org/)
- Hosted on [Netlify](https://www.netlify.com/)
- Styled with [Tailwind CSS](https://tailwindcss.com/)
- Example images from [Unsplash](https://unsplash.com/)

---

**Ready to deploy?** Click the button to get started:

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/netlify-templates/next-platform-starter)
