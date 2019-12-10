# Introduction to bioinformatics 

## DNF Coding Club Session #01 (06/11/2019)

### Welcome
As you might know, some people in our department are encouraging the use of new technologies for data analysis, visualisation and database scraping. With the support of the PIs, we are happy to announce the start of the DNF coding sessions (i.e. “DNF coding club”) that will provide the basics on daily research technologies such as bash, R, Jupyter and Shiny. 

The first coding session will take place in the APP room on Wednesday, November 6 from 13:30 to 18:00. The schedule is the following:

1. A quick intro to tools for reproducible research: git, bash, docker and jupyter.
2. A quick intro to R tools for data manipulation and visualization: dplyr and ggplot2.
3. Open discussion to prepare for coding topics next session and introduction to a custom-made application for batch image analysis.
4. Closure with food for brain: pizza.

Every module will take approximately 1h30, with intermittent breaks of 15 min.

The session is open to anyone with or without prior technical knowledge. These activities are designed to get familiar and used to these skills in a friendly and interactive environment. Only requirement is to bring your own laptop with wifi connection.

### Server Connection
http://130.223.196.101:8080

### Github 
https://github.com/

https://github.com/DNF-UNIL/Introduction_to_bioinformatics

### Bash 
https://explainshell.com/

#### Download image script

```
#/bin/bash

for i in {0..100}
do

echo $i
wget https://spainweather.es/webcams/malaga/current.jpg
sleep 3

done
```

### Jupyter Notebooks
https://jupyter.org/

#### Binder
https://mybinder.org/

### Docker
https://www.docker.com/

https://hub.docker.com/

### R 
by L. Telley

https://juba.github.io/tidyverse/02-prise_en_main.html

#### EBImage

It is necessary to first install this dependency in the terminal 

```bash
sudo apt-get update
sudo apt-get install libfftw3-3 libfftw3-dev libtiff5-dev
sudo conda install -c eumetsat fftw3
```

```R
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("EBImage")
```

### Shiny
by Adrian

https://github.com/DNF-UNIL/Introduction_to_bioinformatics/blob/master/presentations/2019.11.06_shiny_introduction.pptx

## How to install Docker

https://docs.docker.com/install/linux/docker-ce/ubuntu/

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

```

## DNF Coding Club Session #02 (06/11/2019)
