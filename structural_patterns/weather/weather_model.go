package weather

import (
	"time"

	"gorm.io/gorm"
)

type Weather struct {
	gorm.Model
	City       string
	Temp       float64
	Lat        float64
	Lon        float64
	MeasuredAt time.Time
}

