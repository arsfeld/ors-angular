module.exports =
  auth:
    LOGIN_URL: "/login"
    SUCCESS_REDIRECT_URL: "/"
    FAILURE_REDIRECT_URL: "/login"

  db: process.env.MONGOLAB_URI || "mongodb://localhost/ors-dev"

  mailer:
    auth:
      user: "test@example.com"
      pass: "secret"

    defaultFromAddress: "First Last <test@examle.com>"
