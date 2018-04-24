# Contributing

The sites, urls and additional notes are stored in `sites.json`. If you want to add a site to the list you'll need the following information:

- `name`: The name of the service.
- `url`: The url of the account-deletion page. If no such page exists, the url should be a contact or help page explaining the process of account deletion.
- `difficulty`: This is an indicator used on the site to determine the difficulty of account deletion:
    - `easy`: Sites with a simple process such as a 'delete account' button
    - `medium`: Sites that do allow account deletion but require you to perform additional steps
    - `hard`: Sites that require you to contact customer services or those that don't allow automatic or easy account deletion
    - `impossible`: For sites where it's basically impossible to totally delete your account, even if you contact them
- `notes`: *(optional)* Notes will be shown when someone hovers on that service. Notes may include additional information you might need to delete your account (e.g. Skype) or consequences of deleting your account (e.g. iTunes).
- `email`: *(optional)* If you have to send an email to a company to cancel your account, add the email address here. We'll do the rest.
- `email_subject`: *(optional)* Set the subject for the email link. If unset, the default text is "Account Deletion Request".
- `email_body`: *(optional)* Set the body for the email link. If unset, the default text is "Please delete my account, my username is XXXXXX".
- `domains`: *(optional)* This is used by the [Chrome extension](https://github.com/jdm-contrib/justdelete.me-chrome-extension)

## Contribution checklist

1. Have you updated to the latest version of the project? `git pull`
2. If you have modified an existing service's difficulty, please explain why/give sources.
3. URLs must be direct links to either deletion, or if this is not available, a relevant help article.
4. Any steps for the process should be detailed in the notes (if necessary).
5. Be sure to indent 4 spaces per level.
6. Be sure to place your entry ALPHABETICALLY in the current list.
7. Please test that your changes work validating `sites.json` with something like [JSON Lint](http://jsonlint.com/) or the included "validate_json.rb" script

## Translation

If you want to translate the site:

1. Create a new `CODE.json` file in the `_data/trans/` directory where `CODE` is your [short country code](https://en.wikipedia.org/wiki/Country_code)
2. Copy the contents of `en.json` to your new file
3. Translate each line
4. Within the `_pages/` directory, copy `_pages/index.html` to a new `CODE.html` file, and update the `lang: CODE` line to match the new page's code

### Style guide for Spanish Translations

Use guillemets (« ») for quoting statements that the website owner has published. Try to address the user as Tú instead of Usted. Write "haz clic" (hacer clic) instead of the verb "cliquear" or "clicar" because the former is the [RAE recommended way](http://lema.rae.es/dpd/srv/search?key=clic) of writing it.

### Guía de estilo para las traducciones españolas

Usa las comillas angulares (« ») para citar las declaraciones de los dueños de los sitios. Usa Tú en vez de Usted con los usarios. Escribe "haz clic" (hacer clic) en vez del verbo "cliquear" o "clicar" porque el primero oración es la manera que es [más recomendable según la RAE](http://lema.rae.es/dpd/srv/search?key=clic).
