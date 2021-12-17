package main

import (
	"context"
	"fmt"

	"github.com/sirupsen/logrus"

	"github.com/kanziw/deploybot/config"
	"github.com/kanziw/go-slack"
)

func main() {
	logrus.SetFormatter(&logrus.JSONFormatter{})
	log := logrus.StandardLogger()

	setting := config.NewSetting()
	_ = config.NewConfig(setting)

	socketSvr := slack.NewSocketServer(setting.SlackBotToken, setting.SlackSocketModeToken)

	socketSvr.OnAppMentionCommand("deploy", func(ctx context.Context, b *slack.AppMentionEvent, api *slack.Client, args []string) error {
		for i, v := range args {
			fmt.Printf("%d -> %s\n", i, v)
		}

		return nil
	})

	go socketSvr.Listen()

	if err := socketSvr.Run(); err != nil {
		log.WithError(err).Fatal()
	}
}
