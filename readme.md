<div align="center">
  
  # Konnexio
  
  <strong>Monorepo d’automatisation, de gestion de données et de création d’interfaces low-code/no-code</strong>
  
  <em>Ce dépôt vise la simplicité et la fonctionnalité : chaque outil est prêt à l’emploi avec un minimum de configuration.</em>

  
  <a href="https://github.com/Optitoo/Konnexio"><img src="https://img.shields.io/github/stars/Optitoo/Konnexio?style=social" alt="GitHub stars"/></a>
  <a href="https://supabase.com/docs/"><img src="https://img.shields.io/badge/Supabase-Docs-green" alt="Supabase Docs"/></a>
  <a href="https://docs.n8n.io/"><img src="https://img.shields.io/badge/N8N-Docs-blue" alt="N8N Docs"/></a>
  <a href="https://docs.tooljet.ai/"><img src="https://img.shields.io/badge/Tooljet-Docs-orange" alt="Tooljet Docs"/></a>
</div>

---

## 🚀 Introduction

Ce projet regroupe plusieurs outils open source pour automatiser, manipuler des données et créer des interfaces rapidement.

### Conseils pour bien démarrer

- **Lisez ce README en entier** : il contient tout ce qu’il faut pour lancer chaque outil.
- **Docker est indispensable** : installez Docker Desktop et Docker Compose avant toute chose.
- **Chaque outil est indépendant** : lancez uniquement ce dont vous avez besoin (voir les sections plus bas).
- **Les fichiers `.env` sont essentiels** : copiez toujours le `.env.example` en `.env` et adaptez les variables.
- **En cas de problème, consultez la documentation officielle** (liens fournis pour chaque outil).
- **Gardez un œil sur l’historique des modifications** : il peut y avoir des changements importants.

### Points d’attention

- Les scripts PowerShell (`.ps1`) sont pour Windows, les scripts `.sh` pour Linux/macOS.
- Les migrations Supabase se font dans le dossier `local/supabase/migrations`.
- Pour Tooljet, le dossier `postgres_data` doit être présent avant le lancement.

---

## 🏗️ Structure du projet

```text
documentation/      → Guides, schémas, FAQ
local/              → Dev local Supabase (CLI, migrations, seed)
server/
  ├─ n8n/           → Automatisation de workflows
  ├─ supabase/      → Base de données, authentification, API
  └─ tooljet/       → Création d’interfaces et dashboards
```

---

## ⚡ Installation rapide

1. **Clonez le dépôt**
	```sh
	git clone https://github.com/Optitoo/Konnexio
	```
2. **Installez Docker & Docker Compose**
3. **(Optionnel) Installez npx pour le dev local Supabase**

---

## 🧩 Démarrage des outils

### Supabase (local)

À effectuer dans le dossier ```/local```

```sh
# Nouvelle migration
npx supabase@latest migration new <migration name>

# Démarrer le serveur local
npx supabase@latest start

# Résoudre un conflit/erreur 503
npx supabase@latest stop --no-backup
npx supabase@latest start

# Pousser les modifs vers le cloud
npx supabase@latest db push --db-url "postgres://user:pass@127.0.0.1:5432/postgres"
```

📚 [Documentation Supabase](https://supabase.com/docs/)
- [Installation CLI](https://supabase.com/docs/guides/local-development)
- [Usage CLI](https://supabase.com/docs/reference/cli/introduction)

---

### Supabase (server)

1. Copiez `.env.example` → `.env` et configurez les variables
2. Lancez :
	```sh
	docker-compose up -d
	```

---

### N8N

1. Copiez `.env.example` → `.env` et configurez les variables
2. Pour le serveur :
	```sh
	docker-compose up -d
	```
3. Pour le dev local :
	```sh
	docker-compose -f docker-compose.local.yml up -d
	```

📚 [Documentation N8N](https://docs.n8n.io/hosting/installation/docker/)

---

### Tooljet

1. Copiez `.env.exemple` → `.env` et configurez les variables
2. Générez les clés (dans `server/tooljet`) :
	- Linux/macOS :
		```sh
		./internal.sh
		```
	- Windows (PowerShell) :
		```powershell
		.\internal.ps1
		```
3. Vérifiez que le dossier `postgres_data` est présent
4. Lancez :
	```sh
	docker-compose up -d
	```

📚 [Documentation Tooljet](https://docs.tooljet.ai/docs/setup/docker/)

> ⚠️ L’installation de Tooljet peut prendre plusieurs minutes.

---

## 🔗 Intégrations

### Tooljet ↔ Supabase

- Si le menu Marketplace n’est pas visible, accédez à : `http://[nom_de_domaine]/integrations`
- Activez le plugin Supabase
- Configurez :
	- **url** : `http://host.docker.internal:8000` (accès machine hôte sous Windows)
	- **service key** : `[SERVICE KEY Supabase]`
- [Doc officielle](https://docs.tooljet.ai/docs/marketplace/plugins/marketplace-plugin-supabase/)

### Tooljet ↔ N8N

- Activez N8N dans les sources de données
- Configurez l’authentification si besoin
- [Doc officielle](https://docs.tooljet.ai/docs/data-sources/n8n/)
