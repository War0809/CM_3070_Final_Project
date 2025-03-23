📘 CM3070 Final Project - Mise en Place (University of London)

Welcome to the Mise en Place GitHub repository. This project was developed as part of the CM3070 Final Project for the University of London. The application aims to bridge the gap between physical cookbooks and digital recipe management using OCR (Optical Character Recognition) and NLP (Natural Language Processing).

🚀 Project Overview

Mise en Place is a hybrid mobile application designed to:

Digitize recipes from physical cookbooks using OCR.

Provide ingredient-based search functionality with NLP.

Allow users to create a personalized digital recipe index.

Seamlessly manage both physical and digital recipes.

🛠️ Features

OCR Integration: Scan and extract text from cookbook pages.

NLP Search: Search recipes using ingredient keywords.

Recipe Indexing: Automatically create a searchable digital index.

User Management: Secure user accounts and preferences using Supabase.

⚙️ Tech Stack

Frontend: Flutter (for cross-platform mobile development)

Backend: Supabase (PostgreSQL database and authentication)

OCR: Google Vision API & Tesseract OCR

NLP: Natural Language Processing using Python (SpaCy)

Deployment: Firebase (Optional for hosting and storage)
🧑‍💻 Installation Guide

Follow these steps to run the project locally:

Clone the Repository:

git clone https://github.com/yourusername/mise-en-place.git
cd mise-en-place

Set Up Environment Variables:
Create a .env file in the root directory with the following:

SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
GOOGLE_VISION_API_KEY=your_google_vision_api_key

Install Dependencies:

flutter pub get

Run the App:

flutter run

🧪 Testing

Unit tests and integration tests are available within the test/ directory.

To run tests:

flutter test

📊 Evaluation Summary

This project has undergone evaluation based on various factors, including design clarity, implementation quality, and performance testing. Results indicate successful achievement of project goals, with further opportunities for enhancing handwritten text recognition and expanding recipe search accuracy.

💡 Future Improvements

Implement AI-powered handwriting recognition for enhanced OCR.

Introduce personalized recipe recommendations using AI.

Expand deployment to a cloud-based backend for scalability.

📝 License

This project is not licensed under any License. Feel free to use, modify, and distribute it as per the license terms.
