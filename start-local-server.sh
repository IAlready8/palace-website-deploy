#!/bin/bash
# Simple local server for testing
echo "Starting Palace website local server..."
echo "Open http://localhost:8000 in your browser."
echo "Press Ctrl+C to stop the server."
echo "Note: This simple server does NOT support SPA rewrites for deep links."
echo "      For deep links (e.g., /product/1), use: npx serve -s ."
echo ""

if command -v python3 &> /dev/null; then
    echo "Using Python 3..."
    python3 -m http.server 8000
elif command -v python &> /dev/null; then
    echo "Using Python 2..."
    python -m SimpleHTTPServer 8000
else
    echo "Python not found. Please install Python or use a different web server."
    echo "Alternative: Use 'npx serve .' if you have Node.js installed"
fi
