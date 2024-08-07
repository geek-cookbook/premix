

<!-- 

(o_
//\
V_/_   "Greetings, fellow geek! 👩🏻‍💻"

Thank you for submitting this PR!

The idea here is to _quickly_ create a PR, with a minimum of text entry,
followed by a checklist-driven ready-for-review process.

-->

## Summary

Description:

<!-- Briefly describe your PR -->


<!--
You can save here, and complete the checklist below using the 
UI! 👍   
-->

## ✅ Checklist

Every recipe in premix has to pass CI, and be installable via the ansible playbook. To be sure that your change will pass CI, please review the following checklist:

### Docker Swarm 

- [ ] Create the docker-compose file as `/<recipe name>/<recipe name>.yml`
- [ ] Create the env file (*even if it's empty*) exists at `/<recipe name>/<recipe name>.env-sample`

### Docker Swarm + Kubernetes 

- [ ] Update `deploy.yml` with the recipe name (*follow the existing conventions*)
- [ ] Update `group_vars/all/main.yml`, adding the recipe as **disabled** in `recipe_default_config`
- [ ] Update `group_vars/ci/main.yml`, adding the recipe as **enabled** in `recipe_default_config`
- [ ] Consider updating `.github/CODEOWNERS` so that you'll be automatically included as a reviewer on future changes to this recipe

Yours in geekery!
David
