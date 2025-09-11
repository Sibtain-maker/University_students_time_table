# Immediate Email Testing Guide

## 🚀 **Quick Test Steps**

### **Step 1: Test the App Now**
1. **Run the app**: `flutter run`
2. **Sign up with a test email**
3. **Check the console output** for these messages:
   ```
   🔄 Attempting to send OTP to: your-email@gmail.com
   ✅ OTP request completed successfully
   📧 Email should be sent to: your-email@gmail.com
   ⚠️  Please check spam folder if not received
   ```

### **Step 2: Check Your Email**
- **Primary inbox** - Look for "University Timetable" or "Supabase"
- **Spam/Junk folder** - Most important to check!
- **Promotions tab** (Gmail) - Sometimes ends up there
- **Wait 5-10 minutes** - Email delivery can be delayed

### **Step 3: Development Mode Bypass**
If no email arrives, the app now shows a **development hint**:
- On the OTP screen, you'll see: `🛠️ Development Mode`
- **Try the code: 123456** to test the verification flow
- This helps test the app even without email delivery

### **Step 4: Console Error Checking**
Watch for these error patterns in console:

**✅ Success Pattern:**
```
🔄 Attempting to send OTP to: test@gmail.com
✅ OTP request completed successfully
```

**❌ Error Patterns:**
```
❌ Auth Exception: [error message]
📊 Status Code: [error code]
```

## 🔧 **Common Issues & Solutions**

### **Issue 1: Email Goes to Spam**
- **Solution**: Check spam folder thoroughly
- **Prevention**: Ask users to whitelist your domain

### **Issue 2: Supabase Rate Limiting**
- **Error**: "Too many requests"
- **Solution**: Wait 10-15 minutes between attempts
- **Prevention**: Use different email addresses for testing

### **Issue 3: SMTP Not Configured**
- **Error**: "SMTP configuration error"
- **Solution**: Configure custom SMTP in Supabase dashboard
- **Temporary**: Use development mode bypass

### **Issue 4: Email Template Issues**
- **Error**: Template rendering failures
- **Solution**: Use simple template without complex formatting
- **Test**: Send test email from Supabase dashboard

## 📧 **Supabase Email Debugging**

### **Quick Supabase Checks:**
1. **Go to Supabase Dashboard**
2. **Authentication > Users** - Check if users are being created
3. **Logs section** - Look for email sending attempts
4. **Settings > Authentication** - Verify email settings

### **Email Quota Check:**
- **Free tier**: Limited emails per day
- **Check usage**: Dashboard > Settings > Billing
- **Upgrade**: Consider Pro plan for reliable email delivery

## 🛠️ **Development Mode Testing**

The app now includes development mode features:

1. **Visual indicator** on OTP screen
2. **Test code provided**: 123456
3. **Console logging** for debugging
4. **Bypass email dependency** for development

**To disable development mode:**
- Edit `lib/core/constants/app_constants.dart`
- Change `isDevelopmentMode` to `false`

## 📱 **Testing Checklist**

Run through this checklist:

- [ ] App runs without errors
- [ ] Signup form validation works
- [ ] Console shows OTP sending attempts
- [ ] Check email inbox and spam
- [ ] Try development code if no email
- [ ] OTP verification screen loads
- [ ] Error messages are helpful
- [ ] Resend functionality works

## 🆘 **If Still No Emails**

### **Immediate Actions:**
1. **Use development code 123456** to test app flow
2. **Check Supabase dashboard logs** for errors
3. **Try different email provider** (Yahoo, Outlook)
4. **Contact Supabase support** if using paid plan

### **Alternative Solutions:**
1. **Configure custom SMTP** (SendGrid, Mailgun)
2. **Use SMS OTP** instead of email
3. **Implement magic link alternative**
4. **Use Firebase Auth** as backup

The app is now set up with comprehensive debugging and a development bypass, so you can test the complete flow even if email delivery has issues!