{Build, Connection, KeplerError, Project, Screenshot} = require './api'


conn = new Connection('http://localhost:4602')

proj = new Project(conn, 'hello-1f23', '7ad0714d762e48e0a3c6c136aa028451')

proj.defaults =
    'versions': ['iphone-portrait', 'imac']
    'delay': 0

build = proj.build(
    'hello': 'world'
)

shot = build.capture('https://google.com', 'google-homepage', {'ohai': 1})
