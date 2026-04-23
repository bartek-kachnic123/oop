package main

import (
	"weather-app/database"
	"weather-app/weather"

	"github.com/labstack/echo/v4"
)

func main() {
	database.InitDB()
	database.SeedData()

	e := echo.New()

	e.GET("/weather", weather.GetWeather)

	e.Logger.Fatal(e.Start(":8080"))
}

