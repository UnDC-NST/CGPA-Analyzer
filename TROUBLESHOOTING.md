# Common Deployment Issues & Solutions

Quick reference for common problems and their solutions.

---

## 🔴 Backend Issues (Render)

### Build Failed

**Error:** `npm install` fails or build times out

**Solutions:**
1. Check package.json has all dependencies
2. Verify Node version compatibility
3. Check Render build logs for specific error
4. Try clearing build cache in Render settings

**Error:** `Prisma client is not generated`

**Solutions:**
```bash
# The postinstall script should handle this, but if not:
# In Render Shell, run:
npx prisma generate
```

---

### Database Connection Failed

**Error:** `Can't reach database server`

**Solutions:**
1. ✅ Verify you're using **Internal Database URL** (not External)
2. ✅ Check database and backend are in same region
3. ✅ Confirm database is running (not paused/suspended)
4. ✅ DATABASE_URL format:
   ```
   postgresql://user:password@host/database?sslmode=require
   ```

**Error:** `SSL connection error`

**Solution:**
Add to DATABASE_URL:
```
?sslmode=require
```

---

### Migrations Failed

**Error:** `Migration failed to apply`

**Solutions:**
1. Run in Render Shell:
   ```bash
   npx prisma migrate reset --force
   npx prisma migrate deploy
   ```
2. Check migration files are committed to repo
3. Verify DATABASE_URL is correct

---

### Service Won't Start

**Error:** `Application failed to start`

**Solutions:**
1. Check start command: `npm start`
2. Verify server.js exists and is correct
3. Check for missing environment variables
4. Review logs for specific error
5. Ensure PORT is not hardcoded (Render assigns it)

---

### Cold Start Delay

**Symptom:** First request takes 30-60 seconds

**Explanation:**
- Free tier services sleep after 15 min inactivity
- This is normal behavior on free tier

**Solutions:**
- Upgrade to paid tier for always-on service
- Use a service to ping your backend every 10 minutes
- Accept the limitation for free tier

---

## 🔴 Frontend Issues (Netlify)

### Build Failed

**Error:** Build command fails

**Solutions:**
1. Check build logs in Netlify dashboard
2. Verify package.json scripts
3. Ensure all dependencies are listed
4. Check for environment variable issues:
   ```bash
   # Build should work without VITE_API_URL set
   # It falls back to default in code
   ```

---

### 404 on Page Refresh

**Error:** Refreshing `/dashboard` gives 404

**Solutions:**
1. ✅ Ensure `netlify.toml` exists with redirects:
   ```toml
   [[redirects]]
     from = "/*"
     to = "/index.html"
     status = 200
   ```
2. ✅ Check `_redirects` file is in `dist/` after build
3. Redeploy after adding netlify.toml

---

### Blank Page

**Error:** Site loads but shows blank page

**Solutions:**
1. Check browser console for errors
2. Verify VITE_API_URL is set correctly
3. Check network tab - are API calls failing?
4. Verify build completed successfully
5. Check if build output is in correct directory

---

### Environment Variables Not Working

**Error:** API calls go to wrong URL

**Solutions:**
1. ✅ Environment variables must start with `VITE_`
2. ✅ Set in Netlify: Site settings → Environment variables
3. ✅ Redeploy after adding variables (build cache)
4. Check variable name spelling
5. Verify no trailing slashes in URLs

---

## 🔴 CORS Issues

### CORS Error in Browser

**Error:** `Access to XMLHttpRequest blocked by CORS policy`

**Solutions:**
1. ✅ Verify CLIENT_URL in Render matches Netlify URL exactly
   - Include `https://`
   - No trailing slash
   - Correct subdomain
2. ✅ Check backend CORS configuration includes frontend URL
3. ✅ Redeploy backend after changing CLIENT_URL
4. Clear browser cache
5. Check backend logs for CORS errors

---

## 🔴 Authentication Issues

### Login Fails

**Error:** Login request returns 401 or 500

**Solutions:**
1. Check JWT_SECRET is set on backend
2. Verify password hashing is working
3. Check database connection
4. Review backend logs
5. Verify user exists in database

---

### Session Not Persisting

**Error:** User logged out on refresh

**Solutions:**
1. ✅ Verify `withCredentials: true` in axios config
2. ✅ Check cookies are being set (Browser DevTools → Application → Cookies)
3. Ensure frontend and backend are on same domain (or configured for cross-origin cookies)
4. Check cookie settings in backend (httpOnly, secure, sameSite)

---

### Google OAuth Fails

**Error:** OAuth redirect fails or shows error

**Solutions:**
1. ✅ Verify GOOGLE_CALLBACK_URL matches exactly:
   ```
   https://your-backend.onrender.com/api/auth/google/callback
   ```
2. ✅ Add callback URL to Google Console authorized redirects
3. Check GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET
4. Ensure Google OAuth is enabled in Google Console
5. Check backend logs for OAuth errors

---

## 🔴 Database Issues

### Database Connection Limit

**Error:** `too many clients already`

**Solutions:**
1. Free tier PostgreSQL has connection limit
2. Add to DATABASE_URL:
   ```
   ?connection_limit=5
   ```
3. Ensure app properly closes connections
4. Consider connection pooling

---

### Data Not Persisting

**Error:** Data saves but disappears

**Solutions:**
1. Check if using correct database
2. Verify transactions are committing
3. Check for database errors in logs
4. Ensure migrations ran successfully

---

## 🔴 Performance Issues

### Slow API Responses

**Solutions:**
1. Check database query performance
2. Add indexes to frequently queried fields
3. Review Render metrics/logs
4. Consider upgrading from free tier
5. Check for N+1 query problems

---

### Large Bundle Size

**Solutions:**
1. Analyze build output
2. Use dynamic imports for large components
3. Remove unused dependencies
4. Enable tree-shaking
5. Consider code splitting

---

## 🔴 General Tips

### Debugging Steps

1. **Check logs first:**
   - Render: Dashboard → Your service → Logs
   - Netlify: Site → Deploys → Deploy log

2. **Verify environment variables:**
   - Print them in code (careful with secrets!)
   - Check spelling and format

3. **Test locally first:**
   - If it works locally, it's likely a config issue
   - If it fails locally, fix code first

4. **Use browser DevTools:**
   - Console for errors
   - Network tab for API calls
   - Application tab for cookies/storage

5. **Check service status:**
   - Render status: status.render.com
   - Netlify status: status.netlify.com

---

### Getting Help

**Before asking for help, gather:**
- Error messages (exact text)
- Relevant logs
- Steps to reproduce
- Environment details
- What you've tried

**Resources:**
- Render Docs: render.com/docs
- Netlify Docs: docs.netlify.com
- Prisma Docs: prisma.io/docs
- GitHub Issues: your-repo/issues

---

## 📋 Quick Health Check

Run through this when something isn't working:

**Backend:**
- [ ] Service is running (green in Render)
- [ ] Database is running
- [ ] All environment variables set
- [ ] Migrations completed
- [ ] No errors in logs

**Frontend:**
- [ ] Build succeeded
- [ ] Site is published
- [ ] VITE_API_URL is correct
- [ ] No errors in browser console

**Integration:**
- [ ] CLIENT_URL matches frontend URL
- [ ] Can access backend directly
- [ ] Can access frontend directly
- [ ] CORS configured correctly

---

Remember: Most deployment issues are configuration problems, not code problems! 🎯
