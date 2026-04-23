package main

import (
	"weather-app/weather"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	e.GET("/weather", weather.GetWeather)

	e.Logger.Fatal(e.Start(":8080"))
}

