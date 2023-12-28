local json = require("modules.json")
local helpers = require("helpers")
local user = require("user")

local api_key = user.opweath_api
local lat = user.coordinates.lat
local lon = user.coordinates.lon
local update_interval = 1600
local units = "metric"
local tmp_file = "/tmp/awesomewm_weather_json"

local icon_map = {
	["01d"] = "",
	["02d"] = "",
	["03d"] = "",
	["04d"] = "",
	["09d"] = "",
	["10d"] = "",
	["11d"] = "",
	["13d"] = "",
	["50d"] = "",
	["01n"] = "",
	["02n"] = "",
	["03n"] = "",
	["04n"] = "",
	["09n"] = "",
	["10n"] = "",
	["11n"] = "",
	["13n"] = "",
	["50n"] = ""
}

local forecast_cmd = "curl -sf 'https://api.openweathermap.org/data/2.5/onecall?lat="
.. lat .. "&lon="
.. lon .. "&appid="
.. api_key .. "&units="
.. units .. "&exclude=minutely'"

helpers.time.remote_watch(forecast_cmd, update_interval, tmp_file, function(out)
	local decoded = json.decode(out)

	local c = decoded.current
	local weather = {
		timezone = decoded.timezone,
		current = {
			dt = c.dt,
			temp = math.floor(c.temp),
			feels_like = math.floor(c.feels_like),
			desc = c.weather[1].description:gsub("^%l", string.upper),
			icon = icon_map[c.weather[1].icon],
			humidity = math.floor(c.humidity),
			wind_speed = math.floor(c.wind_speed),
			wind_deg = c.wind_deg
		},
		hourly = {},
		daily = {}
	}

	local h = decoded.hourly
	for i = 1, #h, 2 do
		table.insert(weather.hourly, {
			dt = h[i].dt,
			temp = math.floor(h[i].temp),
			desc = h[i].weather[1].description:gsub("^%l", string.upper),
			icon = icon_map[h[i].weather[1].icon],
		})
	end

	local d = decoded.daily
	for i = 2, #d, 1 do
		table.insert(weather.daily, {
			dt = d[i].dt,
			temp_day = math.floor(d[i].temp.day),
			temp_night = math.floor(d[i].temp.night),
			desc = d[i].weather[1].description:gsub("^%l", string.upper),
			icon = icon_map[d[i].weather[1].icon],
		})
	end

	awesome.emit_signal("signal::weather", weather)
end)
