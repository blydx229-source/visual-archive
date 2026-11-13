# VISUAL ARCHIVE

A responsive visual research workspace prototype. Built with vanilla HTML, CSS and JavaScript so it can run locally or be published directly with GitHub Pages.

## Features
- Dashboard with archive, collection and research counters
- Image uploads with title, category, source and notes
- Search, category filtering and sorting
- Collections
- Research editor with autosaving notes and text export
- Draggable moodboard cards and editable sticky notes
- Responsive layout
- Browser localStorage persistence

## Run locally
Open `index.html` in a modern browser. No build step is required.

## Publish with GitHub Pages
1. Create a GitHub repository, for example `visual-archive`.
2. Upload `index.html` and `README.md` to the repository root.
3. Open **Settings → Pages**.
4. Under **Build and deployment**, select **Deploy from a branch**, choose `main` and `/ (root)`, then save.

## Cloud backend
Supabase Auth, PostgreSQL workspace storage and private image Storage are integrated. Complete the setup steps below before running the site.


## Регистрация и знакомство с платформой

Добавлены Supabase Auth, облачное хранение рабочего пространства в PostgreSQL и приватное хранилище изображений. Регистрация выполняется через кнопку «Зарегистрироваться». Если включено подтверждение email, сначала подтвердите адрес из письма, затем войдите. Интерактивную инструкцию можно повторить кнопкой «Помощь».


## Supabase setup (cloud accounts and data)
1. Create a project at https://supabase.com/.
2. In **Project Settings → API**, copy the **Project URL** and the **publishable key** (or legacy `anon` key). Never put the `service_role` / secret key in browser code.
3. Paste both values into `supabase-config.js`.
4. In **SQL Editor**, run the complete contents of `supabase-setup.sql`. This creates `workspace_data`, enables Row Level Security, and creates a private image bucket with per-user storage policies.
5. In **Authentication → URL Configuration**, set your local and deployed site URLs in Site URL / Redirect URLs. For email confirmation, configure SMTP if you need reliable production delivery.
6. Serve the folder through a local web server (for example `npx serve .`) or deploy it to Vercel/Netlify/GitHub Pages. Opening `index.html` directly with `file://` can cause browser-origin issues.

Auth uses Supabase email/password. Workspace data is stored in a per-user JSONB row protected by RLS. Uploaded images are stored in a private Storage bucket and displayed using expiring signed URLs. The browser app only uses the public publishable/anon key; the service-role key is never required.


## Настроенный проект Supabase

В `supabase-config.js` указаны Project URL и публичный publishable key проекта. Секретные ключи не используются в браузере и не должны попадать в GitHub. SQL-скрипт `supabase-setup.sql` создаёт таблицу `workspace_data`, политики RLS и приватный bucket `visual-archive-images`.


Если при нажатии кнопки ничего не происходит, проверьте, что библиотека Supabase загрузилась из CDN и сайт открыт через локальный сервер (Live Server), а не через file://. Интерфейс покажет сообщение, если SDK не загрузился.
