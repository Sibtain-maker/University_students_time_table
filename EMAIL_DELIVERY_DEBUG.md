# Email Delivery Debugging Guide

## 🚨 **Issue: No OTP Emails Being Received**

### **Step 1: Check Supabase Email Logs**

1. **Go to Supabase Dashboard**
   - Navigate to your project
   - Go to **Logs** section
   - Filter for **Auth logs**
   - Look for email sending attempts and errors

2. **Check Authentication Logs**
   - Go to **Authentication** → **Users**
   - Look for user creation attempts
   - Check if emails are being sent or failing

### **Step 2: Verify Email Configuration**

**A. SMTP Settings (Most Common Issue)**
- Go to **Settings** → **Authentication**
- Scroll down to **SMTP Settings**
- Check if custom SMTP is configured
- If using default Supabase SMTP, it may have delivery issues

**B. Email Rate Limits**
- Supabase free tier has email sending limits
- Check if you've exceeded daily/hourly limits
- Upgrade plan if necessary

**C. Domain Authentication**
- Check if your domain is properly authenticated
- SPF/DKIM records may need configuration

### **Step 3: Test Email Delivery**

**A. Check Different Email Providers**
- Test with different email addresses:
  - Gmail
  - Yahoo
  - Outlook
  - ProtonMail

**B. Check Spam/Junk Folders**
- OTP emails often end up in spam
- Check all spam folders thoroughly
- Mark as "Not Spam" if found

**C. Whitelist Supabase Domains**
- Add these domains to your email whitelist:
  - `*.supabase.co`
  - `noreply@mail.app.supabase.io`

### **Step 4: Common Supabase Email Issues**

**Issue 1: Free Tier Limitations**
- Supabase free tier has limited email sending
- Consider upgrading to Pro plan
- Or configure custom SMTP provider

**Issue 2: Email Template Issues**
- Malformed templates can cause delivery failure
- Verify template syntax is correct
- Test with minimal template first

**Issue 3: Rate Limiting**
- Too many signup attempts can trigger rate limits
- Wait 10-15 minutes between attempts
- Use different email addresses for testing

### **Step 5: Alternative Solutions**

**Option A: Custom SMTP Provider**
Configure a reliable email service:
- SendGrid
- Mailgun
- AWS SES
- Resend

**Option B: Development Mode**
For testing, we can implement a development bypass:
- Show OTP in console logs
- Use fixed test codes during development
- Switch to real emails in production

### **Step 6: Debugging Code Changes**

I'll add enhanced error logging to help identify the issue:

```dart
// Enhanced error handling in auth data source
try {
  await supabaseClient.auth.signInWithOtp(email: params.email);
  print('OTP request sent successfully for: ${params.email}');
} on AuthException catch (e) {
  print('Auth Exception: ${e.message}');
  print('Status Code: ${e.statusCode}');
  throw AuthFailure('Email sending failed: ${e.message}');
} catch (e) {
  print('General Exception: $e');
  throw AuthFailure('Email sending failed: $e');
}
```

### **Step 7: Quick Test Checklist**

- [ ] Check Supabase logs for email sending attempts
- [ ] Verify email isn't in spam folder
- [ ] Test with different email addresses
- [ ] Check Supabase email quota/limits
- [ ] Verify SMTP configuration
- [ ] Test email template syntax
- [ ] Check internet connectivity
- [ ] Verify Supabase project is active

### **Step 8: Immediate Troubleshooting**

1. **Try signing up with a different email**
2. **Check Supabase dashboard logs immediately after signup**
3. **Look for any error messages in the app console**
4. **Verify your Supabase project has email sending enabled**

If emails still don't arrive after these steps, we may need to:
- Configure a custom SMTP provider
- Implement a development bypass mode
- Use SMS OTP as an alternative

Let me know what you find in the Supabase logs and I'll help you resolve the specific issue!