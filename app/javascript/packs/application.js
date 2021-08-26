// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Handler when the DOM is fully loaded
document.addEventListener("DOMContentLoaded", () => {
  /*****************************************
   ********* submit_forecasts start ********
   *****************************************/
  // Handle changing form content based on selected team
  let userDetailsForm = document.getElementById("forecast-user-details-form")
  document.querySelector("#forecast-user-details-form #team-name")
    .addEventListener('change', (e) => {
      Rails.fire(userDetailsForm, 'submit')
    })

  // Take email from details and add to the forecast form
  document.querySelector("#forecast-user-details-form #member-emails")
    .addEventListener('change', (e) => {
      let formButton = document.querySelector("#forecast-form #forecast-submit")
      // Disable until complete transition
      if (formButton) {
        formButton.disabled = true
      }
      let memberSelect = document.querySelector("#forecast-user-details-form #member-emails")
      document.querySelector("#member-email").textContent = memberSelect.options[memberSelect.selectedIndex].textContent
      document.querySelector("#forecast-form #member-id").value = memberSelect.value
      // Re-enable button
      if (formButton) {
        formButton.disabled = false
      }
    })

  /***************************************
   ********* submit_forecasts end ********
   ***************************************/
})