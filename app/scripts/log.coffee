"use strict"

###
log.service provides a logging service.

log extend the angular service `$log` by adding the `assert` method,
which will raise an error. It also, provides a way to silence errors,
by setting the config constant LOG_LEVEL in config module.

possible values: 'disable' || 'assert' || 'error' || 'warn' || 'info' || 'debug'
###

# TODO: should assert be in it's own service?
angular.module("log", ["config"])

.factory "log", [
  "config",
  "$log",

(config, $log) ->
  consoleLog = (type) ->
    (a, b) ->
      
      # FIXIT clean up.
      if logMap[type] >= logMap[config.LOG_LEVEL]
        if type is "assert"
          new Error("assertion failed: " + b)  unless a
        else
          $log[type] a
  logMap =
    disable: 0
    assert: 1
    error: 2
    warn: 3
    info: 2
    debug: 4

  log: consoleLog("log")
  warn: consoleLog("warn")
  info: consoleLog("info")
  error: consoleLog("error")
  assert: consoleLog("assert")
]
