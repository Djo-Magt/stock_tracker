import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form", "items"]

  connect() {
    // Initial connection logic, if necessary
  }

  send(event) {
    event.preventDefault()
    const url = this.formTarget.action
    const formData = new FormData(this.formTarget)

    fetch(url, {
      method: 'GET',
      headers: {
        'Accept': 'application/json'
      },
      body: formData
    })
      .then(response => response.json())
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok')
        }
        return response.json()
      })
      .then(data => {
        this.itemsTarget.innerHTML = data.html
      })
      .catch(error => {
        console.error('Error:', error)
      })
    }
}
