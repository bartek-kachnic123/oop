package weather

import (
	"net/http"
	"time"

	"weather-app/database"
	"weather-app/weather/model"

	"github.com/labstack/echo/v4"
)

func GetWeather(c echo.Context) error {
	city := c.QueryParam("city")

	if city == "" {
		return c.JSON(http.StatusBadRequest, map[string]string{
			"error": "city required",
		})
	}

	var dbWeather model.Weather
	now := time.Now().UTC()

	err := database.DB.
		Where("city = ?", city).
		Order("measured_at desc").
		First(&dbWeather).Error

	if err == nil {
		if now.Sub(dbWeather.MeasuredAt) < CacheMinutes*time.Minute {
			return c.JSON(http.StatusOK, WeatherDTO{
				City:        dbWeather.City,
				Temp:        dbWeather.Temp,
				Lat:         dbWeather.Lat,
				Lon:         dbWeather.Lon,
			})
		}
	}

	proxy := WeatherProxy{}

	data, err := proxy.GetWeather(city)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"error": err.Error(),
		})
	}

	d := model.Weather{
		City:        data.City,
		Temp:        data.Temp,
		Lat:         data.Lat,
		Lon:         data.Lon,
		MeasuredAt:  now,
	}

	database.DB.Create(&d)

	return c.JSON(http.StatusOK, data)
}

