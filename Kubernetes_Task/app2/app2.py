import requests
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def reverse_message():
    # Fetch JSON from the first application (app1)
    response = requests.get("http://app1:5000")
    
    # Check if the response was successful
    if response.status_code == 200:
        data = response.json()
        reversed_message = data["message"][::-1]
        return jsonify({"id": data["id"], "message": reversed_message})
    else:
        return jsonify({"error": "Failed to fetch message from app1"}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5001)
