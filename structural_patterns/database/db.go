package database

import (
	"time"

	"weather-app/weather/model"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

var seedDataList = []model.Weather{
	{
		City:       "Krakow",
		Temp:       10.5,
		Lat:        50.0647,
		Lon:        19.9450,
		MeasuredAt: time.Now().UTC(),
	},
	{
		City:       "Warszawa",
		Temp:       12.0,
		Lat:        52.2297,
		Lon:        21.0122,
		MeasuredAt: time.Now().UTC(),
	},
}

func InitDB() {
	var err error
	DB, err = gorm.Open(sqlite.Open("weather.db"), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}

	DB.AutoMigrate(&model.Weather{})
}

func SeedData() {
	var count int64
	DB.Model(&model.Weather{}).Count(&count)

	if count == 0 {
		for _, w := range seedDataList {
			DB.Create(&w)
		}
	}
}
	
