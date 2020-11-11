import { app } from './server'

function add (a: number, b: number):number {
  return a + b
}

console.log('Runner', add(4, 35))

app.listen(3000, () => {
  console.log('listening on *:3000')
})
