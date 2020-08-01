# Instructions

1. Rename `.env.template` -> `.env`
2. Replace the `.env` variable values with appropriate ones 
    - for the ngrok variables, you will need an ngrok account (this is free)
3. Build the docker images using `docker-compose build`, this will take a while (~ 1h)
4. Run the containers using `docker-compose up -d`

If everything is working, you should be able to access your notebook on the server at port 8888, or at your ngrok domain (example https://andre-dev.ngrok.io)
