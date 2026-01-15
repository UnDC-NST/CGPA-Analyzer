# Deployment Checklist

Use this checklist to track your deployment progress.

## Pre-Deployment

- [ ] Code pushed to GitHub repository
- [ ] Have accounts on:
  - [ ] Render.com
  - [ ] Netlify.com
- [ ] Generated JWT secret (run: `openssl rand -base64 32`)
- [ ] Google OAuth credentials (optional)
- [ ] Email service credentials (optional)

---

## Backend Deployment (Render)

### Database Setup
- [ ] Created PostgreSQL database on Render
- [ ] Database region selected (same as backend)
- [ ] Copied Internal Database URL
- [ ] Database is running (green status)

### Backend Service
- [ ] Created Web Service on Render
- [ ] Connected GitHub repository
- [ ] Configured:
  - [ ] Name: `cgpa-analyzer-backend`
  - [ ] Root Directory: `server`
  - [ ] Build Command: `npm run build`
  - [ ] Start Command: `npm start`
  - [ ] Runtime: Node

### Environment Variables (Backend)
- [ ] `DATABASE_URL` = [Internal DB URL]
- [ ] `NODE_ENV` = production
- [ ] `JWT_SECRET` = [generated secret]
- [ ] `CLIENT_URL` = [Netlify URL - update after frontend deploy]

**Optional:**
- [ ] `GOOGLE_CLIENT_ID`
- [ ] `GOOGLE_CLIENT_SECRET`
- [ ] `GOOGLE_CALLBACK_URL`
- [ ] `EMAIL_HOST`
- [ ] `EMAIL_PORT`
- [ ] `EMAIL_USER`
- [ ] `EMAIL_PASSWORD`
- [ ] `EMAIL_FROM`

### Post-Deployment (Backend)
- [ ] First deployment completed successfully
- [ ] Opened Shell in Render dashboard
- [ ] Ran: `npx prisma migrate deploy`
- [ ] Ran: `npx prisma db seed`
- [ ] No errors in deployment logs
- [ ] Copied backend URL: __________________________________

---

## Frontend Deployment (Netlify)

### Site Setup
- [ ] Created new site on Netlify
- [ ] Connected GitHub repository
- [ ] Configured:
  - [ ] Base directory: `client`
  - [ ] Build command: `npm install && npm run build`
  - [ ] Publish directory: `client/dist`
  - [ ] Branch: `main`

### Environment Variables (Frontend)
- [ ] `VITE_API_URL` = [Backend URL from Render]

### Post-Deployment (Frontend)
- [ ] First deployment completed successfully
- [ ] Site is accessible
- [ ] No build errors
- [ ] Copied frontend URL: __________________________________

---

## Final Configuration

- [ ] Updated `CLIENT_URL` in Render backend to Netlify URL
- [ ] Backend redeployed with new CLIENT_URL
- [ ] Both services showing green/healthy status

---

## Testing

### Backend
- [ ] Backend URL is accessible
- [ ] API responds to requests
- [ ] Database connection working
- [ ] No errors in Render logs

### Frontend
- [ ] Frontend loads correctly
- [ ] All pages accessible
- [ ] SPA routing works (refresh on any page)
- [ ] No console errors in browser

### Integration
- [ ] Frontend can connect to backend
- [ ] CORS working (no CORS errors)
- [ ] Login/Signup works
- [ ] Data saves correctly
- [ ] Google OAuth works (if configured)
- [ ] Email sending works (if configured)

---

## Optional Enhancements

- [ ] Custom domain for frontend
- [ ] Custom domain for backend
- [ ] SSL certificates (auto with Render/Netlify)
- [ ] Monitoring/alerts setup
- [ ] Analytics integration

---

## Troubleshooting Completed

- [ ] Fixed any CORS issues
- [ ] Resolved environment variable problems
- [ ] Fixed database connection issues
- [ ] Resolved build errors
- [ ] Fixed routing issues

---

## Documentation

- [ ] Noted backend URL for team
- [ ] Noted frontend URL for team
- [ ] Documented any custom configurations
- [ ] Updated team wiki/docs (if applicable)

---

## 🎉 Deployment Complete!

**Frontend URL:** _________________________________

**Backend URL:** _________________________________

**Deployed on:** _________________________________

**Next Steps:**
- Monitor application logs
- Set up error tracking (optional)
- Plan for database backups (if using beyond free tier)
- Share with users!

---

**Notes:**
_____________________________________________________

_____________________________________________________

_____________________________________________________

_____________________________________________________
