from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
import joblib

app = Flask(__name__)
CORS(app)  # Add this line to enable CORS

# Load the trained model
model = joblib.load("emission_model.pkl")

# Load feature names
feature_names = joblib.load("feature_names.pkl")

def predict_emissions(vehicle_type, fuel_type, vehicle_age):
    input_data = {
        f'vehicle_type_{vehicle_type.capitalize()}': [1],
        'fuel_type_Diesel': [1 if fuel_type.lower() == 'diesel' else 0],
        'fuel_type_Petrol': [1 if fuel_type.lower() == 'petrol' else 0],
        'vehicle_age': [vehicle_age]
    }
    input_df = pd.DataFrame(input_data)
    for col in feature_names:
        if col not in input_df.columns:
            input_df[col] = 0
    input_df = input_df[feature_names]
    prediction = model.predict(input_df)
    return prediction[0]

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    vehicle_type = data['vehicle_type']
    fuel_type = data['fuel_type']
    vehicle_age = data['vehicle_age']
    predicted_emissions = predict_emissions(vehicle_type, fuel_type, vehicle_age)
    response = {
        "CO2_emission": predicted_emissions[0],
        "NOx_Emissions": predicted_emissions[1],
        "PM2.5_Emissions": predicted_emissions[2],
        "VOC_Emissions": predicted_emissions[3],
        "SO2_Emissions": predicted_emissions[4]
    }
    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)