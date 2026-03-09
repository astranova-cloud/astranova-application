from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Astranova DevOps Pipeline Running 🚀"

if __name__ == "__main__":
    print("Starting Astranova App...")
    app.run(host="0.0.0.0", port=3000, debug=False)
