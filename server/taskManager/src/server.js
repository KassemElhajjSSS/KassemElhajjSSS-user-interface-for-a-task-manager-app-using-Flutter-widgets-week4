const app = require('./app')
const db = require('../models')

const PORT = process.env.PORT || 3000

db.sequelize.sync().then((req) => {
    app.listen(PORT, () => {
        console.log(`Server is running on PORT = ${PORT}`)
    })
})

//to start the server write on the console taskManaget> nodemon server.js