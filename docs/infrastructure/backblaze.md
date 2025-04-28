# :simple-backblaze: Backblaze Object Storage (S3)

[Backblaze B2 Cloud Storage](https://www.backblaze.com/cloud-storage) is used in my Homelab to store backups and provide object storage for various applications.

## :octicons-terminal-16: Backblaze B2 CLI

The [Backblaze B2 CLI](https://www.backblaze.com/docs/cloud-storage-command-line-tools) is used to create buckets, upload and download files, and manage your account.

Install the Backblaze B2 CLI on MacOS:

```bash
brew install b2-tools
```

## :fontawesome-solid-bucket: Creating a Backblaze B2 Bucket

Create a new bucket keeping only the last version of files:

```bash
BUCKET_NAME="my-bucket"
b2 bucket create "${BUCKET_NAME}" allPrivate
# To keep only the last version of files
b2 bucket create --lifecycle-rule '{"daysFromHidingToDeleting": 1, "daysFromUploadingToHiding": null, "fileNamePrefix": ""}' "${BUCKET_NAME}" allPrivate
```

## :octicons-key-16: Creating Application Keys

Create a new application key with specific permissions for a bucket:

```bash
BUCKET_NAME="my-bucket"
KEY_NAME="my-key"
b2 key create --bucket "${BUCKET_NAME}" "${KEY_NAME}" readFiles,writeFiles,listFiles,deleteFiles,readBuckets,listBuckets
```
