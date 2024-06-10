from flask import Flask, render_template, request,send_file
import pandas as pd
import torch
import torch.nn as nn
from sklearn.preprocessing import LabelEncoder
import seaborn as sns
import matplotlib.pyplot as plt

app = Flask(__name__)

path = r'F:\SEMESTER8\semester_8\flask\FINAL1.xlsx'
df = pd.read_excel(path)
df['Date'] = pd.to_datetime(df['Date'])

# Extract features for prediction (day of the week)
X_pred = df[['Area', 'City', 'Day']]
label_encoder_X = LabelEncoder()
X_pred_encoded = X_pred.apply(lambda col: label_encoder_X.fit_transform(col.astype(str)))
X_pred_tensor = torch.tensor(X_pred_encoded.values, dtype=torch.float32)

label_encoder_y = LabelEncoder()
df['crime_type_encoded'] = label_encoder_y.fit_transform(df['Crime Type'])
# Load your pre-trained DNN model
class DeepNN(nn.Module):
    def __init__(self, input_size, hidden_size1, hidden_size2, output_size):
        super(DeepNN, self).__init__()
        self.fc1 = nn.Linear(input_size, hidden_size1)
        self.relu1 = nn.ReLU()
        self.fc2 = nn.Linear(hidden_size1, hidden_size2)
        self.relu2 = nn.ReLU()
        self.fc3 = nn.Linear(hidden_size2, output_size)
        self.dropout = nn.Dropout(0.5)  # Dropout layer with 50% dropout probability
        self.batch_norm1 = nn.BatchNorm1d(hidden_size1)  # Batch normalization layer after first hidden layer
        self.batch_norm2 = nn.BatchNorm1d(hidden_size2)  # Batch normalization layer after second hidden layer

    def forward(self, x):
        x = self.fc1(x)
        x = self.batch_norm1(x)
        x = self.relu1(x)
        x = self.dropout(x)
        x = self.fc2(x)
        x = self.batch_norm2(x)
        x = self.relu2(x)
        x = self.dropout(x)
        x = self.fc3(x)
        return x

    
model = DeepNN(input_size=X_pred_tensor.shape[1], hidden_size1=30, hidden_size2=30,output_size=len(df['crime_type_encoded'].unique()))
model.load_state_dict(torch.load(r'F:\SEMESTER8\semester_8\flask\crime_model.pth'))
model.eval()


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
        json_data = request.get_json()
        print('Incoming JSON data:', json_data)

        # Extract values of 'day', 'city', and 'area' from JSON data
        day = json_data.get('day')
        city = json_data.get('city')
        area = json_data.get('area')
        print('Extracted values - day:', day, 'city:', city, 'area:', area)

        filter_condition = (df['Day'] == day) & (df['City'] == city)& (df['Area'] == area)
        input_data = X_pred_tensor[filter_condition]

        # Make predictions using the trained model
        with torch.no_grad():
            predictions = model(input_data)
            probabilities = nn.functional.softmax(predictions, dim=1).numpy()
        # Map the encoded labels back to crime types
        decoded_labels = label_encoder_y.inverse_transform(range(len(probabilities[0])))
        # Create a bar graph
        plt.figure(figsize=(10, 6))
        sns.barplot(x=decoded_labels, y=probabilities[0], palette='viridis')
        plt.xlabel('Crime Type')
        plt.ylabel('Probability')
        plt.title(f'Crime Probability Distribution for Day {day} in {city}')
        plt.savefig('static/plot.png')

        return send_file('static/plot.png', mimetype='image/png')
        #return render_template('result.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
