import { app } from '../server'
import request from 'supertest'

describe('express app', () => {
  test('server running', async () => {
    const response = await request(app).get('/')
    expect(response.status).toBe(200)
  })
})
