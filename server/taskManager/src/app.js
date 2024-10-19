const express = require('express')
const cors = require('cors')

const app = express()

require('dotenv').config()

const corsOptions = {
    origin: 'frontendserver',
    optionsSuccessStatus: 200
}

app.use(express.json())
app.use(cors(corsOptions))

const Task = require('./routes/taskRoute')
app.use('/tasks', Task)

module.exports = app