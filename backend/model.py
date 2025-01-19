import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
import joblib

data = pd.read_csv("vehicle_emission_dataset.csv")
data = data[['vehicle_type', 'fuel_type', 'vehicle_age', 'CO2_emission', 
             'NOx_Emissions', 'PM2.5_Emissions', 'VOC_Emissions', 'SO2_Emissions']]
data = pd.get_dummies(data, columns=['vehicle_type', 'fuel_type'], drop_first=True)
X = data.drop(columns=['CO2_emission', 'NOx_Emissions', 'PM2.5_Emissions', 
                       'VOC_Emissions', 'SO2_Emissions'])
y = data[['CO2_emission', 'NOx_Emissions', 'PM2.5_Emissions', 'VOC_Emissions', 'SO2_Emissions']]
feature_names = X.columns
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model = RandomForestRegressor(random_state=42)
model.fit(X_train, y_train)
joblib.dump(model, "emission_model.pkl")
joblib.dump(feature_names, "feature_names.pkl")