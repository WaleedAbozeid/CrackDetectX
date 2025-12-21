# CrackDetectX - Complete Flutter Design Specifications

## 📱 App Overview
**CrackDetectX** is a professional AI-powered building inspection mobile application that enables users to upload building images for AI analysis to detect cracks, structural risks, and potential damages. The app connects building owners with certified engineering companies through an integrated marketplace.

---

## 🎨 Design System

### Color Palette

#### Primary Colors
```dart
// Light Mode
const Color primaryDark = Color(0xFF1E3A8A);      // Dark Blue - Main brand color
const Color primaryLight = Color(0xFF3B82F6);     // Light Blue - Accents
const Color primaryWhite = Color(0xFFFFFFFF);     // White - Background
const Color textPrimary = Color(0xFF1F2937);      // Dark Gray - Primary text
const Color textSecondary = Color(0xFF6B7280);    // Medium Gray - Secondary text
const Color backgroundLight = Color(0xFFF9FAFB);  // Light Gray - Card backgrounds
const Color borderLight = Color(0xFFE5E7EB);      // Light border

// Dark Mode
const Color darkBackground = Color(0xFF111827);    // Dark background
const Color darkCard = Color(0xFF1F2937);          // Dark card background
const Color darkBorder = Color(0xFF374151);        // Dark border
const Color darkText = Color(0xFFF9FAFB);          // Light text
```

#### Semantic Colors
```dart
// Risk Levels
const Color riskLow = Color(0xFF10B981);          // Green
const Color riskModerate = Color(0xFFF59E0B);     // Orange
const Color riskHigh = Color(0xFFEF4444);         // Red
const Color riskCritical = Color(0xFF991B1B);     // Dark Red

// Status Colors
const Color success = Color(0xFF10B981);          // Success green
const Color warning = Color(0xFFF59E0B);          // Warning orange
const Color error = Color(0xFFEF4444);            // Error red
const Color info = Color(0xFF3B82F6);             // Info blue

// AI Scanning Animation
const Color aiScanBlue = Color(0xFF60A5FA);       // Bright blue for scanning effect
const Color aiScanCyan = Color(0xFF06B6D4);       // Cyan for gradient
```

### Typography

```dart
// Font Family: Inter (recommended) or Poppins
// Arabic: Cairo or Tajawal

// Headings
TextStyle h1 = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  letterSpacing: -0.5,
);

TextStyle h2 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  letterSpacing: -0.3,
);

TextStyle h3 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

TextStyle h4 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

// Body Text
TextStyle bodyLarge = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

TextStyle bodyMedium = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
);

TextStyle bodySmall = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.normal,
);

// Special
TextStyle caption = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: textSecondary,
);

TextStyle button = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.5,
);
```

### Spacing System

```dart
// Consistent spacing scale
const double space4 = 4.0;
const double space8 = 8.0;
const double space12 = 12.0;
const double space16 = 16.0;
const double space20 = 20.0;
const double space24 = 24.0;
const double space32 = 32.0;
const double space40 = 40.0;
const double space48 = 48.0;
const double space64 = 64.0;
```

### Border Radius

```dart
// Rounded corners
const double radiusSmall = 8.0;
const double radiusMedium = 12.0;
const double radiusLarge = 16.0;
const double radiusXLarge = 24.0;
const double radiusFull = 9999.0;  // For circular elements
```

### Shadows

```dart
// Soft shadows for modern UI
BoxShadow shadowSmall = BoxShadow(
  color: Colors.black.withOpacity(0.05),
  blurRadius: 4,
  offset: Offset(0, 2),
);

BoxShadow shadowMedium = BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 8,
  offset: Offset(0, 4),
);

BoxShadow shadowLarge = BoxShadow(
  color: Colors.black.withOpacity(0.1),
  blurRadius: 16,
  offset: Offset(0, 8),
);

// AI glow effect
BoxShadow aiGlow = BoxShadow(
  color: aiScanBlue.withOpacity(0.3),
  blurRadius: 20,
  offset: Offset(0, 0),
);
```

---

## 📐 Component Library

### 1. Buttons

#### Primary Button
```dart
Container(
  width: double.infinity,
  height: 56,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryDark, primaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(radiusMedium),
    boxShadow: [shadowMedium],
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(radiusMedium),
      onTap: onPressed,
      child: Center(
        child: Text('Button Text', style: button.copyWith(color: Colors.white)),
      ),
    ),
  ),
)
```

#### Secondary Button
```dart
Container(
  width: double.infinity,
  height: 56,
  decoration: BoxDecoration(
    border: Border.all(color: primaryLight, width: 2),
    borderRadius: BorderRadius.circular(radiusMedium),
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(radiusMedium),
      onTap: onPressed,
      child: Center(
        child: Text('Button Text', style: button.copyWith(color: primaryLight)),
      ),
    ),
  ),
)
```

#### Icon Button
```dart
Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    color: backgroundLight,
    borderRadius: BorderRadius.circular(radiusSmall),
  ),
  child: IconButton(
    icon: Icon(Icons.icon_name, color: primaryDark),
    onPressed: onPressed,
  ),
)
```

### 2. Cards

#### Standard Card
```dart
Container(
  padding: EdgeInsets.all(space16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: [shadowMedium],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Card content
    ],
  ),
)
```

#### Scan Result Card
```dart
Container(
  padding: EdgeInsets.all(space20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: [shadowLarge],
    border: Border.all(color: borderLight, width: 1),
  ),
  child: Column(
    children: [
      // Building image
      ClipRRect(
        borderRadius: BorderRadius.circular(radiusMedium),
        child: Image.network(imageUrl, height: 200, fit: BoxFit.cover),
      ),
      SizedBox(height: space16),
      // Health score with circular progress
      // Risk level badge
      // Details button
    ],
  ),
)
```

### 3. Input Fields

```dart
Container(
  decoration: BoxDecoration(
    color: backgroundLight,
    borderRadius: BorderRadius.circular(radiusMedium),
    border: Border.all(color: borderLight, width: 1),
  ),
  child: TextField(
    decoration: InputDecoration(
      hintText: 'Placeholder text',
      hintStyle: bodyMedium.copyWith(color: textSecondary),
      prefixIcon: Icon(Icons.icon_name, color: textSecondary),
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
        horizontal: space16,
        vertical: space16,
      ),
    ),
  ),
)
```

### 4. Risk Level Badge

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: space12, vertical: space8),
  decoration: BoxDecoration(
    color: getRiskColor(riskLevel).withOpacity(0.1),
    borderRadius: BorderRadius.circular(radiusFull),
    border: Border.all(color: getRiskColor(riskLevel), width: 1.5),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: getRiskColor(riskLevel),
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: space8),
      Text(
        riskText,
        style: bodySmall.copyWith(
          color: getRiskColor(riskLevel),
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
)
```

### 5. Health Score Circle

```dart
Stack(
  alignment: Alignment.center,
  children: [
    SizedBox(
      width: 120,
      height: 120,
      child: CircularProgressIndicator(
        value: healthScore / 100,
        strokeWidth: 12,
        backgroundColor: backgroundLight,
        valueColor: AlwaysStoppedAnimation<Color>(getScoreColor(healthScore)),
      ),
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${healthScore.toInt()}',
          style: h1.copyWith(color: primaryDark),
        ),
        Text(
          'Health Score',
          style: caption,
        ),
      ],
    ),
  ],
)
```

### 6. Tab Bar (Custom)

```dart
Container(
  padding: EdgeInsets.all(space4),
  decoration: BoxDecoration(
    color: backgroundLight,
    borderRadius: BorderRadius.circular(radiusMedium),
  ),
  child: Row(
    children: tabs.map((tab) {
      final isSelected = currentTab == tab;
      return Expanded(
        child: GestureDetector(
          onTap: () => onTabChanged(tab),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: space12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(radiusSmall),
              boxShadow: isSelected ? [shadowSmall] : [],
            ),
            child: Center(
              child: Text(
                tab,
                style: bodyMedium.copyWith(
                  color: isSelected ? primaryDark : textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList(),
  ),
)
```

### 7. Bottom Navigation Bar

```dart
BottomNavigationBar(
  currentIndex: currentIndex,
  onTap: onIndexChanged,
  type: BottomNavigationBarType.fixed,
  backgroundColor: Colors.white,
  selectedItemColor: primaryLight,
  unselectedItemColor: textSecondary,
  selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.scanner_outlined),
      activeIcon: Icon(Icons.scanner),
      label: 'Scan',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.description_outlined),
      activeIcon: Icon(Icons.description),
      label: 'Reports',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.store_outlined),
      activeIcon: Icon(Icons.store),
      label: 'Marketplace',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
)
```

---

## 📱 Screen Specifications

### 1. Splash Screen
**Duration:** 2-3 seconds  
**Components:**
- App logo (centered)
- App name "CrackDetectX" with gradient text
- Loading indicator at bottom
- Background: Gradient from primaryDark to primaryLight

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [primaryDark, primaryLight],
    ),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // App icon/logo
      Icon(Icons.construction, size: 120, color: Colors.white),
      SizedBox(height: space24),
      ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.white, Colors.white70],
        ).createShader(bounds),
        child: Text('CrackDetectX', style: h1.copyWith(fontSize: 36)),
      ),
      SizedBox(height: space8),
      Text(
        'AI-Powered Building Inspector',
        style: bodyMedium.copyWith(color: Colors.white70),
      ),
      SizedBox(height: space64),
      CircularProgressIndicator(color: Colors.white),
    ],
  ),
)
```

### 2. Onboarding Screen (3 Pages)
**Features:**
- Swipeable pages with PageView
- Dot indicators
- Skip button (top right)
- Next/Get Started button

**Page 1: Welcome**
- Illustration: Building with AI scan overlay
- Title: "Welcome to CrackDetectX"
- Subtitle: "AI-powered building inspection at your fingertips"

**Page 2: AI Analysis**
- Illustration: AI analyzing cracks
- Title: "Advanced AI Detection"
- Subtitle: "Detect cracks and structural risks instantly"

**Page 3: Marketplace**
- Illustration: Engineers/Companies
- Title: "Connect with Experts"
- Subtitle: "Get quotes from certified engineering companies"

### 3. Login Screen
**Components:**
- Logo at top
- Email input field
- Password input field (with show/hide toggle)
- "Forgot Password?" link
- Login button
- "Don't have an account? Sign up" link
- Social login options (Google, Apple) - optional

**Layout:**
```dart
SafeArea(
  child: Padding(
    padding: EdgeInsets.all(space24),
    child: Column(
      children: [
        SizedBox(height: space48),
        // Logo
        Icon(Icons.construction, size: 80, color: primaryDark),
        SizedBox(height: space16),
        Text('CrackDetectX', style: h2),
        Text('Sign in to continue', style: bodyMedium.copyWith(color: textSecondary)),
        SizedBox(height: space48),
        // Email input
        // Password input
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            child: Text('Forgot Password?'),
            onPressed: () {},
          ),
        ),
        SizedBox(height: space24),
        // Login button
        SizedBox(height: space24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account? ", style: bodyMedium),
            TextButton(
              child: Text('Sign Up', style: bodyMedium.copyWith(color: primaryLight, fontWeight: FontWeight.w600)),
              onPressed: () {},
            ),
          ],
        ),
      ],
    ),
  ),
)
```

### 4. Register Screen
**Components:**
- Full Name input
- Email input
- Phone input
- Password input (with strength indicator)
- Confirm Password input
- Terms & Conditions checkbox
- Register button
- "Already have an account? Login" link

### 5. Home Dashboard
**Sections:**

**A. Header**
- User avatar (left/right based on RTL)
- Greeting: "Welcome Back, [Name]"
- Notification icon
- Settings icon

**B. Quick Stats Cards (Horizontal Row)**
- Total Scans
- Buildings Monitored
- Reports Generated

```dart
Row(
  children: [
    Expanded(
      child: Container(
        padding: EdgeInsets.all(space16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [primaryDark, primaryLight]),
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('24', style: h2.copyWith(color: Colors.white)),
            SizedBox(height: space4),
            Text('Total Scans', style: bodySmall.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    ),
    SizedBox(width: space12),
    // Repeat for other stats
  ],
)
```

**C. Quick Actions (Grid 2x2)**
- New Scan (primary button with gradient)
- View Reports
- My Projects
- Find Engineers

**D. Recent Scans (Vertical List)**
- Card with:
  - Building thumbnail
  - Building name/location
  - Health score badge
  - Risk level badge
  - Date
  - Arrow to view details

### 6. Upload Screen
**Components:**

**A. Drag & Drop Zone**
```dart
DottedBorder(
  borderType: BorderType.RRect,
  radius: Radius.circular(radiusLarge),
  dashPattern: [8, 4],
  color: primaryLight,
  strokeWidth: 2,
  child: Container(
    height: 300,
    width: double.infinity,
    decoration: BoxDecoration(
      color: primaryLight.withOpacity(0.05),
      borderRadius: BorderRadius.circular(radiusLarge),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 80, color: primaryLight),
        SizedBox(height: space16),
        Text('Drag & drop your image here', style: h4),
        SizedBox(height: space8),
        Text('or', style: bodyMedium.copyWith(color: textSecondary)),
        SizedBox(height: space16),
        ElevatedButton(
          child: Text('Choose File'),
          onPressed: () {},
        ),
        SizedBox(height: space24),
        Text('Supported formats: JPG, PNG, HEIC', style: caption),
        Text('Max size: 10MB', style: caption),
      ],
    ),
  ),
)
```

**B. Uploaded Images Preview**
- Grid of thumbnails
- Remove icon on each
- Add more button

**C. Building Details Form**
- Location input
- Building type dropdown
- Additional notes textarea

**D. Start Analysis Button** (fixed at bottom)

### 7. AI Scanning Screen
**Components:**

**A. Animated Scanning Effect**
```dart
Stack(
  alignment: Alignment.center,
  children: [
    // Building image with scan overlay
    Image.network(imageUrl),
    // Animated scan line
    AnimatedBuilder(
      animation: scanAnimation,
      builder: (context, child) {
        return Positioned(
          top: scanAnimation.value * imageHeight,
          left: 0,
          right: 0,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  aiScanBlue,
                  aiScanCyan,
                  aiScanBlue,
                  Colors.transparent,
                ],
              ),
              boxShadow: [aiGlow],
            ),
          ),
        );
      },
    ),
    // Detected crack overlays (appear as scanning progresses)
    ...detectedCracks.map((crack) {
      return Positioned(
        left: crack.x,
        top: crack.y,
        child: Container(
          width: crack.width,
          height: crack.height,
          decoration: BoxDecoration(
            border: Border.all(color: riskHigh, width: 2),
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
        ),
      );
    }),
  ],
)
```

**B. Progress Indicator**
```dart
Column(
  children: [
    LinearProgressIndicator(
      value: progress,
      backgroundColor: backgroundLight,
      color: primaryLight,
      minHeight: 8,
    ),
    SizedBox(height: space16),
    Text('${(progress * 100).toInt()}%', style: h3),
  ],
)
```

**C. Status Messages (Animated)**
- "Analyzing image..."
- "Detecting cracks..."
- "Calculating risk level..."
- "Generating report..."

### 8. Results Screen
**Sections:**

**A. Header**
- Back button
- "Analysis Results" title
- Share icon
- Save icon

**B. Overall Health Card**
```dart
Container(
  padding: EdgeInsets.all(space24),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryDark, primaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(radiusXLarge),
    boxShadow: [shadowLarge],
  ),
  child: Column(
    children: [
      Text('Overall Health', style: h3.copyWith(color: Colors.white)),
      SizedBox(height: space24),
      // Health Score Circle (white version)
      SizedBox(height: space24),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text('12', style: h2.copyWith(color: Colors.white)),
              Text('Cracks Found', style: caption.copyWith(color: Colors.white70)),
            ],
          ),
          Container(width: 1, height: 40, color: Colors.white30),
          Column(
            children: [
              Text('15%', style: h2.copyWith(color: Colors.white)),
              Text('Crack %', style: caption.copyWith(color: Colors.white70)),
            ],
          ),
        ],
      ),
    ],
  ),
)
```

**C. Risk Level Badge** (large, centered)

**D. Detailed Findings**
- Tabs: All, Major Cracks, Minor Cracks, Surface Damage
- List of findings with:
  - Thumbnail of crack area
  - Description
  - Severity indicator
  - Location coordinates

**E. Recommendations Section**
- Card with icon and text for each recommendation
- Color-coded by priority

**F. Action Buttons**
- "View Full Report" (primary)
- "Publish to Marketplace" (secondary with icon)
- "Save Report" (secondary)

### 9. Detailed Report Screen
**Sections:**

**A. Building Information Card**
- Location with map icon
- Building type
- Scan date
- Inspector name

**B. AI Analysis Summary**
- Health score
- Total cracks
- Crack percentage
- Structural integrity assessment

**C. Crack Distribution Chart**
```dart
// Pie chart or bar chart showing:
// - Horizontal cracks
// - Vertical cracks
// - Diagonal cracks
// Use fl_chart package
```

**D. Severity Distribution Chart**
```dart
// Bar chart showing:
// - Critical
// - High
// - Moderate
// - Low
```

**E. Crack Details Table**
```dart
DataTable(
  columns: [
    DataColumn(label: Text('ID')),
    DataColumn(label: Text('Type')),
    DataColumn(label: Text('Severity')),
    DataColumn(label: Text('Location')),
  ],
  rows: cracks.map((crack) {
    return DataRow(cells: [
      DataCell(Text(crack.id)),
      DataCell(Text(crack.type)),
      DataCell(RiskBadge(level: crack.severity)),
      DataCell(Text(crack.location)),
    ]);
  }).toList(),
)
```

**F. Image Gallery**
- Original image
- Annotated image with crack overlays
- Close-up images of major cracks

**G. Expert Recommendations**
- Detailed list with priority levels

**H. Action Buttons (Bottom)**
- Download PDF
- Share Report
- Print

### 10. History Screen
**Components:**

**A. Filters**
- Tabs: All Scans, This Month, Last 3 Months, This Year
- Sort dropdown: Date, Health Score, Risk Level

**B. Summary Statistics**
```dart
Row(
  children: [
    Expanded(
      child: StatCard(
        title: 'Total Scans',
        value: '24',
        icon: Icons.scanner,
      ),
    ),
    Expanded(
      child: StatCard(
        title: 'Avg Health',
        value: '78%',
        icon: Icons.health_and_safety,
      ),
    ),
  ],
)
```

**C. Scan History List**
- Each item shows:
  - Building thumbnail
  - Building name
  - Scan date
  - Health score progress bar
  - Risk level badge
  - Tap to view details

### 11. Profile Screen
**Sections:**

**A. Profile Header**
```dart
Container(
  padding: EdgeInsets.all(space24),
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [primaryDark, primaryLight]),
  ),
  child: Column(
    children: [
      CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: 50, color: primaryDark),
      ),
      SizedBox(height: space16),
      Text('Walid Abouzeid', style: h3.copyWith(color: Colors.white)),
      Text('walid@example.com', style: bodyMedium.copyWith(color: Colors.white70)),
      SizedBox(height: space16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified, color: success, size: 20),
          SizedBox(width: space4),
          Text('Verified User', style: bodySmall.copyWith(color: Colors.white)),
        ],
      ),
    ],
  ),
)
```

**B. Statistics Cards**
- Total Scans
- Buildings Monitored
- Reports Generated
- Member Since

**C. Menu Items**
```dart
ListTile(
  leading: Container(
    padding: EdgeInsets.all(space8),
    decoration: BoxDecoration(
      color: primaryLight.withOpacity(0.1),
      borderRadius: BorderRadius.circular(radiusSmall),
    ),
    child: Icon(Icons.edit, color: primaryLight),
  ),
  title: Text('Edit Profile'),
  trailing: Icon(Icons.chevron_right),
  onTap: () {},
)
```

Menu items:
- Edit Profile
- Change Password
- Notifications Settings
- Language & Region
- Privacy & Security
- Help & Support
- About CrackDetectX
- Logout (in red)

### 12. Settings Screen
**Sections:**

**A. Account Settings**
- Edit Profile
- Change Password
- Delete Account

**B. App Preferences**
- Language selector
  ```dart
  ListTile(
    title: Text('Language'),
    trailing: DropdownButton<String>(
      value: currentLanguage,
      items: [
        DropdownMenuItem(value: 'ar', child: Text('العربية')),
        DropdownMenuItem(value: 'en', child: Text('English')),
      ],
      onChanged: (value) {},
    ),
  )
  ```
- Theme toggle
  ```dart
  SwitchListTile(
    title: Text('Dark Mode'),
    subtitle: Text('Switch between light and dark theme'),
    value: isDarkMode,
    onChanged: (value) {},
    activeColor: primaryLight,
  )
  ```

**C. Scan Settings**
- Auto-save scans
- High quality mode
- Notification preferences

**D. Privacy & Security**
- Data storage location
- Clear cache
- Privacy policy link
- Terms & conditions link

**E. About**
- App version
- Contact support
- Rate app
- Follow on social media

---

## 🏪 Marketplace Screens

### 13. Marketplace Home
**Sections:**

**A. Header**
- "Engineering Marketplace" title
- Search bar
- Filter icon

**B. User Role Toggle**
```dart
Container(
  padding: EdgeInsets.all(space4),
  decoration: BoxDecoration(
    color: backgroundLight,
    borderRadius: BorderRadius.circular(radiusMedium),
  ),
  child: Row(
    children: [
      Expanded(
        child: RoleTab(
          title: 'Building Owner',
          icon: Icons.home,
          isSelected: role == 'owner',
          onTap: () => setRole('owner'),
        ),
      ),
      Expanded(
        child: RoleTab(
          title: 'Engineering Company',
          icon: Icons.engineering,
          isSelected: role == 'company',
          onTap: () => setRole('company'),
        ),
      ),
    ],
  ),
)
```

**C. For Building Owners:**
- "Create New Listing" button
- My Active Listings (count badge)
- Received Offers (count badge)
- Browse Companies

**D. For Companies:**
- Company Dashboard stats
- Browse Requests
- My Offers
- Active Projects

### 14. Create Project Listing Screen (Building Owner)
**Form Fields:**

```dart
Form(
  child: ListView(
    padding: EdgeInsets.all(space20),
    children: [
      // Project Title
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Project Title',
          hintText: 'e.g., Structural repair for residential building',
          prefixIcon: Icon(Icons.title),
        ),
      ),
      SizedBox(height: space16),
      
      // Description
      TextFormField(
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'Description',
          hintText: 'Describe the issue and project requirements...',
          alignedLabelStyle: true,
        ),
      ),
      SizedBox(height: space24),
      
      // Building Details Section
      Text('Building Details', style: h4),
      SizedBox(height: space16),
      
      Row(
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Building Age',
                suffixText: 'years',
              ),
            ),
          ),
          SizedBox(width: space12),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Floors',
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: space16),
      
      Row(
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Area',
                suffixText: 'sqm',
              ),
            ),
          ),
          SizedBox(width: space12),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Budget',
                prefixText: 'EGP ',
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: space24),
      
      // Timeline
      Text('Timeline', style: h4),
      SizedBox(height: space12),
      Wrap(
        spacing: space8,
        children: [
          ChoiceChip(
            label: Text('Urgent (7 days)'),
            selected: timeline == 'urgent',
            onSelected: (selected) => setTimeline('urgent'),
          ),
          ChoiceChip(
            label: Text('1 Month'),
            selected: timeline == '1month',
            onSelected: (selected) => setTimeline('1month'),
          ),
          ChoiceChip(
            label: Text('3 Months'),
            selected: timeline == '3months',
            onSelected: (selected) => setTimeline('3months'),
          ),
          ChoiceChip(
            label: Text('Flexible'),
            selected: timeline == 'flexible',
            onSelected: (selected) => setTimeline('flexible'),
          ),
        ],
      ),
      SizedBox(height: space24),
      
      // Attach Scan Report
      Card(
        child: ListTile(
          leading: Icon(Icons.attach_file, color: primaryLight),
          title: Text('Attach Scan Report'),
          subtitle: Text(selectedReport ?? 'Select a report from your history'),
          trailing: Icon(Icons.chevron_right),
          onTap: () => showReportSelector(),
        ),
      ),
      SizedBox(height: space24),
      
      // Services Needed
      Text('Services Needed', style: h4),
      SizedBox(height: space12),
      CheckboxListTile(
        title: Text('Structural Assessment'),
        value: services.contains('assessment'),
        onChanged: (value) => toggleService('assessment'),
      ),
      CheckboxListTile(
        title: Text('Repair Works'),
        value: services.contains('repair'),
        onChanged: (value) => toggleService('repair'),
      ),
      CheckboxListTile(
        title: Text('Consultation'),
        value: services.contains('consultation'),
        onChanged: (value) => toggleService('consultation'),
      ),
      CheckboxListTile(
        title: Text('Monitoring'),
        value: services.contains('monitoring'),
        onChanged: (value) => toggleService('monitoring'),
      ),
      SizedBox(height: space32),
      
      // Publish Button
      ElevatedButton(
        onPressed: publishListing,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: space16),
        ),
        child: Text('Publish Listing'),
      ),
    ],
  ),
)
```

### 15. Browse Companies Screen
**Components:**

**A. Search & Filters**
```dart
Column(
  children: [
    // Search bar
    TextField(
      decoration: InputDecoration(
        hintText: 'Search companies...',
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Icon(Icons.tune),
          onPressed: () => showFilterSheet(),
        ),
      ),
    ),
    SizedBox(height: space16),
    
    // Active filters chips
    if (activeFilters.isNotEmpty)
      SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: activeFilters.length + 1,
          separatorBuilder: (context, index) => SizedBox(width: space8),
          itemBuilder: (context, index) {
            if (index == activeFilters.length) {
              return ActionChip(
                label: Text('Clear All'),
                onPressed: clearFilters,
              );
            }
            return FilterChip(
              label: Text(activeFilters[index]),
              onDeleted: () => removeFilter(activeFilters[index]),
            );
          },
        ),
      ),
  ],
)
```

**B. Filter Bottom Sheet**
```dart
// Shows when filter icon tapped
Container(
  padding: EdgeInsets.all(space20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Filter By', style: h3),
      SizedBox(height: space24),
      
      // Rating filter
      Text('Rating', style: h4),
      Wrap(
        spacing: space8,
        children: [
          FilterChip(label: Text('All'), selected: rating == null),
          FilterChip(label: Text('4+ stars'), selected: rating == 4),
          FilterChip(label: Text('4.5+ stars'), selected: rating == 4.5),
        ],
      ),
      SizedBox(height: space24),
      
      // Experience filter
      Text('Experience', style: h4),
      Wrap(
        spacing: space8,
        children: [
          FilterChip(label: Text('All'), selected: experience == null),
          FilterChip(label: Text('5+ years'), selected: experience == 5),
          FilterChip(label: Text('10+ years'), selected: experience == 10),
          FilterChip(label: Text('15+ years'), selected: experience == 15),
        ],
      ),
      SizedBox(height: space24),
      
      // Location filter
      Text('Location', style: h4),
      DropdownButton<String>(
        value: selectedLocation,
        isExpanded: true,
        items: [
          DropdownMenuItem(value: null, child: Text('All Locations')),
          DropdownMenuItem(value: 'cairo', child: Text('Cairo')),
          DropdownMenuItem(value: 'giza', child: Text('Giza')),
          DropdownMenuItem(value: 'alex', child: Text('Alexandria')),
        ],
        onChanged: (value) => setLocation(value),
      ),
      SizedBox(height: space32),
      
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: clearFilters,
              child: Text('Clear'),
            ),
          ),
          SizedBox(width: space12),
          Expanded(
            child: ElevatedButton(
              onPressed: applyFilters,
              child: Text('Apply'),
            ),
          ),
        ],
      ),
    ],
  ),
)
```

**C. Company Cards List**
```dart
ListView.separated(
  itemCount: companies.length,
  separatorBuilder: (context, index) => SizedBox(height: space12),
  itemBuilder: (context, index) {
    final company = companies[index];
    return Card(
      child: InkWell(
        onTap: () => navigateToCompanyProfile(company),
        child: Padding(
          padding: EdgeInsets.all(space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Company logo
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(company.logo),
                  ),
                  SizedBox(width: space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(company.name, style: h4),
                            if (company.verified)
                              Padding(
                                padding: EdgeInsets.only(left: space4),
                                child: Icon(Icons.verified, color: success, size: 20),
                              ),
                          ],
                        ),
                        SizedBox(height: space4),
                        Row(
                          children: [
                            Icon(Icons.star, color: warning, size: 16),
                            SizedBox(width: space4),
                            Text('${company.rating} (${company.reviews} reviews)', style: bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (company.topRated)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: space8, vertical: space4),
                      decoration: BoxDecoration(
                        color: warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(radiusFull),
                      ),
                      child: Text('Top Rated', style: caption.copyWith(color: warning)),
                    ),
                ],
              ),
              SizedBox(height: space12),
              Text(
                company.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: bodyMedium.copyWith(color: textSecondary),
              ),
              SizedBox(height: space12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: textSecondary),
                  SizedBox(width: space4),
                  Text(company.location, style: bodySmall),
                  SizedBox(width: space16),
                  Icon(Icons.work, size: 16, color: textSecondary),
                  SizedBox(width: space4),
                  Text('${company.completedProjects} projects', style: bodySmall),
                ],
              ),
              SizedBox(height: space12),
              Wrap(
                spacing: space8,
                children: company.specializations.take(3).map((spec) {
                  return Chip(
                    label: Text(spec, style: caption),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  },
)
```

### 16. Company Profile Screen
**Sections:**

**A. Header**
```dart
Container(
  padding: EdgeInsets.all(space24),
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [primaryDark, primaryLight]),
  ),
  child: Column(
    children: [
      CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(company.logo),
      ),
      SizedBox(height: space16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(company.name, style: h3.copyWith(color: Colors.white)),
          if (company.verified)
            Padding(
              padding: EdgeInsets.only(left: space8),
              child: Icon(Icons.verified, color: success, size: 24),
            ),
        ],
      ),
      SizedBox(height: space8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star, color: warning, size: 20),
          SizedBox(width: space4),
          Text(
            '${company.rating} (${company.reviews} reviews)',
            style: bodyMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    ],
  ),
)
```

**B. Quick Stats**
```dart
Container(
  padding: EdgeInsets.all(space16),
  child: Row(
    children: [
      Expanded(
        child: StatCard(
          icon: Icons.check_circle,
          value: '${company.completedProjects}',
          label: 'Projects',
        ),
      ),
      Expanded(
        child: StatCard(
          icon: Icons.access_time,
          value: '${company.avgResponseTime}h',
          label: 'Response Time',
        ),
      ),
      Expanded(
        child: StatCard(
          icon: Icons.thumb_up,
          value: '${company.successRate}%',
          label: 'Success Rate',
        ),
      ),
    ],
  ),
)
```

**C. About Section**
- Company description
- Years in business
- Team size
- Service areas

**D. Specializations**
```dart
Wrap(
  spacing: space8,
  runSpacing: space8,
  children: company.specializations.map((spec) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: space12, vertical: space8),
      decoration: BoxDecoration(
        color: primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radiusFull),
        border: Border.all(color: primaryLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, color: primaryLight, size: 16),
          SizedBox(width: space4),
          Text(spec, style: bodySmall.copyWith(color: primaryDark)),
        ],
      ),
    );
  }).toList(),
)
```

**E. Certifications**
- Grid of certification badges

**F. Recent Projects**
```dart
SizedBox(
  height: 200,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: recentProjects.length,
    separatorBuilder: (context, index) => SizedBox(width: space12),
    itemBuilder: (context, index) {
      final project = recentProjects[index];
      return Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radiusLarge),
          boxShadow: [shadowMedium],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radiusLarge),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(project.image, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
              ),
              Positioned(
                bottom: space16,
                left: space16,
                right: space16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: h4.copyWith(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: space4),
                    Text(
                      project.location,
                      style: bodySmall.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
)
```

**G. Reviews & Ratings**
```dart
Column(
  children: [
    // Rating summary
    Row(
      children: [
        Column(
          children: [
            Text('${company.rating}', style: h1.copyWith(color: primaryDark)),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < company.rating.floor() ? Icons.star : Icons.star_border,
                  color: warning,
                  size: 20,
                );
              }),
            ),
            SizedBox(height: space4),
            Text('${company.reviews} reviews', style: caption),
          ],
        ),
        SizedBox(width: space32),
        Expanded(
          child: Column(
            children: [
              RatingBar(stars: 5, percentage: 0.85),
              RatingBar(stars: 4, percentage: 0.10),
              RatingBar(stars: 3, percentage: 0.03),
              RatingBar(stars: 2, percentage: 0.01),
              RatingBar(stars: 1, percentage: 0.01),
            ],
          ),
        ),
      ],
    ),
    SizedBox(height: space24),
    
    // Individual reviews
    ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => Divider(height: space32),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(review.userAvatar),
                ),
                SizedBox(width: space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.userName, style: h4),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < review.rating ? Icons.star : Icons.star_border,
                              color: warning,
                              size: 16,
                            );
                          }),
                          SizedBox(width: space8),
                          Text(review.date, style: caption),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: space12),
            Text(review.comment, style: bodyMedium),
            if (review.images.isNotEmpty) ...[
              SizedBox(height: space12),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images.length,
                  separatorBuilder: (context, index) => SizedBox(width: space8),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(radiusSmall),
                      child: Image.network(
                        review.images[index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    ),
  ],
)
```

**H. Action Buttons (Bottom)**
```dart
Padding(
  padding: EdgeInsets.all(space20),
  child: Row(
    children: [
      Expanded(
        flex: 2,
        child: ElevatedButton.icon(
          icon: Icon(Icons.request_quote),
          label: Text('Request Quote'),
          onPressed: () => navigateToRequestQuote(company),
        ),
      ),
      SizedBox(width: space12),
      Expanded(
        child: OutlinedButton.icon(
          icon: Icon(Icons.message),
          label: Text('Contact'),
          onPressed: () => navigateToChat(company),
        ),
      ),
    ],
  ),
)
```

### 17. Request Quote Screen
**Form:**
```dart
Form(
  child: ListView(
    padding: EdgeInsets.all(space20),
    children: [
      // Company info card (read-only display)
      Card(
        child: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(company.logo)),
          title: Text(company.name),
          subtitle: Text('${company.rating} ⭐ • ${company.completedProjects} projects'),
        ),
      ),
      SizedBox(height: space24),
      
      // Select existing project or create new
      Text('Select Project', style: h4),
      SizedBox(height: space12),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: 'Choose a project or create new',
        ),
        items: [
          DropdownMenuItem(value: 'new', child: Text('+ Create New Project')),
          ...myProjects.map((project) {
            return DropdownMenuItem(
              value: project.id,
              child: Text(project.title),
            );
          }),
        ],
        onChanged: (value) {},
      ),
      SizedBox(height: space24),
      
      // Project details (if existing project selected)
      if (selectedProject != null) ...[
        Card(
          child: Padding(
            padding: EdgeInsets.all(space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Project Details', style: h4),
                SizedBox(height: space12),
                InfoRow(label: 'Location', value: selectedProject.location),
                InfoRow(label: 'Building Type', value: selectedProject.buildingType),
                InfoRow(label: 'Risk Level', value: selectedProject.riskLevel),
                SizedBox(height: space12),
                TextButton(
                  child: Text('View Full Report'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: space24),
      ],
      
      // Additional details
      Text('Additional Details', style: h4),
      SizedBox(height: space12),
      TextFormField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Any additional information for the company...',
        ),
      ),
      SizedBox(height: space24),
      
      // Preferred contact method
      Text('Preferred Contact Method', style: h4),
      SizedBox(height: space12),
      Wrap(
        spacing: space8,
        children: [
          ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email, size: 16),
                SizedBox(width: space4),
                Text('Email'),
              ],
            ),
            selected: contactMethod == 'email',
            onSelected: (selected) => setContactMethod('email'),
          ),
          ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone, size: 16),
                SizedBox(width: space4),
                Text('Phone'),
              ],
            ),
            selected: contactMethod == 'phone',
            onSelected: (selected) => setContactMethod('phone'),
          ),
          ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.message, size: 16),
                SizedBox(width: space4),
                Text('WhatsApp'),
              ],
            ),
            selected: contactMethod == 'whatsapp',
            onSelected: (selected) => setContactMethod('whatsapp'),
          ),
        ],
      ),
      SizedBox(height: space24),
      
      // Urgency level
      Text('Urgency Level', style: h4),
      SizedBox(height: space12),
      Row(
        children: [
          Expanded(
            child: RadioListTile(
              title: Text('Normal'),
              value: 'normal',
              groupValue: urgency,
              onChanged: (value) => setUrgency(value),
            ),
          ),
          Expanded(
            child: RadioListTile(
              title: Text('Urgent'),
              value: 'urgent',
              groupValue: urgency,
              onChanged: (value) => setUrgency(value),
            ),
          ),
        ],
      ),
      SizedBox(height: space32),
      
      // Send button
      ElevatedButton(
        onPressed: sendQuoteRequest,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: space16),
        ),
        child: Text('Send Request'),
      ),
    ],
  ),
)
```

### 18. My Listings Screen (Building Owner)
**Components:**

**A. Header with Create Button**
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('My Listings', style: h3),
    ElevatedButton.icon(
      icon: Icon(Icons.add),
      label: Text('New Listing'),
      onPressed: () => navigateToCreateListing(),
    ),
  ],
)
```

**B. Tabs**
- Active (with badge showing count)
- Completed
- Archived

**C. Listing Cards**
```dart
ListView.separated(
  itemCount: listings.length,
  separatorBuilder: (context, index) => SizedBox(height: space12),
  itemBuilder: (context, index) {
    final listing = listings[index];
    return Card(
      child: InkWell(
        onTap: () => navigateToListingDetails(listing),
        child: Padding(
          padding: EdgeInsets.all(space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(listing.title, style: h4),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: space8, vertical: space4),
                    decoration: BoxDecoration(
                      color: success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(radiusFull),
                    ),
                    child: Text(
                      'Active',
                      style: caption.copyWith(color: success),
                    ),
                  ),
                ],
              ),
              SizedBox(height: space8),
              Text(
                listing.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: bodyMedium.copyWith(color: textSecondary),
              ),
              SizedBox(height: space12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: textSecondary),
                  SizedBox(width: space4),
                  Text(listing.location, style: bodySmall),
                  SizedBox(width: space16),
                  Icon(Icons.calendar_today, size: 16, color: textSecondary),
                  SizedBox(width: space4),
                  Text('Posted ${listing.postedDate}', style: bodySmall),
                ],
              ),
              SizedBox(height: space12),
              Divider(),
              SizedBox(height: space12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 20, color: info),
                      SizedBox(width: space4),
                      Text('${listing.views} views', style: bodySmall),
                    ],
                  ),
                  Container(width: 1, height: 20, color: borderLight),
                  Row(
                    children: [
                      Icon(Icons.local_offer, size: 20, color: warning),
                      SizedBox(width: space4),
                      Text('${listing.offers} offers', style: bodySmall),
                    ],
                  ),
                  Container(width: 1, height: 20, color: borderLight),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 20, color: success),
                      SizedBox(width: space4),
                      Text('${listing.budget} EGP', style: bodySmall),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  },
)
```

**D. Empty State (if no listings)**
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.folder_open, size: 80, color: textSecondary),
      SizedBox(height: space16),
      Text('No listings yet', style: h4),
      SizedBox(height: space8),
      Text(
        'Create your first listing to get started',
        style: bodyMedium.copyWith(color: textSecondary),
      ),
      SizedBox(height: space24),
      ElevatedButton.icon(
        icon: Icon(Icons.add),
        label: Text('Create Listing'),
        onPressed: () => navigateToCreateListing(),
      ),
    ],
  ),
)
```

### 19. Received Offers Screen (Building Owner)
**Components:**

**A. Filter Tabs**
- All Offers
- New (unread)
- Under Review
- Accepted
- Declined

**B. Offer Cards**
```dart
ListView.separated(
  itemCount: offers.length,
  separatorBuilder: (context, index) => SizedBox(height: space12),
  itemBuilder: (context, index) {
    final offer = offers[index];
    return Card(
      child: Padding(
        padding: EdgeInsets.all(space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company info
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(offer.company.logo),
                ),
                SizedBox(width: space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(offer.company.name, style: h4),
                          if (offer.company.verified)
                            Padding(
                              padding: EdgeInsets.only(left: space4),
                              child: Icon(Icons.verified, color: success, size: 16),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: warning, size: 14),
                          SizedBox(width: space4),
                          Text(
                            '${offer.company.rating} (${offer.company.reviews} reviews)',
                            style: caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (offer.isNew)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: space8, vertical: space4),
                    decoration: BoxDecoration(
                      color: error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(radiusFull),
                    ),
                    child: Text('New', style: caption.copyWith(color: error)),
                  ),
              ],
            ),
            SizedBox(height: space16),
            
            // Project reference
            Text(
              'For: ${offer.projectTitle}',
              style: bodyMedium.copyWith(color: textSecondary),
            ),
            SizedBox(height: space12),
            
            // Offer details
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Proposal', style: caption),
                      SizedBox(height: space4),
                      Text('${offer.price} EGP', style: h4.copyWith(color: success)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Timeline', style: caption),
                      SizedBox(height: space4),
                      Text('${offer.timeline} weeks', style: h4),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: space12),
            
            // Services included
            Text('Includes:', style: caption),
            SizedBox(height: space4),
            Wrap(
              spacing: space4,
              runSpacing: space4,
              children: offer.services.map((service) {
                return Chip(
                  label: Text(service, style: caption),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
            SizedBox(height: space16),
            
            // Message preview
            if (offer.message.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(space12),
                decoration: BoxDecoration(
                  color: backgroundLight,
                  borderRadius: BorderRadius.circular(radiusSmall),
                ),
                child: Text(
                  offer.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: bodySmall,
                ),
              ),
              SizedBox(height: space12),
            ],
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => showOfferDetails(offer),
                    child: Text('View Details'),
                  ),
                ),
                SizedBox(width: space8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => acceptOffer(offer),
                    child: Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  },
)
```

### 20. Project Details Screen (Building Owner)
**Sections:**

**A. Status Header**
```dart
Container(
  padding: EdgeInsets.all(space20),
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [primaryDark, primaryLight]),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Project Details',
            style: h3.copyWith(color: Colors.white),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: space12, vertical: space6),
            decoration: BoxDecoration(
              color: success.withOpacity(0.2),
              borderRadius: BorderRadius.circular(radiusFull),
              border: Border.all(color: success),
            ),
            child: Text(
              'Active',
              style: bodySmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      SizedBox(height: space16),
      Text(
        project.title,
        style: h2.copyWith(color: Colors.white),
      ),
    ],
  ),
)
```

**B. Quick Stats**
```dart
Container(
  padding: EdgeInsets.all(space16),
  child: Row(
    children: [
      Expanded(
        child: StatCard(
          icon: Icons.calendar_today,
          value: project.postedDate,
          label: 'Posted',
          iconColor: info,
        ),
      ),
      Expanded(
        child: StatCard(
          icon: Icons.local_offer,
          value: '${project.offers}',
          label: 'Offers',
          iconColor: warning,
        ),
      ),
      Expanded(
        child: StatCard(
          icon: Icons.visibility,
          value: '${project.views}',
          label: 'Views',
          iconColor: success,
        ),
      ),
    ],
  ),
)
```

**C. Project Information**
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(space16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Project Information', style: h4),
        SizedBox(height: space16),
        InfoRow(
          icon: Icons.location_on,
          label: 'Location',
          value: project.location,
        ),
        InfoRow(
          icon: Icons.business,
          label: 'Building Type',
          value: project.buildingType,
        ),
        InfoRow(
          icon: Icons.layers,
          label: 'Floors',
          value: '${project.floors}',
        ),
        InfoRow(
          icon: Icons.square_foot,
          label: 'Area',
          value: '${project.area} sqm',
        ),
        InfoRow(
          icon: Icons.access_time,
          label: 'Timeline',
          value: project.timeline,
        ),
        InfoRow(
          icon: Icons.attach_money,
          label: 'Budget',
          value: '${project.budget} EGP',
        ),
      ],
    ),
  ),
)
```

**D. Description**
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(space16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: h4),
        SizedBox(height: space12),
        Text(project.description, style: bodyMedium),
      ],
    ),
  ),
)
```

**E. Required Services**
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(space16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Required Services', style: h4),
        SizedBox(height: space12),
        Wrap(
          spacing: space8,
          runSpacing: space8,
          children: project.services.map((service) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: space12, vertical: space8),
              decoration: BoxDecoration(
                color: primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: primaryLight, size: 16),
                  SizedBox(width: space4),
                  Text(service, style: bodySmall),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ),
  ),
)
```

**F. Attached Report**
```dart
Card(
  child: ListTile(
    leading: Container(
      padding: EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radiusSmall),
      ),
      child: Icon(Icons.description, color: error),
    ),
    title: Text('AI Scan Report'),
    subtitle: Text('Health Score: ${project.report.healthScore}% • Risk: ${project.report.riskLevel}'),
    trailing: Icon(Icons.chevron_right),
    onTap: () => viewReport(project.report),
  ),
)
```

**G. Received Offers List**
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(space16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Received Offers (${project.offers})', style: h4),
            TextButton(
              child: Text('View All'),
              onPressed: () => navigateToOffers(project),
            ),
          ],
        ),
        SizedBox(height: space12),
        // Show top 3 offers
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: min(3, offers.length),
          separatorBuilder: (context, index) => Divider(height: space24),
          itemBuilder: (context, index) {
            // Simplified offer card
          },
        ),
      ],
    ),
  ),
)
```

**H. Action Buttons**
```dart
Padding(
  padding: EdgeInsets.all(space20),
  child: Column(
    children: [
      ElevatedButton.icon(
        icon: Icon(Icons.edit),
        label: Text('Edit Listing'),
        onPressed: () => editListing(project),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
        ),
      ),
      SizedBox(height: space12),
      OutlinedButton.icon(
        icon: Icon(Icons.delete, color: error),
        label: Text('Delete Listing', style: TextStyle(color: error)),
        onPressed: () => showDeleteConfirmation(project),
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          side: BorderSide(color: error),
        ),
      ),
    ],
  ),
)
```

### 21. Company Dashboard Screen (For Engineering Companies)
**Sections:**

**A. Company Stats Overview**
```dart
GridView.count(
  crossAxisCount: 2,
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  padding: EdgeInsets.all(space16),
  mainAxisSpacing: space12,
  crossAxisSpacing: space12,
  children: [
    DashboardStatCard(
      title: 'Active Bids',
      value: '12',
      icon: Icons.local_offer,
      color: warning,
      trend: '+3 this week',
    ),
    DashboardStatCard(
      title: 'Won Projects',
      value: '45',
      icon: Icons.check_circle,
      color: success,
      trend: '+5 this month',
    ),
    DashboardStatCard(
      title: 'In Progress',
      value: '8',
      icon: Icons.engineering,
      color: info,
    ),
    DashboardStatCard(
      title: 'Revenue',
      value: '2.5M',
      subtitle: 'EGP',
      icon: Icons.monetization_on,
      color: primaryDark,
      trend: '+15% this month',
    ),
  ],
)
```

**B. Quick Actions**
- Browse New Requests
- My Active Bids
- Projects in Progress
- Company Profile

**C. Recent Opportunities**
- List of new project listings
- Filter by location, budget, timeline

**D. Performance Chart**
```dart
// Use fl_chart for line chart showing monthly performance
LineChart(
  LineChartData(
    // Show revenue, won bids, completed projects over time
  ),
)
```

### 22. Browse Repair Requests Screen (For Companies)
**Components:**

**A. Filters & Search**
- Similar to Browse Companies but for projects
- Filter by: Budget range, Location, Timeline, Risk Level

**B. Request Cards**
```dart
ListView.separated(
  itemCount: requests.length,
  separatorBuilder: (context, index) => SizedBox(height: space12),
  itemBuilder: (context, index) {
    final request = requests[index];
    return Card(
      child: InkWell(
        onTap: () => viewRequestDetails(request),
        child: Padding(
          padding: EdgeInsets.all(space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(request.title, style: h4),
                  ),
                  RiskBadge(level: request.riskLevel),
                ],
              ),
              SizedBox(height: space8),
              Text(
                request.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: bodyMedium.copyWith(color: textSecondary),
              ),
              SizedBox(height: space12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: textSecondary),
                  SizedBox(width: space4),
                  Text(request.location, style: bodySmall),
                  SizedBox(width: space16),
                  Icon(Icons.calendar_today, size: 16, color: textSecondary),
                  SizedBox(width: space4),
                  Text('Posted ${request.postedDate}', style: bodySmall),
                ],
              ),
              SizedBox(height: space12),
              Wrap(
                spacing: space8,
                children: request.services.map((service) {
                  return Chip(
                    label: Text(service, style: caption),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
              SizedBox(height: space12),
              Divider(),
              SizedBox(height: space12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 20, color: success),
                      SizedBox(width: space4),
                      Text(
                        'Budget: ${request.budget} EGP',
                        style: bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 20, color: warning),
                      SizedBox(width: space4),
                      Text(request.timeline, style: bodySmall),
                    ],
                  ),
                ],
              ),
              if (request.hasExistingBid) ...[
                SizedBox(height: space12),
                Container(
                  padding: EdgeInsets.all(space8),
                  decoration: BoxDecoration(
                    color: info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(radiusSmall),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: info, size: 16),
                      SizedBox(width: space8),
                      Text(
                        'You already submitted a bid',
                        style: bodySmall.copyWith(color: info),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  },
)
```

### 23. Submit Offer Screen (For Companies)
**Form:**
```dart
Form(
  child: ListView(
    padding: EdgeInsets.all(space20),
    children: [
      // Project info card (read-only)
      Card(
        child: Padding(
          padding: EdgeInsets.all(space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project', style: h4),
              SizedBox(height: space8),
              Text(project.title, style: h3),
              SizedBox(height: space8),
              Text(project.description, style: bodyMedium.copyWith(color: textSecondary)),
            ],
          ),
        ),
      ),
      SizedBox(height: space24),
      
      // Pricing
      Text('Your Proposal', style: h4),
      SizedBox(height: space12),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Bid Amount',
          prefixText: 'EGP ',
          hintText: 'Enter your bid amount',
        ),
      ),
      SizedBox(height: space16),
      
      // Timeline
      Text('Estimated Timeline', style: h4),
      SizedBox(height: space12),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Duration',
              ),
            ),
          ),
          SizedBox(width: space12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: 'weeks',
              decoration: InputDecoration(
                labelText: 'Unit',
              ),
              items: [
                DropdownMenuItem(value: 'days', child: Text('Days')),
                DropdownMenuItem(value: 'weeks', child: Text('Weeks')),
                DropdownMenuItem(value: 'months', child: Text('Months')),
              ],
              onChanged: (value) {},
            ),
          ),
        ],
      ),
      SizedBox(height: space24),
      
      // Services included
      Text('Services Included', style: h4),
      SizedBox(height: space12),
      CheckboxListTile(
        title: Text('Structural Assessment'),
        value: services.contains('assessment'),
        onChanged: (value) => toggleService('assessment'),
      ),
      CheckboxListTile(
        title: Text('Detailed Engineering Report'),
        value: services.contains('report'),
        onChanged: (value) => toggleService('report'),
      ),
      CheckboxListTile(
        title: Text('Repair Work'),
        value: services.contains('repair'),
        onChanged: (value) => toggleService('repair'),
      ),
      CheckboxListTile(
        title: Text('Warranty (1 year)'),
        value: services.contains('warranty'),
        onChanged: (value) => toggleService('warranty'),
      ),
      CheckboxListTile(
        title: Text('Post-repair Monitoring'),
        value: services.contains('monitoring'),
        onChanged: (value) => toggleService('monitoring'),
      ),
      SizedBox(height: space24),
      
      // Proposal message
      Text('Proposal Details', style: h4),
      SizedBox(height: space12),
      TextFormField(
        maxLines: 6,
        decoration: InputDecoration(
          hintText: 'Describe your approach, experience with similar projects, and why you\'re the best choice...',
          alignedLabelStyle: true,
        ),
      ),
      SizedBox(height: space24),
      
      // Attachments
      Text('Attachments (Optional)', style: h4),
      SizedBox(height: space12),
      DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(radiusMedium),
        dashPattern: [6, 3],
        color: borderLight,
        child: Container(
          height: 120,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file, size: 40, color: textSecondary),
              SizedBox(height: space8),
              Text('Upload relevant documents', style: bodyMedium),
              Text('(Certifications, previous work, etc.)', style: caption),
            ],
          ),
        ),
      ),
      SizedBox(height: space32),
      
      // Terms checkbox
      CheckboxListTile(
        title: Text('I agree to the terms and conditions'),
        value: acceptedTerms,
        onChanged: (value) => setAcceptedTerms(value),
        controlAffinity: ListTileControlAffinity.leading,
      ),
      SizedBox(height: space24),
      
      // Submit button
      ElevatedButton(
        onPressed: acceptedTerms ? submitOffer : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: space16),
        ),
        child: Text('Submit Offer'),
      ),
    ],
  ),
)
```

### 24. Notifications Screen
**Components:**

**A. Tabs**
- All
- Unread
- Scan Updates
- Marketplace
- System

**B. Notification List**
```dart
ListView.separated(
  itemCount: notifications.length,
  separatorBuilder: (context, index) => Divider(height: 1),
  itemBuilder: (context, index) {
    final notification = notifications[index];
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: error,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: space20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => deleteNotification(notification),
      child: Container(
        color: notification.isRead ? Colors.white : primaryLight.withOpacity(0.05),
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: getNotificationColor(notification.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getNotificationIcon(notification.type),
              color: getNotificationColor(notification.type),
            ),
          ),
          title: Text(
            notification.title,
            style: bodyMedium.copyWith(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: space4),
              Text(notification.message, maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: space4),
              Text(
                notification.timeAgo,
                style: caption.copyWith(color: textSecondary),
              ),
            ],
          ),
          isThreeLine: true,
          onTap: () => handleNotificationTap(notification),
        ),
      ),
    );
  },
)
```

---

## 🎭 Animations & Interactions

### AI Scan Animation
```dart
class AIScanAnimation extends StatefulWidget {
  @override
  _AIScanAnimationState createState() => _AIScanAnimationState();
}

class _AIScanAnimationState extends State<AIScanAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scanLineAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ScanLinePainter(_scanLineAnimation.value),
          child: child,
        );
      },
    );
  }
}
```

### Loading Shimmer Effect
```dart
// Use shimmer package
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    width: double.infinity,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radiusLarge),
    ),
  ),
)
```

### Page Transitions
```dart
// Use custom page route
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);
    return SlideTransition(position: offsetAnimation, child: child);
  },
)
```

### Pull to Refresh
```dart
RefreshIndicator(
  onRefresh: () async {
    // Refresh logic
  },
  color: primaryLight,
  child: ListView(...),
)
```

### Floating Action Button with Menu
```dart
SpeedDial(
  icon: Icons.add,
  activeIcon: Icons.close,
  backgroundColor: primaryLight,
  children: [
    SpeedDialChild(
      child: Icon(Icons.scanner),
      label: 'New Scan',
      onTap: () {},
    ),
    SpeedDialChild(
      child: Icon(Icons.post_add),
      label: 'Create Listing',
      onTap: () {},
    ),
  ],
)
```

---

## 🌍 Localization & RTL Support

### Language Files Structure
```
lib/
  l10n/
    app_ar.arb  // Arabic translations
    app_en.arb  // English translations
```

### pubspec.yaml Configuration
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

flutter:
  generate: true
```

### l10n.yaml
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### RTL Layout Handling
```dart
// Automatically handles RTL
Directionality(
  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
  child: MaterialApp(...),
)

// Use instead of left/right
EdgeInsets.symmetric(horizontal: space16)  // Good
EdgeInsets.only(left: space16)  // Bad - breaks in RTL

// Use Start/End alignment
MainAxisAlignment.start  // Good
MainAxisAlignment.left   // Bad
```

---

## 📊 Data Models

### Scan Result Model
```dart
class ScanResult {
  final String id;
  final String buildingId;
  final DateTime scanDate;
  final String imageUrl;
  final double healthScore;
  final RiskLevel riskLevel;
  final int totalCracks;
  final double crackPercentage;
  final List<Crack> cracks;
  final String location;
  final String buildingType;
  final List<String> recommendations;
  
  ScanResult({
    required this.id,
    required this.buildingId,
    required this.scanDate,
    required this.imageUrl,
    required this.healthScore,
    required this.riskLevel,
    required this.totalCracks,
    required this.crackPercentage,
    required this.cracks,
    required this.location,
    required this.buildingType,
    required this.recommendations,
  });
  
  factory ScanResult.fromJson(Map<String, dynamic> json) {
    // JSON parsing
  }
  
  Map<String, dynamic> toJson() {
    // JSON serialization
  }
}

enum RiskLevel { low, moderate, high, critical }

class Crack {
  final String id;
  final CrackType type;
  final Severity severity;
  final double x;
  final double y;
  final double width;
  final double height;
  
  Crack({
    required this.id,
    required this.type,
    required this.severity,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

enum CrackType { horizontal, vertical, diagonal }
enum Severity { low, moderate, high, critical }
```

### Project Listing Model
```dart
class ProjectListing {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String location;
  final String buildingType;
  final int buildingAge;
  final int floors;
  final double area;
  final double budget;
  final String timeline;
  final List<String> services;
  final String? reportId;
  final DateTime postedDate;
  final ListingStatus status;
  final int views;
  final int offers;
  
  ProjectListing({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.buildingType,
    required this.buildingAge,
    required this.floors,
    required this.area,
    required this.budget,
    required this.timeline,
    required this.services,
    this.reportId,
    required this.postedDate,
    required this.status,
    this.views = 0,
    this.offers = 0,
  });
}

enum ListingStatus { active, completed, archived }
```

### Company Model
```dart
class Company {
  final String id;
  final String name;
  final String logo;
  final String description;
  final String location;
  final double rating;
  final int reviews;
  final int completedProjects;
  final int avgResponseTime; // in hours
  final double successRate;
  final bool verified;
  final bool topRated;
  final List<String> specializations;
  final List<String> certifications;
  final int yearsInBusiness;
  final int teamSize;
  final List<String> serviceAreas;
  
  Company({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.completedProjects,
    required this.avgResponseTime,
    required this.successRate,
    required this.verified,
    required this.topRated,
    required this.specializations,
    required this.certifications,
    required this.yearsInBusiness,
    required this.teamSize,
    required this.serviceAreas,
  });
}
```

### Offer Model
```dart
class Offer {
  final String id;
  final String companyId;
  final String projectId;
  final double price;
  final int timeline; // in weeks
  final String timelineUnit;
  final List<String> services;
  final String message;
  final DateTime submittedDate;
  final OfferStatus status;
  final bool isNew;
  
  Offer({
    required this.id,
    required this.companyId,
    required this.projectId,
    required this.price,
    required this.timeline,
    this.timelineUnit = 'weeks',
    required this.services,
    required this.message,
    required this.submittedDate,
    this.status = OfferStatus.pending,
    this.isNew = true,
  });
}

enum OfferStatus { pending, accepted, declined, withdrawn }
```

---

## 🔌 State Management

### Recommended: Provider or Riverpod

```dart
// Example with Provider

class AppState extends ChangeNotifier {
  Locale _locale = Locale('ar');
  ThemeMode _themeMode = ThemeMode.light;
  User? _user;
  List<ScanResult> _scans = [];
  
  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  User? get user => _user;
  List<ScanResult> get scans => _scans;
  
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
  
  Future<void> performScan(File image) async {
    // Scan logic
    notifyListeners();
  }
}

// In main.dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );
}
```

---

## 📦 Recommended Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # UI Components
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  dotted_border: ^2.1.0
  flutter_speed_dial: ^7.0.0
  
  # Charts & Visualization
  fl_chart: ^0.66.0
  syncfusion_flutter_charts: ^24.1.41
  
  # Image Handling
  image_picker: ^1.0.5
  image_cropper: ^5.0.1
  photo_view: ^0.14.0
  
  # File Handling
  file_picker: ^6.1.1
  path_provider: ^2.1.1
  open_file: ^3.3.2
  
  # PDF Generation
  pdf: ^3.10.7
  printing: ^5.11.1
  
  # Networking
  http: ^1.1.2
  dio: ^5.4.0
  
  # State Management
  provider: ^6.1.1
  # OR
  riverpod: ^2.4.9
  
  # Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
  
  # Utilities
  uuid: ^4.2.2
  timeago: ^3.6.0
  url_launcher: ^6.2.2
  share_plus: ^7.2.1
  
  # Animation
  lottie: ^2.7.0
  animate_do: ^3.1.2
  
  # Forms
  flutter_form_builder: ^9.1.1
  form_builder_validators: ^9.1.0
  
  # Icons
  font_awesome_flutter: ^10.6.0
```

---

## 🎯 API Integration Points

### Mock AI Scan API
```dart
class AIService {
  Future<ScanResult> analyzeBuildingImage(File image) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 3));
    
    // Return mock data for now
    return ScanResult(
      id: uuid.v4(),
      buildingId: 'building_123',
      scanDate: DateTime.now(),
      imageUrl: image.path,
      healthScore: 75.0,
      riskLevel: RiskLevel.moderate,
      totalCracks: 12,
      crackPercentage: 15.5,
      cracks: [
        // Mock crack data
      ],
      location: 'Cairo, Egypt',
      buildingType: 'Residential',
      recommendations: [
        'Regular monitoring recommended',
        'Minor structural repairs needed',
      ],
    );
  }
}
```

### API Endpoints (for future backend integration)
```
POST   /api/scan/upload          - Upload image for scanning
GET    /api/scan/{id}            - Get scan result
GET    /api/scans                - Get user's scan history
DELETE /api/scan/{id}            - Delete scan

POST   /api/listings             - Create project listing
GET    /api/listings             - Get all listings
GET    /api/listings/{id}        - Get listing details
PUT    /api/listings/{id}        - Update listing
DELETE /api/listings/{id}        - Delete listing

GET    /api/companies            - Get engineering companies
GET    /api/companies/{id}       - Get company profile
POST   /api/companies/{id}/quote - Request quote

POST   /api/offers               - Submit offer
GET    /api/offers/received      - Get received offers
GET    /api/offers/sent          - Get sent offers
PUT    /api/offers/{id}/accept   - Accept offer
PUT    /api/offers/{id}/decline  - Decline offer

GET    /api/notifications        - Get notifications
PUT    /api/notifications/{id}   - Mark as read
```

---

## 🧪 Testing Considerations

### Test Data
```dart
// Create mock data for testing all states
class MockData {
  static List<ScanResult> mockScans = [
    ScanResult(
      id: '1',
      healthScore: 85,
      riskLevel: RiskLevel.low,
      // ... other fields
    ),
    // More mock scans
  ];
  
  static List<Company> mockCompanies = [
    // Mock companies
  ];
  
  static List<ProjectListing> mockListings = [
    // Mock listings
  ];
}
```

---

## 🚀 Performance Optimization

### Image Optimization
```dart
// Use CachedNetworkImage for remote images
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => Shimmer(...),
  errorWidget: (context, url, error) => Icon(Icons.error),
  fit: BoxFit.cover,
)

// Compress images before upload
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressImage(File file) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    '${file.absolute.path}_compressed.jpg',
    quality: 85,
    minWidth: 1024,
    minHeight: 1024,
  );
  return File(result!.path);
}
```

### Lazy Loading
```dart
// Use ListView.builder for large lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemCard(item: items[index]);
  },
)
```

---

## 📱 Platform-Specific Considerations

### iOS
- Use SF Symbols where appropriate
- Follow iOS Human Interface Guidelines
- Handle safe areas properly
```dart
SafeArea(
  child: Scaffold(...),
)
```

### Android
- Use Material Design 3 components
- Handle back button properly
```dart
WillPopScope(
  onWillPop: () async {
    // Custom back button handling
    return true;
  },
  child: Scaffold(...),
)
```

---

## 🎨 Dark Mode Specifications

### Dark Theme Colors
```dart
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryLight,
  scaffoldBackgroundColor: Color(0xFF111827),
  cardColor: Color(0xFF1F2937),
  dividerColor: Color(0xFF374151),
  
  colorScheme: ColorScheme.dark(
    primary: primaryLight,
    secondary: primaryDark,
    surface: Color(0xFF1F2937),
    background: Color(0xFF111827),
    error: error,
  ),
  
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFF9FAFB)),
    bodyMedium: TextStyle(color: Color(0xFFE5E7EB)),
  ),
);
```

---

## 💾 Local Storage

### Shared Preferences for Settings
```dart
class SettingsService {
  static const String _languageKey = 'language';
  static const String _themeKey = 'theme';
  
  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }
  
  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'ar';
  }
}
```

### Hive for Offline Data
```dart
// For caching scans, projects, etc.
@HiveType(typeId: 0)
class ScanResultHive extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  double healthScore;
  
  // ... other fields
}

// Initialize
await Hive.initFlutter();
Hive.registerAdapter(ScanResultHiveAdapter());
await Hive.openBox<ScanResultHive>('scans');
```

---

## 🔔 Push Notifications

```dart
// Firebase Cloud Messaging setup
class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  
  Future<void> initialize() async {
    // Request permission
    await _fcm.requestPermission();
    
    // Get FCM token
    String? token = await _fcm.getToken();
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Show local notification
    });
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }
}

// Notification types:
// - Scan completed
// - New offer received
// - Offer accepted/declined
// - Project viewed
// - New message
```

---

## 🎯 User Roles & Permissions

### Building Owner Permissions
- Upload and scan building images
- View scan history and reports
- Create project listings
- Receive and review offers
- Accept/decline offers
- Message with companies

### Engineering Company Permissions
- Browse repair requests
- View project details
- Submit offers/bids
- Manage company profile
- View analytics dashboard
- Message with building owners

---

## 📈 Analytics Events to Track

```dart
// Example analytics events
class AnalyticsEvents {
  static const String scanStarted = 'scan_started';
  static const String scanCompleted = 'scan_completed';
  static const String reportDownloaded = 'report_downloaded';
  static const String listingCreated = 'listing_created';
  static const String offerSubmitted = 'offer_submitted';
  static const String offerAccepted = 'offer_accepted';
  static const String companyViewed = 'company_viewed';
  static const String quoteRequested = 'quote_requested';
}
```

---

## 🔐 Security Considerations

### Secure API Communication
```dart
// Use HTTPS only
// Implement JWT authentication
// Store tokens securely
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
await storage.write(key: 'jwt_token', value: token);
String? token = await storage.read(key: 'jwt_token');
```

### Image Upload Security
- Validate file types
- Limit file sizes
- Scan for malicious content (server-side)

---

## 🎓 Conclusion

This Flutter design specification provides a comprehensive guide for developing the CrackDetectX mobile application. All screens, components, colors, typography, and interactions are defined to match the modern, professional, AI-focused aesthetic.

**Key Implementation Notes:**
1. Use the exact color palette specified
2. Implement RTL support from the start
3. Support both light and dark modes
4. Follow Material Design 3 guidelines
5. Prioritize smooth animations and transitions
6. Implement proper error states and loading states
7. Test on both iOS and Android devices
8. Use mock data until backend APIs are ready
9. Follow accessibility guidelines (WCAG)
10. Optimize images and performance

**Next Steps:**
1. Set up Flutter project with required packages
2. Implement design system (colors, typography, components)
3. Create reusable widget library
4. Implement authentication flow
5. Build core scanning functionality with mock AI
6. Develop marketplace features
7. Add localization
8. Implement dark mode
9. Test and refine
10. Prepare for backend integration

---

**Document Version:** 1.0  
**Last Updated:** December 16, 2024  
**Author:** CrackDetectX Design Team
