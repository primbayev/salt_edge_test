import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="connect-sessions"
export default class extends Controller {
  connect() {
    location.href = document.getElementById('url_location').classList[0];
  }
}
