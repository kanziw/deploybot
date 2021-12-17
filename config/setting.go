package config

import (
	"os"
	"strconv"

	log "github.com/sirupsen/logrus"
)

type Setting struct {
	ServiceName string

	SlackBotToken        string
	SlackSocketModeToken string
}

func NewSetting() Setting {
	return Setting{
		ServiceName: "deploybot",

		SlackBotToken:        getEnv("SLACK_BOT_TOKEN", ""),
		SlackSocketModeToken: getEnv("SLACK_SOCKET_MODE_TOKEN", ""),
	}
}

func MockSetting() Setting {
	return NewSetting()
}

func getEnv(key, defaultValue string) (value string) {
	value = os.Getenv(key)
	if value == "" {
		if defaultValue != "" {
			value = defaultValue
		} else {
			log.Fatalf("missing required environment variable: %v", key)
		}
	}
	return value
}

func mustAtoi(s string) int {
	i, err := strconv.Atoi(s)
	if err != nil {
		log.Panic(err)
	}
	return i
}
