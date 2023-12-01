package logAndOptions

import (
	"os"
)

type Options struct {
	Logger  *Logger
	EnvVars map[string]string
}

type EnvVar struct {
	Name         string
	DefaultValue string
}

func IstantiateEnvOptions() (*Options, error) {
	log, logError := InstantiateLogger()

	if logError != nil {
		return nil, logError
	}

	optionsToReturn := &Options{
		Logger:  log,
		EnvVars: map[string]string{},
	}

	return optionsToReturn, nil
}

func (options *Options) ParseEnvVariables(envVars []*EnvVar) {
	options.Logger.Debugf("Starting process to collect env variables")

	for name, eVar := range envVars {
		providedValue, isPresent := os.LookupEnv(eVar.Name)

		if isPresent {
			options.Logger.Debugf("Variable %s provided with value %s", name, providedValue)
			options.EnvVars[eVar.Name] = providedValue

		} else {
			options.Logger.Debugf("Setting default value %s for env var %s", eVar, name)
			options.EnvVars[eVar.Name] = eVar.DefaultValue
		}
	}
}
