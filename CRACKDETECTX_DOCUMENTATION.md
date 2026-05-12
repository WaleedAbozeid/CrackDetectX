# CrackDetectX — توثيق شامل كامل

> **الإصدار:** 1.0.0  
> **آخر تحديث:** مايو 2026  
> **الحالة:** قيد التطوير — الربط بالـ Backend جارٍ

---

## 1. نظرة عامة على النظام

**CrackDetectX** تطبيق Flutter لكشف الشقوق في المباني بالذكاء الاصطناعي، يتضمن:
- كشف الشقوق بالذكاء الاصطناعي عبر تحليل الصور
- إدارة المباني والتقارير
- Marketplace للتواصل بين ملاك المباني وشركات الإصلاح
- لوحة تحكم للمشرفين (Admin Dashboard)
- دعم offline كامل مع sync تلقائي

---

## 2. الـ Actors (المستخدمون)

| Actor | الدور | الصلاحيات الرئيسية |
|---|---|---|
| **Field Engineer** | مهندس ميداني | تصوير + رفع صور + تحليل AI + تقارير + annotation |
| **Building Owner** | مالك مبنى | عرض التقارير + إنشاء طلبات إصلاح + متابعة العقود |
| **Repair Company** | شركة إصلاح | عرض الطلبات + تقديم العروض + توقيع العقود |
| **Admin** | مشرف النظام | التحقق من المستخدمين + حل النزاعات + إدارة التذاكر |

---

## 3. معمارية النظام (Architecture)

### 3.1 DFD Level 0 — Context Diagram

```
User (Engineer/Owner)  ←→  [CrackDetectX System]  ←→  Admin
                                    ↕                      ↕
Repair Company         ←→  [CrackDetectX System]  ←→  AI Service (Cloud)

البيانات المتدفقة:
User → System:       Login/Register, Image/Scan Data, Requests
System → User:       Results/Reports, Notifications
Repair Co → System:  Bids
System → Repair Co:  Requests/Contracts
Admin → System:      Management Actions (Users, Data, Logs)
System → Admin:      System Data/Reports
System → AI:         Image Data for Analysis
AI → System:         AI Analysis Results
```

### 3.2 DFD Level 1 — Detailed Processes

| Process | الوصف | Data Stores |
|---|---|---|
| **1.0 Authentication & User Management** | تسجيل دخول + إدارة حسابات | D1: Users |
| **2.0 Scan & AI Processing** | رفع صور + تحليل AI | D2: Scans, D3: AI Results |
| **3.0 Report Management** | توليد + عرض + مشاركة التقارير | D4: Reports |
| **4.0 Annotation Management** | إضافة تعليقات على الصور | D5: Annotations |
| **5.0 Marketplace** | طلبات + عروض + عقود | D6: Requests, D7: Bids, D8: Contracts |
| **6.0 Notification System** | إرسال واستقبال الإشعارات | D9: Notifications |
| **7.0 Offline Sync** | مزامنة البيانات عند العودة للإنترنت | D10: Offline Draft Store |

### 3.3 Stack التقني

```
Flutter (Dart)
├── State Management: Provider (ChangeNotifier)
├── HTTP Client: Dio (مع Interceptors)
├── Local Storage: SharedPreferences + SQLite (LocalDb)
├── PDF Generation: pdf + printing packages
├── Image Picker: image_picker
├── Fonts: Cairo (Google Fonts)
└── Localization: Flutter Localizations (AR + EN)

Backend (Postman Collection v5)
├── Base URL: http://localhost:6000/api/v1
├── Auth: JWT Bearer Token
├── Port: 6000
└── Modules: AUTH, USER, BUILDINGS, SCANS, REPORTS,
            MARKETPLACE, NOTIFICATIONS, SUPPORT, DRAFTS
```

---

## 4. Data Models (من ERD + Class Diagram)

### 4.1 User
```
user_id     : int (PK)
name        : varchar
email       : varchar  [unique]
phone       : varchar
role        : varchar  → field_engineer | building_owner | repair_company | admin
is_verified : boolean
created_at  : datetime

Methods: login(), logout(), updateProfile()
Subtypes: BuildingOwner, Engineer, Admin
```

### 4.2 Building
```
building_id : int (PK)
project_id  : int (FK → Project)
owner_id    : int (FK → User)
address     : text
yearBuilt   : int
building_type: varchar → residential | commercial | industrial
```

### 4.3 Project
```
project_id  : int (PK)
owner_id    : int (FK → User)
name        : varchar
description : text
```

### 4.4 Scan
```
scan_id     : int (PK)
building_id : int (FK → Building)
user_id     : int (FK → User)
image_url   : varchar
status      : varchar → queued | analyzing | detecting | reporting | done | cancelled
is_synced   : boolean
created_at  : datetime
```

### 4.5 AIResult 
```
result_id        : int (PK)
scan_id          : int (FK → Scan)
severity_level   : varchar → low | medium | high | critical
confidence_score : float   [0.0 - 1.0]
health_score     : int     [0 - 100]
```

### 4.6 Annotation
```
annotation_id : int (PK)
scan_id       : int (FK → Scan)
coords        : string  [JSON coordinates]
crack_type    : string
```

### 4.7 Report
```
report_id  : int (PK)
scan_id    : int (FK → Scan)
pdf_url    : varchar
created_at : datetime
```

### 4.8 Request (Marketplace)
```
request_id : int (PK)
owner_id   : int (FK → User)
title      : varchar
budget     : decimal
status     : varchar → open | closed | cancelled
deadline   : date
```

### 4.9 Bid
```
bid_id     : int (PK)
request_id : int (FK → Request)
company_id : int (FK → Company)
price      : decimal
notes      : text
status     : varchar → pending | accepted | rejected
```

### 4.10 Contract
```
contract_id : int (PK)
request_id  : int (FK → Request)
bid_id      : int (FK → Bid)
amount      : decimal
status      : varchar → pending | active | completed | disputed
```

### 4.11 Company
```
company_id   : int (PK)
name         : varchar
specialty    : varchar
is_verified  : boolean

Methods: submitBid(), viewRequests()
```

### 4.12 OfflineDraft
```
draft_id   : int (PK)
user_id    : int (FK → User)
local_path : varchar  [مسار الصورة محليًا]
metadata   : text     [JSON: building_data, notes]
created_at : datetime
synced     : boolean
```

### 4.13 SupportTicket
```
ticket_id  : int (PK)
user_id    : int (FK → User)
subject    : varchar
status     : varchar → open | in_progress | resolved | escalated
priority   : varchar → low | medium | high
```

### 4.14 Notification
```
notification_id : int (PK)
user_id         : int (FK → User)
title           : varchar
is_read         : boolean
```

---

## 5. API Endpoints (Postman Collection v5)

**Base URL:** `http://localhost:6000/api/v1`  
**Auth:** `Authorization: Bearer {{token}}`

### 5.1 AUTH

| Method | Endpoint | Body | يخزّن |
|---|---|---|---|
| POST | `/auth/register` | `full_name, email, password, phone, user_type` | — |
| POST | `/auth/login` | `email, password` | `accessToken, refreshToken` |
| POST | `/auth/logout` | `refreshToken` | — (يمسح tokens) |
| POST | `/auth/refresh` | `refreshToken` | `accessToken` جديد |
| POST | `/auth/forgot-password` | `email` | — |
| POST | `/auth/reset-password` | `token, password` | — |

**Login Response:**
```json
{
  "data": {
    "accessToken": "eyJ...",
    "refreshToken": "eyJ..."
  }
}
```

### 5.2 USER

| Method | Endpoint | Body / Notes |
|---|---|---|
| GET | `/users/me` | يرجع `UserModel` كامل |
| PUT | `/users/me` | `full_name, phone` |

### 5.3 BUILDINGS

| Method | Endpoint | Body / Notes |
|---|---|---|
| GET | `/buildings` | list كل المباني |
| POST | `/buildings` | `name, address, building_type` |
| GET | `/buildings/{id}` | مبنى واحد |
| PUT | `/buildings/{id}` | `name, ...` |
| DELETE | `/buildings/{id}` | — |

**Post-Create Script:** يحفظ `building_id` في Collection Variables.

### 5.4 SCANS

| Method | Endpoint | Body / Notes |
|---|---|---|
| POST | `/scans` | `FormData: images(file), building_id, notes` |
| GET | `/scans` | list كل الـ scans |
| GET | `/scans/{id}` | scan واحدة |
| GET | `/scans/{id}/status` | `{ status: "queued|analyzing|..." }` |
| POST | `/scans/{id}/cancel` | إلغاء scan |

> ⚠️ الـ Scan يُرسل كـ **multipart/form-data** مش JSON

### 5.5 REPORTS

| Method | Endpoint | Notes |
|---|---|---|
| GET | `/reports` | يحفظ `report_id` أول نتيجة |
| GET | `/reports/{id}` | تقرير واحد |
| POST | `/reports/{id}/share` | مشاركة التقرير |

### 5.6 MARKETPLACE

| Method | Endpoint | Body |
|---|---|---|
| GET | `/marketplace/engineers` | — |
| GET | `/marketplace/requests` | — |
| POST | `/marketplace/requests` | `title, budget, deadline` |
| POST | `/marketplace/requests/{request_id}/bids` | `price, notes` |
| POST | `/marketplace/bids/{bid_id}/accept` | — |
| GET | `/marketplace/contracts` | — |

### 5.7 NOTIFICATIONS

| Method | Endpoint | Body |
|---|---|---|
| GET | `/notifications` | يحفظ `notification_id` |
| POST | `/notifications/read` | `ids: ["{{notification_id}}"]` |

### 5.8 SUPPORT

| Method | Endpoint | Body |
|---|---|---|
| POST | `/support` | `subject, description, priority` |
| GET | `/support` | list |
| GET | `/support/{ticket_id}` | ticket واحد |

### 5.9 DRAFTS (Offline Sync)

| Method | Endpoint | Body |
|---|---|---|
| POST | `/drafts` | `building_data: {}, notes, images: []` |
| GET | `/drafts` | list |
| DELETE | `/drafts/{draft_id}` | — |
| GET | `/drafts/pending` | drafts غير متزامنة |

---

## 6. User Flows (من الدياجرامز)

### 6.1 AI Inspection Flow (Field Engineer)
```
1. Open Application → Login
2. Server: Authenticate
   ├── Success → Continue
   └── Failure → Login Failed [END]
3. Select Building
4. Capture Image
5. Internet Available?
   ├── NO → Save Offline Draft → Wait for Internet → Sync → Upload
   └── YES → Upload Image
6. Server: Set Status = Queued
7. [Parallel]
   ├── User Can Cancel Analysis → Cancel → [END]
   └── Server: Process AI Analysis
8. Status: Queued → Analyzing → Detecting → Reporting
9. Generate Report
10. View Report
11. Edit Results? YES → Annotate Image → Save Annotation
12. [Loop back or END]
```

### 6.2 Repair Flow (Building Owner + Repair Company)
```
1. Owner: View Report → Create Repair Request
2. Server: Notify Companies
3. Company: View Requests → Submit Bid → Save Bid
4. Server: Notify Owner
5. Owner: View Bids → Compare Bids
6. Accept Bid?
   ├── YES → Server: Generate Contract
   └── NO → Keep Request Open
7. Owner: Sign Contract → Save Signature
8. Company: Upload Documents → Sign Contract
9. Server: Verify Signatures → Activate Contract → Notify Both Parties
10. [END]
```

### 6.3 Support Flow (User + Admin)
```
1. User: Need Support? YES
2. Server: Create Ticket → Notify Admin
3. Admin: Review Ticket
4. Need Escalation?
   ├── YES → Escalate
   └── NO → Resolve Issue
5. Server: Notify User (Resolved)
6. [END]
```

### 6.4 Notifications & Sync Flow
```
Mobile App → [Draft Ready] → Local Storage
Local Storage → [Sync Draft] → Server
Server → [Process & Save]
Server → Notification Service → [Send Notification]
Notification Service → Mobile App → [Deliver Notification]
Mobile App → Server → [Check Updates] → [Latest Data]
```

---

## 7. Use Cases بالتفصيل

### 7.1 Field Engineer
- Register / Login / Manage Profile
- Capture Image
- Upload Image (Online) → extends: Save Offline Draft → includes: Sync When Online
- Analyze Crack (AI) → extends: Cancel Analysis
- Generate Report → includes: Analyze Crack
- View Report → extends: Annotate Image
- Share Report

### 7.2 Building Owner
- Register / Login
- View Report
- Create Request
- Track Repair
- View Bids → includes: Compare Bids → includes: Accept Bid → includes: Sign Contract

### 7.3 Repair Company
- Register / Login
- View Requests → includes: Submit Bid
- Upload Documents (Online)
- Sign Contract

### 7.4 Admin
- Login
- Verify Company → extends: Approve / Reject / Request Documents
- Manage Support Tickets

---

## 8. هيكل المشروع (Flutter)

```
lib/
├── main.dart                    ← App entry + routes + theme
├── l10n/                        ← Localization (AR + EN)
│   └── app_localizations.dart
└── src/
    ├── ai/                      ← AI model stub + types
    │   ├── model_stub.dart
    │   └── types.dart
    ├── core/                    ← Constants + API client
    │   ├── constants.dart       ← routes, storage keys, API base URL
    │   ├── app_strings.dart
    │   ├── api_client.dart      ← [TODO] Dio client + interceptors
    │   └── api_exception.dart   ← [TODO] Error model
    ├── design/                  ← Design system
    │   ├── colors.dart
    │   └── typography.dart
    ├── models/                  ← Data models (DTOs)
    │   ├── auth_tokens.dart     ✅
    │   ├── user_model.dart      ← [TODO]
    │   ├── building_models.dart ✅ (partial)
    │   ├── scan_model.dart      ← [TODO]
    │   ├── ai_result_model.dart ← [TODO]
    │   ├── admin_models.dart    ✅
    │   ├── marketplace_models.dart ✅ (partial)
    │   ├── communication_models.dart ✅
    │   └── offline_models.dart  ✅
    ├── services/                ← Business logic
    │   ├── api_service.dart     ✅ (endpoint map, stubs)
    │   ├── auth_service.dart    ⚠️ (Firebase → needs JWT)
    │   ├── token_storage_service.dart ✅
    │   ├── local_db.dart        ✅
    │   ├── pdf_service.dart     ✅
    │   └── admin_guard.dart     ⚠️ (email check → role check)
    ├── store/
    │   └── app_state.dart       ⚠️ (needs currentUser + role binding)
    ├── screens/                 ← UI Screens
    │   ├── splash_screen.dart
    │   ├── welcome_screen.dart
    │   ├── onboarding_screen.dart
    │   ├── login_screen.dart
    │   ├── signup_screen.dart
    │   ├── home_screen.dart
    │   ├── scan_screen.dart
    │   ├── result_screen.dart
    │   ├── reports_list_screen.dart
    │   ├── select_building_screen.dart
    │   ├── add_building_screen.dart
    │   ├── annotate_screen.dart
    │   ├── notifications_screen.dart
    │   ├── create_dispute_screen.dart
    │   ├── admin_dashboard_screen.dart       ⚠️ (Figma parity needed)
    │   ├── admin_dispute_resolution_screen.dart
    │   ├── admin_support_tickets_screen.dart
    │   ├── admin_notifications_center_screen.dart
    │   ├── admin_users_management_screen.dart
    │   ├── verification_queue_screen.dart
    │   └── system_config_screen.dart
    └── widgets/                 ← Reusable widgets
        ├── auth_guard.dart
        └── admin_auth_guard.dart
```

---

## 9. Auth Flow (JWT)

```
Login Request
     ↓
POST /auth/login { email, password }
     ↓
Response: { data: { accessToken, refreshToken } }
     ↓
TokenStorageService.save(AuthTokens)
     ↓
AppState.currentUser ← GET /users/me
     ↓
Route based on currentUser.role:
├── admin           → /admin/dashboard
├── field_engineer  → /home
├── building_owner  → /home
└── repair_company  → /home (marketplace)

Token Refresh Flow:
API Call → 401 Unauthorized
     ↓
POST /auth/refresh { refreshToken }
     ↓
Success → retry original request
Failure → logout → /login
```

---

## 10. Offline Sync Strategy

```
[No Internet detected]
     ↓
Save to LocalDb (OfflineDraft):
  - local_path: image path
  - metadata: { building_id, notes }
  - synced: false

[Internet restored]
     ↓
GET /drafts/pending → list of unsynced
     ↓
For each draft:
  POST /scans (multipart) → success?
    ├── YES → DELETE /drafts/{id} → mark synced
    └── NO  → exponential backoff retry (max 3 attempts)
             → on final failure: notify user
```

---

## 11. Error Handling Strategy

| HTTP Code | المعنى | السلوك في Flutter |
|---|---|---|
| 200/201 | نجاح | عرض البيانات |
| 400 | Bad Request | عرض رسالة الخطأ |
| 401 | Unauthorized | refresh token → فشل → logout |
| 403 | Forbidden | عرض "غير مصرح" |
| 404 | Not Found | عرض empty state |
| 422 | Validation Error | عرض field errors تحت الحقول |
| 500 | Server Error | عرض "خطأ في الخادم، حاول لاحقاً" |
| Timeout | Network | عرض "تحقق من اتصالك بالإنترنت" |

---

## 12. RBAC (Role-Based Access Control)

```dart
// من currentUser.role:
switch (role) {
  case 'admin':
    → AdminAuthGuard يسمح بدخول /admin/*
    → يرى كل المستخدمين والبيانات
  case 'field_engineer':
    → يدخل /home, /scan, /result, /reports
    → ينشئ scans ويرى تقاريره
  case 'building_owner':
    → يدخل /home, /reports, /marketplace
    → يرى تقارير مبانيه + يطلب إصلاح
  case 'repair_company':
    → يدخل /marketplace فقط
    → يرى الطلبات + يقدم عروض
}
```

---

## 13. Variables — Postman Collection

| Variable | يُحدَّث من | يُستخدم في |
|---|---|---|
| `token` | POST /auth/login | كل الـ authenticated requests |
| `building_id` | POST /buildings | SCANS, BUILDINGS |
| `scan_id` | POST /scans | GET /scans/{id}, /status, /cancel |
| `report_id` | GET /reports | GET /reports/{id}, /share |
| `request_id` | POST /marketplace/requests | bids |
| `bid_id` | POST /marketplace/requests/{id}/bids | /accept |
| `notification_id` | GET /notifications | /read |
| `ticket_id` | POST /support | GET /support/{id} |
| `draft_id` | POST /drafts | DELETE /drafts/{id} |

---

## 14. Gaps في الـ Backend (Admin Endpoints مفقودة)

هذه الـ endpoints موجودة في الـ Diagrams لكن **غير موجودة** في Postman v5:

| Endpoint | الوصف | الحالة |
|---|---|---|
| GET `/admin/dashboard/metrics` | KPI cards data | ❌ Mock |
| GET `/admin/dashboard/charts` | Chart data | ❌ Mock |
| POST `/admin/verifications/{id}/approve` | قبول مستخدم | ❌ Mock |
| POST `/admin/verifications/{id}/reject` | رفض مستخدم | ❌ Mock |
| POST `/admin/disputes/{id}/resolve` | حل نزاع | ❌ Mock |
| GET `/admin/audit-logs` | سجل العمليات | ❌ Mock |

> **الحل:** Admin Dashboard يعمل بـ Mock data حتى يوفر الباك هذه الـ APIs.

---

## 15. خطة الاختبار

### Unit Tests
- `AuthService`: login/logout/refresh
- `TokenStorageService`: save/load/clear
- `ApiClient`: token injection, 401 retry, error mapping

### Widget Tests
- `LoginScreen`: form validation
- `ScanScreen`: image picker flow
- `HomeScreen`: data loading state

### Integration Tests
- سيناريو كامل: Login → Create Building → Scan → View Report
- Offline → Online sync
- Auth failure → redirect to login

---

## 16. Demo Script (للعرض النهائي — 15 دقيقة)

```
دقيقة 1-2:   نظرة عامة على المشروع (DFD Level 0)
دقيقة 3-5:   تسجيل دخول كـ Field Engineer → تصوير → رفع → تحليل AI
دقيقة 6-8:   عرض التقرير → annotation → مشاركة
دقيقة 9-11:  تسجيل دخول كـ Building Owner → طلب إصلاح → قبول عرض
دقيقة 12-13: تسجيل دخول كـ Admin → لوحة التحكم → إدارة التذاكر
دقيقة 14-15: عرض Offline scenario → sync عند الاتصال
```

---

## 17. Known Limitations

1. Admin analytics endpoints غير متوفرة في Backend → Mock data
2. Base URL لا يزال `localhost:6000` (يحتاج staging URL للنشر)
3. AI Service الفعلي ليس جزءاً من الـ collection (يُعامل كـ black box على الباك)
4. `Project` entity موجود في الـ ERD لكن مش له endpoints في الـ collection
5. Contract signing (digital signature) غير مُنفّذة UI

---

*آخر تحديث: مايو 2026 — CrackDetectX Team*
