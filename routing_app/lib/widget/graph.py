import requests
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

# Function to fetch data from the API
def fetch_pm25_data(latitude=28.70, longitude=77.10, token="c2462c6c46be8a23f08c47b110d493265397d745"):
    url = f"https://api.waqi.info/feed/geo:{28.70};{77.10}/?token={token}"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        if data.get("status") == "ok":
            return data["data"]["forecast"]["daily"]["pm25"]
        else:
            raise ValueError("Invalid response from API: " + data.get("data", {}).get("message", "Unknown error"))
    else:
        response.raise_for_status()

# Function to get color and label based on PM2.5 level
def get_pm25_label_and_color(value):
    if value <= 50:
        return "Good", "green"
    elif 51 <= value <= 100:
        return "Moderate", "yellow"
    elif 101 <= value <= 150:
        return "Unhealthy", "orange"
    elif 151 <= value <= 200:
        return "Unhealthy", "red"
    else:
        return "Very Unhealthy", "darkred"

# Function to plot PM2.5 data as colorful boxes with dates
def plot_pm25_boxes(pm25_data):
    fig, ax = plt.subplots(figsize=(12, 2))
    ax.axis("off")  # Hide axes
    
    x_start = 0  # Initial x-coordinate
    box_width = 1.5  # Width of each box
    padding = 0.1  # Space between boxes

    for day_data in pm25_data[:5]:
        avg_value = day_data["avg"]
        label, color = get_pm25_label_and_color(avg_value)
        date = day_data["day"]  # Extract the date

        # Draw rectangle (box)
        rect = Rectangle((x_start, 0), box_width, 1, color=color, ec="black")
        ax.add_patch(rect)

        # Add text inside the box (PM2.5 value and label)
        ax.text(x_start + box_width / 2, 0.6, str(avg_value), ha="center", va="center", fontsize=12, color="black")
        ax.text(x_start + box_width / 2, 0.2, label, ha="center", va="center", fontsize=10, color="white")
        
        # Add date below the box
        ax.text(x_start + box_width / 2, -0.2, date, ha="center", va="center", fontsize=10, color="black")

        # Move to the next position
        x_start += box_width + padding

    # Adjust limits to fit all boxes and labels
    ax.set_xlim(0, x_start)
    ax.set_ylim(-0.3, 1)
    plt.title("PM2.5 Forecast (Average Levels)", fontsize=16)
    plt.tight_layout()
    plt.show()

# Example usage
latitude = 26.268249  # Replace with your latitude
longitude = 73.0193853  # Replace with your longitude
try:
    pm25_forecast = fetch_pm25_data(latitude, longitude)
    plot_pm25_boxes(pm25_forecast)
except Exception as e:
    print("Error:", e)
