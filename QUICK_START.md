# Quick Start - Deployment

## 🚀 Deploy in 3 Steps

### 1️⃣ Deploy Backend to Render

1. Go to [render.com](https://render.com) → **New** → **PostgreSQL**
   - Create database, copy **Internal Database URL**

2. **New** → **Web Service** → Connect GitHub repo
   - **Root Directory**: `server`
   - **Build Command**: `npm run build`
   - **Start Command**: `npm start`
   
3. Add environment variables:
   ```
   DATABASE_URL=<your database URL>
   NODE_ENV=production
   JWT_SECRET=<generate with: openssl rand -base64 32>
   CLIENT_URL=https://your-app.netlify.app (will update later)
   ```

4. Deploy, then in **Shell** tab run:
   ```bash
   npx prisma migrate deploy
   npx prisma db seed
   ```

5. **Copy your backend URL**: `https://xxx.onrender.com`

---

### 2️⃣ Deploy Frontend to Netlify

1. Go to [netlify.com](https://netlify.com) → **Add new site** → Import from GitHub

2. Configure:
   - **Base directory**: `client`
   - **Build command**: `npm install && npm run build`
   - **Publish directory**: `client/dist`

3. Add environment variable:
   ```
   VITE_API_URL=<your backend URL from step 1.5>
   ```

4. **Deploy!** Copy your Netlify URL: `https://xxx.netlify.app`

---

### 3️⃣ Update Backend CLIENT_URL

1. Go back to Render → Your backend service → **Environment**

2. Update:
   ```
   CLIENT_URL=<your Netlify URL from step 2.4>
   ```

3. Save (triggers redeploy)

---

## ✅ Done!

Your app should now be live and working!

**Need detailed instructions?** See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

---

## 📋 Quick Checklist

- [ ] PostgreSQL database created on Render
- [ ] Backend deployed with all environment variables
- [ ] Database migrations ran successfully
- [ ] Frontend deployed to Netlify with VITE_API_URL
- [ ] CLIENT_URL updated on backend
- [ ] Test login/signup works
