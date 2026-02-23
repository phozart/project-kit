# User Guide Specification

Specification for generating end-user documentation with screenshot placeholders.

## Directory Structure

```
docs/
  user-guide/
    README.md
    getting-started.md
    user-journeys/
      create-order.md
      manage-inventory.md
      view-reports.md
    features/
      dashboard.md
      orders.md
      customers.md
    troubleshooting.md
    faq.md
    screenshots/
      (screenshot files)
```

## README.md Structure

```markdown
# User Guide

Welcome to [Project Name]! This guide will help you get started and make the most of all features.

## Table of Contents
- [Getting Started](getting-started.md)
- [User Journeys](user-journeys/)
- [Features](features/)
- [Troubleshooting](troubleshooting.md)
- [FAQ](faq.md)

## Quick Start
1. [Create an account](getting-started.md#create-account)
2. [Complete your profile](getting-started.md#complete-profile)
3. [Explore the dashboard](features/dashboard.md)

## Support
For additional help:
- Email: support@example.com
- Help Center: https://help.example.com
```

## getting-started.md Structure

```markdown
# Getting Started

## Create an Account

### Step 1: Navigate to Sign Up
1. Go to https://app.example.com
2. Click "Sign Up" in the top right corner

![Screenshot: Homepage with Sign Up button](screenshots/homepage-signup.png)

**Cowork Instructions:**
1. Open https://app.example.com in browser
2. Wait for page to load completely
3. Take full-screen screenshot
4. Highlight "Sign Up" button with red box
5. Save as screenshots/homepage-signup.png

### Step 2: Fill Registration Form
1. Enter your email address
2. Create a strong password (8+ characters)
3. Enter your full name
4. Click "Create Account"

![Screenshot: Registration form](screenshots/registration-form.png)

**Cowork Instructions:**
1. Click "Sign Up" button
2. Fill form with test data:
   - Email: demo@example.com
   - Password: DemoPass123!
   - Name: Demo User
3. Take screenshot before clicking "Create Account"
4. Save as screenshots/registration-form.png

### Step 3: Verify Email
1. Check your email inbox
2. Click the verification link
3. You'll be redirected to the login page

## First Login

### Step 1: Enter Credentials
1. Enter your email and password
2. Click "Login"

![Screenshot: Login page](screenshots/login-page.png)

### Step 2: Complete Profile
After first login, you'll be prompted to complete your profile.

1. Upload a profile picture (optional)
2. Enter your company name
3. Select your industry
4. Click "Save and Continue"

![Screenshot: Profile completion](screenshots/profile-completion.png)

## Dashboard Tour

After completing your profile, you'll see the main dashboard.

![Screenshot: Dashboard overview](screenshots/dashboard-overview.png)

Key areas:
1. **Navigation** (left sidebar): Access all features
2. **Overview Cards** (top): Key metrics at a glance
3. **Recent Activity** (middle): Latest updates
4. **Quick Actions** (right): Common tasks
```

## User Journey Format

```markdown
# User Journey: Create New Order

This guide walks you through creating a new order from start to finish.

**Estimated time:** 5 minutes

**Prerequisites:**
- Active account
- At least one customer in the system
- Products available in inventory

## Overview
1. Navigate to Orders
2. Start new order
3. Select customer
4. Add products
5. Review and submit

## Step-by-Step Instructions

### Step 1: Navigate to Orders
1. Click "Orders" in the left sidebar
2. The orders list page displays

![Screenshot: Orders list page](screenshots/orders-list.png)

**Cowork Instructions:**
1. Log in to the application
2. Click "Orders" in sidebar
3. Wait for page to load
4. Take full-screen screenshot
5. Save as screenshots/orders-list.png

**What you'll see:**
- List of existing orders
- "Create Order" button in top right
- Filter and search options

### Step 2: Start New Order
1. Click the "Create Order" button in the top right
2. A new order form appears

![Screenshot: Empty order form](screenshots/order-form-empty.png)

### Step 3: Select Customer
1. Click the "Customer" dropdown
2. Search for the customer by name or email
3. Select the customer from the list

![Screenshot: Customer selection dropdown](screenshots/order-customer-select.png)

**Cowork Instructions:**
1. Click "Customer" dropdown
2. Type "demo" in search field
3. Take screenshot with dropdown open
4. Highlight dropdown with red box
5. Save as screenshots/order-customer-select.png

**Tip:** If the customer doesn't exist, click "Add New Customer" at the bottom of the dropdown.

### Step 4: Add Products

#### 4.1: Search for Product
1. In the "Products" section, click "Add Product"
2. A product search dialog appears
3. Type the product name or SKU
4. Select the product from results

![Screenshot: Product search dialog](screenshots/product-search-dialog.png)

#### 4.2: Set Quantity
1. Enter the quantity needed
2. The line total calculates automatically
3. Click "Add to Order"

![Screenshot: Product quantity entry](screenshots/product-quantity-entry.png)

#### 4.3: Add More Products (Optional)
Repeat steps 4.1-4.2 to add additional products.

![Screenshot: Order with multiple products](screenshots/order-multiple-products.png)

### Step 5: Review Order
Before submitting, review the order details:

- Customer information
- All products and quantities
- Line totals
- Order total

![Screenshot: Order review](screenshots/order-review.png)

**Check for:**
- Correct customer selected
- Accurate product quantities
- Expected total amount

### Step 6: Submit Order
1. Click "Create Order" button at the bottom
2. A confirmation message appears
3. You're redirected to the order details page

![Screenshot: Order confirmation](screenshots/order-confirmation.png)

**Success indicators:**
- Green success message
- Order number assigned
- Status shows as "Pending"

## What's Next?

After creating an order:
- View order details
- Process payment
- Track fulfillment status
- Generate invoice

**Related guides:**
- [Process Payments](process-payment.md)
- [Track Orders](track-orders.md)
- [Generate Invoices](generate-invoice.md)

## Troubleshooting

**Problem:** "Customer not found"
- **Solution:** Create the customer first in Customers section

**Problem:** "Product out of stock"
- **Solution:** Check inventory levels in Products section

**Problem:** Order total doesn't match expected
- **Solution:** Verify product quantities and unit prices
```

## Screenshot Placeholder Format

Always use this consistent format:

```markdown
![Screenshot: Brief description](screenshots/filename.png)

**Cowork Instructions:**
1. [Navigation step]
2. [Interaction step]
3. [Screenshot step with specific dimensions/zoom if needed]
4. [Annotation step if highlights needed]
5. Save as screenshots/filename.png

**Additional context (optional):**
- Browser: Chrome
- Screen size: 1920x1080
- Zoom: 100%
```

## troubleshooting.md Structure

```markdown
# Troubleshooting

Common issues and solutions.

## Login Issues

### Cannot Login
**Symptoms:** "Invalid credentials" error message

**Solutions:**
1. Verify email address is correct
2. Check caps lock is off
3. Reset password if needed
4. Clear browser cache and try again

### Forgot Password
[Instructions for password reset]

## Feature Issues

### Order Creation Fails
[Troubleshooting steps]
```

## faq.md Structure

```markdown
# Frequently Asked Questions

## General

**Q: Is there a mobile app?**
A: Currently, the application is web-based and mobile-responsive. Access it from any device browser.

**Q: How do I export data?**
A: Click the export button on any list view to download data as CSV or Excel.

## Account

**Q: Can I change my email address?**
A: Yes, go to Settings > Account and update your email.
```
