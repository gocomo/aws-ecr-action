# AWS ECR Action

This Action allows you to create Docker images and push into a ECR repository.

## Environment Variables
| Parameter               | Type     | Default | Description                |
| ----------------------- | -------- | ------- | -------------------------- |
| `AWS_ACCESS_KEY_ID`     | `string` |         | Your AWS access key id     |
| `AWS_SECRET_ACCESS_KEY` | `string` |         | Your AWS secret access key |
| `AWS_ACCOUNT_ID`        | `string` |         | Your AWS Account ID        |
| `AWS_DEFAULT_REGION`    | `string` |         | Your AWS region            |

## Parameters
| Parameter          | Type      | Default      | Description                                                                                  |
| ------------------ | --------- | ------------ | -------------------------------------------------------------------------------------------- |
| `repo`             | `string`  |              | Name of your ECR repository                                                                  |
| `create_repo`      | `boolean` | `false`      | Set this to true to create the repository if it does not already exist                       |
| `tags`             | `string`  | `latest`     | Comma-separated string of ECR image tags (ex latest,1.0.0,)                                  |
| `dockerfile`       | `string`  | `Dockerfile` | Name of Dockerfile to use                                                                    |
| `extra_build_args` | `string`  | `""`         | Extra flags to pass to docker build (see docs.docker.com/engine/reference/commandline/build) |
| `path`             | `string`  | `.`          | Path to Dockerfile, defaults to the working directory                                        |
| `cwd`              | `string`  | `.`          | In which directory to execute commands in, defaults to working directory                     |

## Usage
```yaml
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
    - uses: kciter/aws-ecr-action@v1
      with:
        repo: docker/repo
        create_repo: true
        tags: latest,${{ github.sha }}
```

## Reference
* https://github.com/CircleCI-Public/aws-ecr-orb
* https://github.com/elgohr/Publish-Docker-Github-Action

## License
The MIT License (MIT)

Copyright (c) 2015 Lee Sun-Hyoup
