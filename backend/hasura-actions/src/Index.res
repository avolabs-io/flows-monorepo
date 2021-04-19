Dotenv.config()
@val external port: option<string> = "process.env.PORT"

let app = Serbet.application(
  ~port=port->Option.flatMap(int_of_string_opt)->Option.getWithDefault(9898),
  list{PaymentStreamManager.createStream, AuthHook.endpoint},
)


Scheduler.startProcess()
