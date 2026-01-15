# Deployment Guide - CGPA Analyzer

This guide will help you deploy the CGPA Analyzer application with:
- **Frontend**: Netlify
- **Backend**: Render

## Prerequisites

- GitHub repository with your code
- Netlify account (sign up at https://netlify.com)
- Render account (sign up at https://render.com)

---

## Part 1: Deploy Backend to Render

### Step 1: Create PostgreSQL Database on Render

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **New** → **PostgreSQL**
3. Configure:
   - **Name**: `cgpa-analyzer-db` (or any name)
   - **Database**: `cgpa_analyzer`
   - **User**: (auto-generated)
   - **Region**: Choose closest to your users
   - **Plan**: Free
4. Click **Create Database**
5. **IMPORTANT**: Copy the **Internal Database URL** (it starts with `postgresql://`)

### Step 2: Deploy Backend Service

1. In Render Dashboard, click **New** → **Web Service**
2. Connect your GitHub repository
3. Configure:
   - **Name**: `cgpa-analyzer-backend`
   - **Region**: Same as your database
   - **Branch**: `main`
   - **Root Directory**: `server`
   - **Runtime**: Node
   - **Build Command**: `npm run build`
   - **Start Command**: `npm start`
   - **Plan**: Free

4. **Add Environment Variables** (Click "Advanced" → "Add Environment Variable"):

   **Required:**
   ```
   DATABASE_URL=<paste your Internal Database URL from Step 1>
   NODE_ENV=production
   JWT_SECRET=<generate a random string - see below>
   CLIENT_URL=https://your-app-name.netlify.app
   ```

   **To generate JWT_SECRET**, run in terminal:
   ```bash
   openssl rand -base64 32
   ```

   **Optional (for Google OAuth):**
   ```
   GOOGLE_CLIENT_ID=<your Google OAuth client ID>
   GOOGLE_CLIENT_SECRET=<your Google OAuth client secret>
   GOOGLE_CALLBACK_URL=https://your-backend-name.onrender.com/api/auth/google/callback
   ```

   **Optional (for Email - using Gmail example):**
   ```
   EMAIL_HOST=smtp.gmail.com
   EMAIL_PORT=587
   EMAIL_USER=<your email>
   EMAIL_PASSWORD=<your app password>
   EMAIL_FROM=<your email>
   ```

5. Click **Create Web Service**
6. Wait for deployment (first deploy takes 5-10 minutes)
7. **Copy your backend URL**: `https://your-backend-name.onrender.com`

### Step 3: Run Database Migrations

After the backend deploys successfully:

1. In Render Dashboard, go to your backend service
2. Click **Shell** (top right)
3. Run these commands one by one:
   ```bash
   npx prisma migrate deploy
   npx prisma db seed
   ```

---

## Part 2: Deploy Frontend to Netlify

### Step 1: Deploy to Netlify

1. Go to [Netlify](https://app.netlify.com)
2. Click **Add new site** → **Import an existing project**
3. Connect to GitHub and select your repository
4. Configure:
   - **Base directory**: `client`
   - **Build command**: `npm install && npm run build`
   - **Publish directory**: `client/dist`
   - **Branch**: `main`

### Step 2: Add Environment Variables

1. Go to **Site configuration** → **Environment variables**
2. Add:
   ```
   VITE_API_URL=https://your-backend-name.onrender.com
   ```
   Replace with your actual Render backend URL from Part 1, Step 2.7

3. Click **Save**

### Step 3: Deploy

1. Click **Deploy site**
2. Wait for build to complete (2-5 minutes)
3. Your site will be live at `https://random-name.netlify.app`

### Step 4: Configure Custom Domain (Optional)

1. Go to **Domain settings**
2. Click **Add custom domain**
3. Follow instructions to add your domain

---

## Part 3: Update Backend CLIENT_URL

**IMPORTANT**: After deploying frontend:

1. Go back to Render Dashboard → Your backend service
2. Go to **Environment** tab
3. Update `CLIENT_URL` to your actual Netlify URL:
   ```
   CLIENT_URL=https://your-actual-site.netlify.app
   ```
4. Save - this will trigger a redeploy

---

## Verification Checklist

### Backend (Render)
- [ ] Service deployed successfully (green checkmark)
- [ ] Database migrations ran successfully
- [ ] Can access `https://your-backend.onrender.com/health` (if you have a health endpoint)
- [ ] All environment variables are set correctly

### Frontend (Netlify)
- [ ] Site deployed successfully
- [ ] Can access your Netlify URL
- [ ] Navigation works (SPA routing)
- [ ] VITE_API_URL environment variable is set

### Integration
- [ ] Frontend can connect to backend API
- [ ] Authentication works (login/signup)
- [ ] Data loads correctly

---

## Troubleshooting

### Backend Issues

**Build fails on Render:**
- Check build logs in Render dashboard
- Ensure all dependencies are in package.json
- Verify Node version compatibility

**Database connection fails:**
- Verify DATABASE_URL is the Internal Database URL
- Check database is in same region as backend
- Ensure database is running (not paused on free tier)

**CORS errors:**
- Verify CLIENT_URL matches your Netlify URL exactly
- Check server CORS configuration includes your frontend URL

### Frontend Issues

**Build fails on Netlify:**
- Check build logs in Netlify
- Ensure VITE_API_URL is set in environment variables
- Verify all dependencies are listed in package.json

**API calls fail:**
- Check VITE_API_URL is correct (with https://)
- Check browser console for errors
- Verify backend is running on Render

**404 errors on page refresh:**
- Verify netlify.toml is present with redirect rules
- Check publish directory is correct

---

## Important Notes

### Free Tier Limitations

**Render:**
- Free tier services spin down after 15 minutes of inactivity
- First request after spin-down takes 30-60 seconds
- Database has 90-day expiry on free tier

**Netlify:**
- 100GB bandwidth/month
- 300 build minutes/month

### Security

- Never commit `.env` files
- Keep JWT_SECRET secret and unique
- Use environment variables for all sensitive data
- Enable HTTPS only (both platforms provide this by default)

### Cost Optimization

- Use same region for database and backend
- Monitor usage in dashboards
- Consider upgrading if you exceed free tier limits

---

## Monitoring & Maintenance

### Logs

**Render:**
- View logs in Render Dashboard → Your service → Logs

**Netlify:**
- View deployment logs in Site overview → Deploys

### Updates

1. Push code to GitHub main branch
2. Render and Netlify will auto-deploy
3. Monitor deployment status in respective dashboards

---

## Support Resources

- [Render Documentation](https://render.com/docs)
- [Netlify Documentation](https://docs.netlify.com)
- [Prisma Documentation](https://www.prisma.io/docs)

---

## Quick Reference Commands

### Generate JWT Secret
```bash
openssl rand -base64 32
```

### Run Database Migrations (Render Shell)
```bash
npx prisma migrate deploy
npx prisma db seed
```

### Test Backend Locally
```bash
cd server
npm install
npm run dev
```

### Test Frontend Locally
```bash
cd client
npm install
npm run dev
```

---

Good luck with your deployment! 🚀
