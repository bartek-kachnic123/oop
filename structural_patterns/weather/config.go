package weather

const (
	NominatimURL = "https://nominatim.openstreetmap.org/search?q=%s&format=json&limit=1"
	OpenMeteoURL = "https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current=temperature_2m"
	UserAgent    = "go-weather-app"
	CacheMinutes = 5
)

