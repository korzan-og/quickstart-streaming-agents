# Streaming Agents on Confluent Cloud Quickstart

[![Sign up for Confluent Cloud](https://img.shields.io/badge/Sign%20up%20for%20Confluent%20Cloud-007BFF?style=for-the-badge&logo=apachekafka&logoColor=white)](https://www.confluent.io/get-started/?utm_campaign=tm.pmm_cd.q4fy25-quickstart-streaming-agents&utm_source=github&utm_medium=demo)

![Streaming Agents Intro Slide](./assets/streaming-agents-intro-slide.png)




Build real-time AI agents with [Confluent Cloud Streaming Agents](https://docs.confluent.io/cloud/current/ai/streaming-agents/overview.html). This quickstart includes two hands-on labs:

<table>
<tr>
<th width="25%">Lab</th>
<th width="75%">Description</th>
</tr>
<tr>
<td><a href="./LAB1-Walkthrough.md"><strong>Lab1 - MCP Tool Calling</strong></a></td>
<td>Price matching agent that scrapes competitor websites and adjusts prices in real-time<br><br><img src="./assets/lab1/lab1-architecture.png" alt="Lab1 Architecture"></td>
</tr>
<tr>
<td><a href="./LAB2-Walkthrough.md"><strong>Lab2 - Vector Search - RAG</strong></a></td>
<td>Vector search pipeline with optional retrieval augmented generation (RAG) for intelligent document retrieval<br><br><img src="./assets/lab2/mongodb/00_lab2_architecture.png" alt="Lab2 Architecture"></td>
</tr>
</table>

## Demo Video

[![Watch on YouTube](https://img.youtube.com/vi/F4bUUsVDBVE/hqdefault.jpg)](https://www.youtube.com/watch?v=F4bUUsVDBVE "Watch on YouTube")

## Prerequisites

**Required accounts & credentials:**

- [![Sign up for Confluent Cloud](https://img.shields.io/badge/Sign%20up%20for%20Confluent%20Cloud-007BFF?style=for-the-badge&logo=apachekafka&logoColor=white)](https://www.confluent.io/get-started/?utm_campaign=tm.pmm_cd.q4fy25-quickstart-streaming-agents&utm_source=github&utm_medium=demo)
- **Lab1:** Zapier account + SSE endpoint URL → [Setup guide](./LAB1-Walkthrough.md#zapier-mcp-server-setup)
- **Lab2:** MongoDB Atlas + connection string, database-specific user credentials → [Setup guide](./LAB2-Walkthrough.md#mongodb-atlas-setup)

## 🚀 Quick Start

Before you begin, ensure you completed prerequisites for Zapier and MongoDB.

* Ensure you are connected to the EC2 machine. If you are not, you can connect to the machine by typing below command:

```bash
ssh -i ./<name of the pem file>.pem ubuntu@<PublicDNS>
```


* **Clone the repository:**
   Run below command to clone the repo.

```bash
git clone https://github.com/korzan-og/quickstart-streaming-agents.git
cd quickstart-streaming-agents/
```

* **Run AWS export commands that you coped from Workshop studio event. Ensure you have changed keys and tokens with your own values**

```bash
export AWS_DEFAULT_REGION="us-east-1"
export AWS_ACCESS_KEY_ID="<YOUR_AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<YOUR_AWS_SECRET_ACCESS_KEY>"
export AWS_SESSION_TOKEN="<YOUR_AWS_SESSION_TOKEN>"
```
* [Sign in to Confluent Cloud](https://confluent.cloud/auth_callback)

* [Create an API key](https://docs.confluent.io/cloud/current/security/authenticate/workload-identities/service-accounts/api-keys/manage-api-keys.html#add-an-api-key).<br>
         a. Navigate to the hamburger icon on top right corner and select **API Keys**.<br>
         b. Click **Add API Key**.<br>
         c. Select "My Account" and click "Next".<br>
         d. Select **Cloud resource Management** and below this and click "Next".<br>
         ![](/assets/apikey.png)
         e. Add a name and a description and click "Next".<br>
         f. Click "Download API Key" at the bottom beside Complete button and once downloaded, click "Complete"<br>
         g. Modify below script and change <cloud_api_key> and <cloud_api_secret> with your values and run the commands.
 ```bash
    export CONFLUENT_CLOUD_API_KEY="<cloud_api_key>"
    export CONFLUENT_CLOUD_API_SECRET="<cloud_api_secret>"
```


* **Run below commands to start the deployment:**

```bash
python3 -m venv venv
source venv/bin/activate
pip install -e .
python deploy.py
```

That's it! The script will guide you through setup, automatically create API keys. 

- Ensure you deploy **all 3 labs** .

- Ensure you select **aws** as your Cloud vendor.

- Ensure you select **us-east-1** as your regions.

* When script completes the deployment, continue with Lab 1.

## Cleanup

**You may need to refresh AWS exports with below commands**

```bash
export AWS_DEFAULT_REGION="us-east-1"
export AWS_ACCESS_KEY_ID="<YOUR_AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<YOUR_AWS_SECRET_ACCESS_KEY>"
export AWS_SESSION_TOKEN="<YOUR_AWS_SESSION_TOKEN>"
```

```bash
# Automated
uv run destroy
```
