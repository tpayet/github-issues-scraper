# Export GitHub issues & pull requests to MeiliSearch

This script exports issues and pull request of any GitHub repository to MeiliSearch.

## Installation

```bash
$ bundle install
```

## Usage

```bash
$ GH_LOGIN=<your-github-login> \
  GH_TOKEN=<your-github-token> \
  GH_REPOSITORY=<user/repo> \
  MEILISEARCH_URL=<your-meilisearch-url> \
  MEILISEARCH_API_KEY=<your-meilisearch-api-key> \
  ruby app.rb

```

> **Note:** The script should work with no GitHub credentials but you will be limited to 60 req/hour. Using your GitHub credentials you can make up to 5000 req/hour.
