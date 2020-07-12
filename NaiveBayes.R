bank <- read.csv("C:/Users/�ɰ���С��/Desktop/bank.csv",header=T,sep=";")#��������
n <- nrow(bank)
#��ԭ���ݰ���2:1���зָ�
index<-sample(1:nrow(bank),round(nrow(bank)*2/3))
length(index)
bank_training <- bank[index,] #ѵ����
bank_test <- bank[-index,]#���Լ�
library(e1071)#���� e1071 ��
m <- naiveBayes(y~., data=bank_training,laplace=1,na.action=na.pass)
#ѵ��ģ��
result<-predict(m,bank_test,type='raw')#�Բ������ݽ���Ԥ��
result1= ifelse(result[,1]<result[,2],1,0)
result2<-data.frame(result1)
result_2<-result2[,1]
m_evo<-table(result_2,bank_test$y)#����һ����������
#����ģ�͵�׼ȷ�ʡ������ȡ�����ȡ���ȷ�ȡ�F_score
tp = m_evo[1,1]
tn = m_evo[2,2]
fp = m_evo[1,2]
fn = m_evo[2,1]
accuracy = (tp + tn)/(tp + tn + fp + fn)
sensitive = tp/(tp + fn)
specificity = tn/(tn + fp)
precision = tp/(tp + fp)
F_score = (2*precision*sensitive)/(precision+sensitive)
print('׼ȷ�ʡ������ȡ�����ȡ���ȷ�ȷֱ�Ϊ��')#�������
print(c(accuracy,sensitive,specificity,precision))
install.packages('pROC')
library(pROC)#����һ�� pROC ��
roc1 <- roc(bank_test$y,result[,2],levels=c('no','yes'),direction="<")#�� ROC ����
plot(roc1,print.auc=TRUE,auc.polygon=TRUE,grid=c(0.1,0.2),grid.col=c("green","red"),max.auc.polygon=TRUE,auc.polygon.col="gray", print.thres=TRUE)