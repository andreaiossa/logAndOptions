package logAndOptions

import (
	"os"

	"github.com/TwiN/go-color"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

type Logger struct {
	Log *zap.SugaredLogger
}

func InstantiateLogger() (*Logger, error) {

	config := zap.NewDevelopmentEncoderConfig()
	config.EncodeLevel = zapcore.CapitalColorLevelEncoder
	consoleEncoder := zapcore.NewConsoleEncoder(config)

	consoleDebugging := zapcore.Lock(os.Stdout)
	// consoleErrors := zapcore.Lock(os.Stderr)

	core := zapcore.NewTee(
		zapcore.NewCore(consoleEncoder, consoleDebugging, zap.DebugLevel),
		// zapcore.NewCore(consoleEncoder, consoleErrors, zap.ErrorLevel),
	)

	logger := zap.New(core)
	defer logger.Sync()
	sugar := logger.Sugar()
	log := &Logger{Log: sugar}

	log.Debugf("Logger istantiated successfully")

	return log, nil
}

func colorString(template string) string {
	toReturn := ""
	colorPhase := false
	sliceTemplate := []rune(template)
	for i := 0; i < len(sliceTemplate); i++ {
		if colorPhase {
			if sliceTemplate[i] == ' ' {
				toReturn += string(sliceTemplate[i]) + color.Reset
				colorPhase = false
			} else {
				toReturn += string(sliceTemplate[i])
			}
		} else {
			if sliceTemplate[i] == '%' {
				colorPhase = true
				toReturn += color.Cyan
			}
			toReturn += string(sliceTemplate[i])
		}
	}
	toReturn += color.Reset

	return toReturn
}

func (l *Logger) Infof(template string, rest ...interface{}) {
	toPrint := colorString(template)
	l.Log.Infof(toPrint, rest...)
}

func (l *Logger) Warnf(template string, rest ...interface{}) {
	toPrint := colorString(template)
	l.Log.Warnf(toPrint, rest...)
}

func (l *Logger) Debugf(template string, rest ...interface{}) {
	toPrint := colorString(template)
	l.Log.Debugf(toPrint, rest...)
}

func (l *Logger) Errorf(template string, rest ...interface{}) {
	toPrint := colorString(template)
	l.Log.Errorf(toPrint, rest...)
}
