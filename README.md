# facets_assignment

I have tried to complete the assignment within the time frame provided to me. 

Please note the I was not able to use minikube since Ingress Service was not being exposed to my laptop(localhost), thereby could not check whether it was working or not. However, I had deployed Kubernetes in EC2 instance on AWS and using Nginx Ingress as the Load Balancer Solution and deployed as an nlb in AWS using annotations. Please note that kalraandassociates.com domain used here is my own and for learning purposes. 

The first directory are kubernetes yaml files used for the deployment purposes

The second directory contains the terraform files used to automate the task assigned to me by your organisation. I had first created deployment iteratively, followed by internal service and then the ingress rules.

Important point to note here is that as of now there are known limitations in Nginx Ingress canary annotations and thus only can be deployed per ingress rule.

Screenshots

![Screenshot (800)](https://user-images.githubusercontent.com/68735863/172018827-dc711bee-1304-4d2f-8007-dea825545cd5.png)

![Screenshot (801)](https://user-images.githubusercontent.com/68735863/172018768-11d63b0b-c0fa-45bc-bc4a-3566dfe787b0.png)

![Screenshot (802)](https://user-images.githubusercontent.com/68735863/172019192-1666f098-fd1e-4074-aeef-1057d4a2f53e.png)

![Screenshot (803)](https://user-images.githubusercontent.com/68735863/172019196-f97d8a21-6c1e-4d28-baab-41399e75d618.png)

![Screenshot (804)](https://user-images.githubusercontent.com/68735863/172019200-8701a8e9-8fbf-49d8-8a9e-12512abcb25b.png)

![Screenshot (805)](https://user-images.githubusercontent.com/68735863/172019206-834d149d-7314-4317-aae7-84b897bc46b5.png)

