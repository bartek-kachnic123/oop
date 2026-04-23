package weather

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"

	"github.com/labstack/echo/v4"
)

type NominatimResponse []struct {
	Lat string `json:"lat"`
	Lon string `json:"lon"`
}

type WeatherResponse struct {
	Current struct {
		Temperature float64 `json:"temperature_2m"`
	} `json:"current"`
}

func getCoordinates(city string) (string, string, error) {
	url := fmt.Sprintf(
		"https://nominatim.openstreetmap.org/search?q=%s&format=json&limit=1",
		city,
	)

	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Set("User-Agent", "go-weather-app")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return "", "", err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)

	var data NominatimResponse
	json.Unmarshal(body, &data)

	if len(data) == 0 {
		return "", "", fmt.Errorf("not found")
	}

	return data[0].Lat, data[0].Lon, nil
}

func getWeather(lat, lon string) (WeatherResponse, error) {
	url := fmt.Sprintf(
		"https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&current=temperature_2m",
		lat, lon,
	)

	resp, err := http.Get(url)
	if err != nil {
		return WeatherResponse{}, err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)

	var weather WeatherResponse
	json.Unmarshal(body, &weather)

	return weather, nil
}

func GetWeather(c echo.Context) error {
	city := c.QueryParam("city")

	if city == "" {
		return c.JSON(400, map[string]string{"error": "city required"})
	}

	lat, lon, err := getCoordinates(city)
	if err != nil {
		return c.JSON(500, map[string]string{"error": err.Error()})
	}

	weather, err := getWeather(lat, lon)
	if err != nil {
		return c.JSON(500, map[string]string{"error": err.Error()})
	}

	return c.JSON(200, weather)
}

