import express from 'express'
import cors from 'cors'
import morgan from 'morgan'

export const app = express()
const APP_NAME = process.env.APP_NAME

app.use(cors())
app.use(morgan('tiny'))

app.get('/', (_req, res) => {
  res.json({
    env: APP_NAME
  })
})
