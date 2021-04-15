# Requirements
- nvidia container toolkit: 
  https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#setting-up-nvidia-container-toolkit

# Instructions
First, look at the Dockerfile and confirm the ARGs are correct for your setup. Specifically, find your GPU and set the `CUDA_ARCH_BIN` using the compute capability field listed for it from https://developer.nvidia.com/cuda-gpus#compute

1. Rename `.env.template` -> `.env`
2. Replace the `.env` variable values with appropriate ones 
    - for the ngrok variables, you will need an ngrok account (this is free)
3. Build the docker images using `docker-compose build`, this will take a while (~ 1h)
4. Run the containers using `docker-compose up -d`

If everything is working, you should be able to access your notebook on the server at port 8888, or at your ngrok domain. For example, in my .env file I set `NGROK_NOTEBOOK_DOMAIN=andre-dev` and can now view my notebook at https://andre-dev.ngrok.io

## Authenticate gsutil
I've installed gsutil in this docker image. Gsutil uses Google Cloud Storage, and is quite convenient in jupyter environments as it can be written into code cells using the '!' 

Here's an example that lists the contents of a made-up project "my-project", that can be run in a jupyter notebook cell:
```python
! gsutil ls gs://my-project
```

To authenticate gsutil, first start the docker-compose as mentioned in the docker-compose above. Next, connect to the running instance and authenticate using  
```
docker-compose exec jupyter bash
gcloud auth login
```


