package weather

type WeatherDTO struct {
	City        string  `json:"city"`
	Temp        float64 `json:"temperature"`
	Lat         float64  `json:"lat"`
	Lon         float64  `json:"lon"`
}

