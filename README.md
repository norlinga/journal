# 📘 Journal Processing App

This project is a **full-stack web application** built with **Ruby on Rails and React**, designed to **process and summarize financial journal entries** from CSV data. The app supports **batch processing, data normalization, and API-based reporting** using a clean and well-structured design.

---

## 🚀 Features

- **Batch Processing of Orders**: CSV ingestion using Shopify's [MaintenanceTasks](https://github.com/Shopify/maintenance_tasks).
- **Data Normalization & Business Logic**: Powered by the [Interactor](https://github.com/collectiveidea/interactor) gem.
- **Efficient API Serialization**: Uses [Blueprinter](https://github.com/procore-oss/blueprinter) to format responses.
- **Clean Controller Design**: Follows the **skinny controller** pattern.
- **Comprehensive Tests**: Testing through Guard.
- **React Frontend**: Displays month summaries interactively.
- **Runs Out of the Box**: Just run `docker-compose up --build`!

---

## 🛠️ Tech Stack

| Layer | Technologies Used |
|---|---|
| **Backend (API)** | Ruby on Rails, SQLite3 |
| **Background Tasks** | MaintenanceTasks |
| **Business Logic** | Interactor |
| **Serialization** | Blueprinter |
| **Testing** | Rspec, Guard |
| **Frontend** | React, Vite, Axios |
| **Containerization** | Docker, Docker Compose |

---

## 📂 Project Structure

```plaintext
journal/
├── app/
│   ├── controllers/api/journal_controller.rb  # API for journal summary
│   ├── interactors/                           # Business logic
│   ├── blueprints/                            # API serialization
│   ├── models/                                # Batch, Order, JournalEntry
│   ├── tasks/maintenance/import_orders_task.rb  # CSV Processing Task
├── frontend/                                  # React frontend
├── db/
│   ├── seeds.rb                              # Sample data loader
├── Dockerfile                                # Docker setup
├── docker-compose.yml                        # Docker w/ SQLite3 volume
└── README.md
```

## 🔧 Getting Started

### **Option 1: Run with Docker** (Recommended)
```sh
docker-compose up --build
```
This will:

✅ Start Rails API at `http://localhost:3000`  
✅ Which also serves the React frontend at `http://localhost:3000`  
✅ Persist SQLite data using a **Docker volume**

### **Option 2: Run Locally with Foreman**

1️⃣ **Install dependencies:**
```sh
bundle install
bundle exec rails db:reset
npm install --prefix frontend
```

2️⃣ **Start the Rails API & Frontend with Foreman:**
```sh
foreman start -f Procfile.dev
```
- Rails API will be available at **`http://localhost:3000`**
- React frontend will be available at **`http://localhost:5173`**

---

## 📡 API Endpoints

### 🔍 Get Available Months with Data
```sh
GET /api/journal/months
```
**Response:**
```json
{
  "months": [
    {"month": "February 2023", "order_count": 64, "link": "/api/journal/2023-02"}
  ]
}
```

### 📊 Get Journal Summary for a Month
```sh
GET /api/journal/2023-02
```
**Response:**
```json
{
  "journal_summary": [
    {"account_type": "revenue", "entry_type": "credit", "total": "1400.25"}
  ]
}
```

---

## ⚡ Exploring & Debugging

### 🔹 Check Processed Data via Rails Console
Start an instance of the application, and then connect to it as follows:

```sh
docker-compose up --build
docker-compose exec app bin/rails c
> JournalEntry.count
> Batch.latest_successful
```

### 🔹 Run MaintenanceTasks Through The UI
Visit [`http://localhost:3000/maintenance_tasks`](http://localhost:3000/maintenance_tasks) to run tasks manually.

---

## 🎨 Frontend (React) Overview

- **List of Months** → Clickable items that fetch summaries.
- **Journal Summary Table** → Displays debits/credits by account.
- **Uses Axios for API Calls** → Automatically updates on selection.

Frontend **source code** is in `frontend/`, and is built into `public/` for Rails to serve.

---

## 📝 Note on Journal Summary Tables

This project includes **two versions** of the journal summary table:

1. **A dynamic version** that efficiently organizes journal entries but does not fully match the exact format outlined in the challenge.
2. **A structured "brute force" version** that closely follows the intended design but relies on a fixed layout rather than dynamically generated content.

While restructuring the API response from the Rails app could have made both approaches cleaner, I ultimately decided that the implementation as it stands sufficiently demonstrates the necessary concepts and functionality. Given the time spent on the project, I felt it was the right moment to move forward.

---

## 🧪 Running Tests

### 🔹 Running the Full Test Suite
```sh
bundle exec guard
```
This will automatically watch for file changes and run the relevant tests.

### 🔹 Running Tests Manually
```sh
bundle exec rspec
```

---

## 🎯 Final Notes
This project was designed to showcase:
- **Scalable batch processing** using MaintenanceTasks.
- **Modular service patterns** with Interactors.
- **Fast and minimal API responses** via Blueprinter.
- **Seamless frontend-backend integration** using React & Rails.
