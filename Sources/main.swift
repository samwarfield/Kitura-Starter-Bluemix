/**
* Copyright IBM Corporation 2016
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
**/

// Kitura-Starter-Bluemix shows examples for creating custom routes.
import Foundation
import Kitura
import KituraSys
import KituraNet
import LoggerAPI
import HeliumLogger
import CFEnvironment

// All web apps need a Router instance to define routes
let router = Router()

// Using the HeliumLogger implementation for Logger
Log.logger = HeliumLogger()

// Serve static content from "public"
router.all("/static", middleware: StaticFileServer())

// Basic GET request
router.get("/hello") { _, response, next in
  response.setHeader("Content-Type", value: "text/plain; charset=utf-8")
  do {
    try response.status(HttpStatusCode.OK).send("Hello from Kitura-Starter-Bluemix!").end()
  } catch {
    Log.error("Failed to send response to client: \(error)")
  }
}

// Basic POST request
router.post("/hello") { request, response, next in
  response.setHeader("Content-Type", value: "text/plain; charset=utf-8")
  do {
    if let name = try request.readString() {
      try response.status(HttpStatusCode.OK).send("Hello \(name), from Kitura-Starter-Bluemix!").end()
    } else {
      try response.status(HttpStatusCode.OK).send("Kitura-Starter-Bluemix received a POST request!").end()
    }
  } catch {
    Log.error("Failed to send response to client: \(error)")
  }
}

// Start Kitura-Starter-Bluemix server
do {
  let appEnv = try CFEnvironment.getAppEnv()
  let port: Int = appEnv.port
  let server = HttpServer.listen(port: port, delegate: router)
  Server.run()
  Log.info("Server is started on \(appEnv.url).")
} catch CFEnvironmentError.InvalidValue {
  Log.error("Oops... something went wrong. Server did not start!")
}
