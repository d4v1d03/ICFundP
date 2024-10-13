import Nat "mo:base/Nat";
import Array "mo:base/Array";

actor CrowdfundingPlatform {

  type Project = {
    name: Text;
    description: Text;
    goal: Nat;
    var fundsRaised: Nat;
    var active: Bool;
  };

  type Contributor = {
    name: Text;
    contributedAmount: Nat;
  };

  var projects: [Project] = [];
  var contributors: [Contributor] = [];

  public func createProject(name: Text, description: Text, goal: Nat): async Text {
    let newProject = {
      name = name;
      description = description;
      goal = goal;
      var fundsRaised = 0;
      var active = true;
    };
  projects := Array.append<Project>(projects, [newProject]);
    return "Project '" # name # "' has been created successfully with a goal of $" # Nat.toText(goal) # "!";
  };

  public func donateToProject(projectName: Text, donorName: Text, amount: Nat): async Text {
    let projectIndex = findProjectIndex(projectName);
    switch (projectIndex) {
      case (?index) {
        let project = projects[index];
        if (not project.active) {
          return "The project '" # projectName # "' is no longer active.";
        };
        
        projects[index].fundsRaised := project.fundsRaised + amount;
        
        let newContributor = { name = donorName; contributedAmount = amount };
        contributors := Array.append(contributors, [newContributor]);
        
        if (projects[index].fundsRaised >= projects[index].goal) {
          projects[index].active := false;
          return "Thank you, " # donorName # "! Your donation of $" # Nat.toText(amount) #
                 " has helped reach the goal for the project '" # projectName # "'!";
        } else {
          return "Thank you, " # donorName # "! You have donated $" # Nat.toText(amount) #
                 " to '" # projectName # "'. Funds raised so far: $" # Nat.toText(projects[index].fundsRaised) #
                 " out of $" # Nat.toText(project.goal) # ".";
        };
      };
      case (null) {
        return "Project '" # projectName # "' not found.";
      };
    };
  };

  public query func checkProjectStatus(projectName: Text): async Text {
    let projectIndex = findProjectIndex(projectName);
    switch (projectIndex) {
      case (?index) {
        let project = projects[index];
        return "Project: '" # project.name # "'\n" #
               "Description: " # project.description # "\n" #
               "Funds Raised: $" # Nat.toText(project.fundsRaised) # " out of $" # Nat.toText(project.goal) # "\n" #
               "Status: " # (if (project.active) { "Active" } else { "Completed" });
      };
      case (null) {
        return "Project '" # projectName # "' not found.";
      };
    };
  };

  public query func listActiveProjects(): async [Text] {
    let activeProjects = Array.filter(projects, func(p: Project) : Bool { p.active });
    return Array.map(activeProjects, func(p: Project) : Text { p.name # ": $" # Nat.toText(p.fundsRaised) # " / $" # Nat.toText(p.goal) });
  };

  public query func listContributors(): async [(Text, Nat)] {
return Array.map<Contributor, (Text, Nat)>(contributors, func(c: Contributor): (Text, Nat) {
  return (c.name, c.contributedAmount);
});
  };

  public func withdrawFunds(projectName: Text, amount: Nat): async Text {
    let projectIndex = findProjectIndex(projectName);
    switch (projectIndex) {
      case (?index) {
        let project = projects[index];
        if (project.active) {
          return "The project '" # projectName # "' is still active. You cannot withdraw funds yet.";
        } else if (project.fundsRaised < amount) {
          return "Insufficient funds to withdraw. The project '" # projectName # "' only has $" # Nat.toText(project.fundsRaised) # ".";
        } else {
          projects[index].fundsRaised := project.fundsRaised - amount;
          return "Successfully withdrawn $" # Nat.toText(amount) # " from project '" # projectName # "'. Remaining balance: $" # Nat.toText(project.fundsRaised) # ".";
        };
      };
      case (null) {
        return "Project '" # projectName # "' not found.";
      };
    };
  };

  private func findProjectIndex(projectName: Text): ?Nat {
   var i = 0;
   while (i < projects.size()) {
     if (projects[i].name == projectName) {
       return ?i;  
     };
     i += 1;
   };
   return null;  
};

}
