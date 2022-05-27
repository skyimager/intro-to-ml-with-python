from flask import Flask, jsonify,request
import joblib
import pandas as pd

app = Flask(__name__)

@app.route('/')
def home():
    return "Success"

@app.route('/predict', methods=['POST'])
def predict():
    json_ = request.get_json(silent=True)
#     print(json_)
    message=json_.get('message')
#     print(message)
    mydf = pd.DataFrame({'message':message})
#     print(mydf)
    prediction = clf.predict_proba(mydf['message'])
    return jsonify({'prediction': prediction.tolist()})

if __name__ == '__main__':
    mymodel=open('my_model_pipeline.pkl','rb')
    clf=joblib.load(mymodel)
    app.run(port=5000)