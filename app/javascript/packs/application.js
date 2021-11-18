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
document.addEventListener("turbolinks:load", () => {
  /*****************************************
   ********* submit_forecasts start ********
   *****************************************/
   const checkStorageForForecast = () => {
    let member = document.querySelector("#forecast-form #member-emails")
    let forecastForm = document.getElementById("forecast-form")
    if (forecastForm && member) {
      let inputs = forecastForm.elements
      let storedValues = JSON.parse(localStorage.getItem(`${member.value};${forecastForm.dataset.date}`))
      if (storedValues) {
        for (let i = 0; i < inputs.length; i++) {
          if (inputs[i].name && 
            inputs[i].name.toLowerCase() != "authenticity_token" &&
            inputs[i].name.toLowerCase() != "member_forecast[team_monthly_forecast_id]" &&
            inputs[i].name.toLowerCase() != "member_forecast[member_id]") {
            if (storedValues[inputs[i].name]) {
              inputs[i].value = storedValues[inputs[i].name]
            }
          }
        }
        return true
      } else {
        return false
      }
    }
  }

  // Handle changing form content based on selected team
  const userDetailsForm = document.getElementById("forecast-user-details-form")
  const userDetailsFormTeamField = document.querySelector("#forecast-user-details-form #user-details-team-id")
  const teamSelector = document.querySelector("#forecast-form #team-id")
  if (teamSelector && userDetailsFormTeamField && userDetailsForm) {
    teamSelector.addEventListener('change', (e) => {
      userDetailsFormTeamField.value = teamSelector.value 
      Rails.fire(userDetailsForm, 'submit')
    })
  }

  // rebind event listener on member change
  if (userDetailsForm) {
    userDetailsForm.addEventListener("ajax:success", () => {
      bindMemberChangeHandler()
      checkStorageForForecast()
      countHours()
    })
    userDetailsForm.addEventListener("ajax:error", () => {
      location.reload()
    })
  }

  const bindMemberChangeHandler = () => {
    const memberEmailSelector = document.querySelector("#forecast-form #member-emails")
    if (memberEmailSelector) {
      memberEmailSelector.addEventListener('change', (e) => {
        let formButton = document.querySelector("#forecast-form #forecast-submit")
        // Disable until complete transition
        if (formButton) {
          formButton.disabled = true
        }
        let memberSelect = document.querySelector("#forecast-form #member-emails")
        if (memberSelect.value) {
          document.querySelector("#member-email").textContent = memberSelect.options[memberSelect.selectedIndex].textContent
        } else {
          document.querySelector("#member-email").textContent = ""
        }
        // Re-enable button
        if (formButton) {
          formButton.disabled = false
        }
        // if false, clear inputs because member changed
        if (!checkStorageForForecast()) {
          let forecastForm = document.getElementById("forecast-form")
          let inputs = forecastForm.elements
          for (let i = 0; i < inputs.length; i++) {
            if (inputs[i].name && 
              inputs[i].name.toLowerCase() != "authenticity_token" && 
              inputs[i].name.toLowerCase() != "member_forecast[team_monthly_forecast_id]" &&
              inputs[i].name.toLowerCase() != "member_forecast[member_id]") {
              if (inputs[i].name) {
                inputs[i].value = ""
              }
            }
          }
        }
      })
    }  
  }
  
  bindMemberChangeHandler()

  // Calculate hours
  on("#forecast-form-container", "input", ".hour-input", event => {
    countHours()
  })

  
  const countHours = () => {
    const expectedHoursElement = document.querySelectorAll(".expected-hours")[0]
    let expectedHours = 0
    if (expectedHoursElement) {
      expectedHours = parseInt(expectedHoursElement.innerText)
    }

    const currentHours = document.getElementById("member-hours")
    const elements = document.querySelectorAll("#forecast-form-container .hour-input")
    let total = 0
    for (let element of elements) {
      total += (parseInt(element.value) || 0)
    }
    if (currentHours) {
      currentHours.innerText = total
    }

    if (currentHours && total >= expectedHours) {
      currentHours.classList.add("text-green-600", "font-bold")
    } else if (currentHours) {
      currentHours.classList.remove("text-green-600", "font-bold")
    }
  }
  const submitForecastButton = document.querySelector("#forecast-form #forecast-submit")

  // Store the submission locally
  if (submitForecastButton) {
    submitForecastButton.addEventListener('click', (e) => {
      let forecastForm = document.getElementById("forecast-form")
      if (forecastForm) {
        let inputs = forecastForm.elements
        let memberId = document.querySelector("#forecast-form #member-emails").value
        let submission = {}
        for (let i = 0; i < inputs.length; i++) {
          if (inputs[i].name && 
            inputs[i].name.toLowerCase() != "authenticity_token" && 
            inputs[i].name.toLowerCase() != "member_forecast[team_monthly_forecast_id]" &&
            inputs[i].name.toLowerCase() != "member_forecast[member_id]") {
            submission[inputs[i].name] = inputs[i].value
          }
        }
        try {
          localStorage.setItem(`${memberId};${forecastForm.dataset.date}`, JSON.stringify(submission));
        } catch (e) {
          if ((
            // everything except Firefox
            e.code === 22 ||
            // Firefox
            e.code === 1014 ||
            // test name field too, because code might not be present
            // everything except Firefox
            e.name === 'QuotaExceededError' ||
            // Firefox
            e.name === 'NS_ERROR_DOM_QUOTA_REACHED') &&
            // acknowledge QuotaExceededError only if there's something already stored
            (storage && storage.length !== 0)) {
              let keys = []
              for ( let i = 0; i < localStorage.length; ++i ) {
                keys.append(localStorage.key(i));
              }
              // remove last 4 submissions and store again
              let sorted = keys.sort()
              for (let i = 0; sorted[i] && i < 4; i++) {
                localStorage.removeItem(sorted[i])
              }
              localStorage.setItem(`${memberId};${forecastForm.dataset.date}`, JSON.stringify(submission));
            }
        }
      }
    })
  }

  // Whenver form present and page reloads, check storage
  let forecastForm = document.getElementById("forecast-form")
  if (forecastForm) {
    checkStorageForForecast()
    countHours()
  }

  /***************************************
   ********* submit_forecasts end ********
   ***************************************/

  /*******************************
   ***** Team forecast start *****
   *******************************/

  const exportButton = document.getElementById("export-button")
  const exportOptionsWrapper = document.getElementById("export-options-wrapper")
  if (exportButton) {
    exportButton.addEventListener('click', () => {
      if (exportButton.classList.contains('active')) {
        hideExportOptions()
      } else {
        exportOptionsWrapper.classList.remove('opacity-0', 'duration-75', 'ease-in', 'scale-95', 'hidden')
        exportOptionsWrapper.classList.add('ease-out', 'duration-100', 'scale-100')
        exportButton.classList.add('active')
      }
    })

    window.addEventListener('click', (event) => {
      if (event.target != exportButton && exportButton.classList.contains('active')) {
        hideExportOptions()
      }
    })
  }

  const hideExportOptions = () => {
    exportButton.classList.remove('active')
    exportOptionsWrapper.classList.remove('ease-out', 'duration-100')
    exportOptionsWrapper.classList.add('ease-in', 'duration-75', 'opacity-0', 'scale-95', 'hidden')
  }

  /*****************************
   ***** Team forecast end *****
   *****************************/

  /***********************************
   ************** MODAL **************
   ***********************************/
  const modal = document.getElementById('modal')
  const modalOverlay = document.getElementById('modal-overlay')
  // The modal will close when clicked outside
  window.onclick = (event) => {
    if (event.target == modalOverlay) {
        modal.classList.add("hidden");
    }
  }
})

/****************************************
 ******* General helper functions *******
 ****************************************/

/* js event handler for event delegation
 * https://flaviocopes.com/javascript-event-delegation/
 * 
 * @param {STRING} selector - argument for querySelectorAll -- containing element
 * @param {STRING} eventType - event type for listener
 * @param {STRING} selector - selector of child elements under original selector
 * @param {FUNCTION} eventHandler - the event handler callback
*/
const on = (selector, eventType, childSelector, eventHandler) => {
  const elements = document.querySelectorAll(selector)
  for (let element of elements) {
    element.addEventListener(eventType, eventOnElement => {
      if (eventOnElement.target.matches(childSelector)) {
        eventHandler(eventOnElement)
      }
    })
  }
}
