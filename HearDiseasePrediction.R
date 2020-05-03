library(matlib)
library(corrplot)
library(ggplot2)
data = read.csv("\Users\pavan\Desktop\Comp Stats\Project\heart.csv")
summary(data)


data_cor=cor(data)
corrplot(data_cor,method = "color")

#Data Visualizations
ggplot(data,aes(x=ï..age,group=target,fill=target))+
  geom_histogram(position="dodge",binwidth=5)+theme_bw()
ggplot(data,aes(x=chol,group=target,fill=target))+
  geom_histogram(position="dodge",binwidth=15)+theme_bw()
ggplot(data,aes(x=thalach,group=target,fill=target))+
  geom_histogram(position="dodge",binwidth=5)+theme_bw()
ggplot(data,aes(x=oldpeak,group=target,fill=target))+
  geom_histogram(position="dodge",binwidth=0.5)+theme_bw()
ggplot(data,aes(x=sex,group=target,fill=target))+
  geom_histogram(position="dodge",binwidth=0.25)+theme_bw()
ggplot(data,aes(x=target,group=target,fill=target))+
  geom_histogram(position="dodge",binwidth=0.25)+theme_bw()


X=data[,1:13] #Feature Variables
y=data[,14]   #Label variable
d <- dim(X)[2]  #Number of columns
n <- dim(X)[1]  #Number of Rows
nclasses=length(unique(y))  #Number of classes in target Variable


##Calculate number of zeros and ones in the "target" variable
z=c()
o=c()
tot=c()
for(j in 2:n){
  if(y[j]==1){
    z=c(z,list(X[j,1:13]))
  }else if(y[j]==0){
    o=c(o,list(X[j,]))
  }
}
tot=c(z,o)

##Calculate Mean Vector
zlen=length(z)  ##Number of 1's in "target" variable
olen=length(o)  ##Number of 0's in "target" variable

#calculate mean vector for label 1 and 0
z_mean=c()
o_mean=c()
for(j in 1:d){
  z1=c()
  o1=c()
  for(i in 1:zlen){
    z1=c(z1,z[[i]][j])
  }
  for(i in 1:olen){
    o1=c(o1,o[[i]][j])
  }
  z_mean=rbind(z_mean,mean(sapply(z1, mean)))
  o_mean=rbind(o_mean,mean(sapply(o1, mean)))
}

tot_mean=list(z_mean,o_mean)


#Subset of records for label 0 and 1
cls_z=c()
cls_o=c()
for(i in 1:zlen){
  z2=c()
  for(j in 1:13){
    z2=c(z2,z[[i]][j])
  }
  cls_z=rbind(cls_z,as.numeric(z2))
}
for(i in 1:olen){
  o2=c()
  for(j in 1:13){
    o2=c(o2,o[[i]][j])
  }
  cls_o=rbind(cls_o,as.numeric(o2))
}
cls=list(cls_z,cls_o)


#Calculate covariance matrix for both the labels
sigma=list(cov(cls[[1]]),cov(cls[[2]]))

#Check if the eigen value is negative
for(e in 1:2){
  A=cov(cls[[e]])
  ev=eigen(A)
  
  if(sum(all(ev$values<=0))!=0){
    print("Covariance matrix for is not definite positive for label")
    print(e-1)
  }
}

##Calculate inverse covariance matrix for both labels
sigma_inv=list(inv(sigma[[1]]),inv(sigma[[2]]))

##Calculate the det of covariance matrix
dt=list(det(sigma[[1]]),det(sigma[[2]]))

##Compute 1/sqrt(2pi^d det(Sigma))
scalars=list(1/sqrt(dt[[1]]*((2*pi)^d)),1/sqrt(dt[[2]]*((2*pi)^d)))

#Predict the label 
predict_func=function(nclasses,x,d){
  li=c()
  for(i in 1:nclasses){
    mu=tot_mean[[i]]
    sig_inv = sigma_inv[[i]]
    sc = scalars[[i]]
    m4=as.matrix(x-mu)
    m5=m4%*%sig_inv
    m6=m5%*%t(m4)
    exp1=m6*(-1/2)
    e_p=exp(exp1)*(-1/2) 
    li=c(li,sc*e_p) # Calculate likelihood of x under the assumption that class label is cls
  }
  return(which.max(li)) #Calculate Argmax of likelihood 
}



#Calculate the acuuracy of the prediction 
pred_y=c()
x1=0
for(i in 1:n){
  pred_y[i]=predict_func(nclasses,X[i,],d)-1
  if(pred_y[i]==y[i]){
    x1=x1+1
  }
}

#Calculate Accuracy
accuracy=x1/n

print("Accuracy is")
accuracy

