package weather

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func GetWeather(c echo.Context) error {
	city := c.QueryParam("city")

	if city == "" {
		return c.JSON(http.StatusBadRequest, map[string]string{
			"error": "city required",
		})
	}

	proxy := WeatherProxy{}

	data, err := proxy.GetWeather(city)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"error": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, data)
}

