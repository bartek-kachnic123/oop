package weather

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strconv"
)

type NominatimResponse []struct {
	Lat string `json:"lat"`
	Lon string `json:"lon"`
}

type OpenMeteoResponse struct {
	Current struct {
		Temperature float64 `json:"temperature_2m"`
	} `json:"current"`
}

type WeatherProxy struct{}

func (p WeatherProxy) GetWeather(city string) (WeatherDTO, error) {

	lat, lon, err := p.getCoordinates(city)
	if err != nil {
		return WeatherDTO{}, err
	}

	url := fmt.Sprintf(OpenMeteoURL, lat, lon)

	resp, err := http.Get(url)
	if err != nil {
		return WeatherDTO{}, err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)

	var weather OpenMeteoResponse
	json.Unmarshal(body, &weather)
	
	return WeatherDTO{
		City:        city,
		Temp: weather.Current.Temperature,
		Lat:         lat,
		Lon:         lon,
	}, nil
}

func (p WeatherProxy) getCoordinates(city string) (float64, float64, error) {

	url := fmt.Sprintf(NominatimURL, city)

	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Set("User-Agent", UserAgent)

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return 0, 0, err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)

	var geo NominatimResponse
	json.Unmarshal(body, &geo)

	if len(geo) == 0 {
		return 0, 0, fmt.Errorf("city not found")
	}

	lat, err := strconv.ParseFloat(geo[0].Lat, 64)
	if err != nil {
		return 0, 0, err
	}

	lon, err := strconv.ParseFloat(geo[0].Lon, 64)
	if err != nil {
		return 0, 0, err
	}

	return lat, lon, nil
}

