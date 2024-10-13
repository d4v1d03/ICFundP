import { backend } from "../../backend"

function showNotification(message) {
  const notification = document.getElementById("notification")
  notification.innerText = message
  notification.style.display = "block"
  setTimeout(() => {
    notification.style.display = "none"
  }, 3000)
}

async function createProject() {
  const name = document.getElementById("projectName").value
  const description = document.getElementById("projectDescription").value
  const goal = Number(document.getElementById("projectGoal").value)

  if (!name || !description || !goal) {
    document.getElementById("createResult").innerText =
      "Please fill out all fields."
    return
  }

  try {
    const result = await backend.createProject(name, description, goal)
    document.getElementById("createResult").innerText = result

    showNotification(result)
  } catch (err) {
    console.error("Failed to create project:", err)
    document.getElementById("createResult").innerText =
      "Error creating project."
  }
}

async function donate() {
  const projectName = document.getElementById("donateProjectName").value
  const donorName = document.getElementById("donorName").value
  const amount = Number(document.getElementById("donateAmount").value)

  if (!projectName || !donorName || !amount) {
    document.getElementById("donateResult").innerText =
      "Please fill out all fields."
    return
  }

  try {
    const result = await backend.donateToProject(projectName, donorName, amount)
    document.getElementById("donateResult").innerText = result

    showNotification(result)
  } catch (err) {
    console.error("Failed to donate:", err)
    document.getElementById("donateResult").innerText =
      "Error donating to project."
  }
}

async function fetchProjects() {
  try {
    const projects = await backend.getProjects()
    const projectsList = document.getElementById("projectsList")
    projectsList.innerHTML = ""

    projects.forEach((project) => {
      const listItem = document.createElement("li")
      listItem.innerText = `Project: ${project.name}, Goal: ${project.goal} ICP, Funds Raised: ${project.fundsRaised} ICP`
      projectsList.appendChild(listItem)
    })
  } catch (err) {
    console.error("Failed to fetch projects:", err)
    document.getElementById("projectsList").innerText =
      "Error fetching projects."
  }
}
