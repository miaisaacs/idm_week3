## Lab 3: SIR MODEL (cont'ed)
## Using the SIR model to study epidemic dynamics


#############################################################################
## !!! NOTE: Please focus on the questions in the lab slides (i.e. pdf file)  
##              -those are the core questions you need to answer. 
## Any additional questions in this R script are meant as guidelines.
#############################################################################

## if you haven't had it installed yet, type in the following first:
## install.packages('deSolve')
library(deSolve)

################################################################################
## SETTING UP THE SIR MODEL
################################################################################
# Step 1: code the SIR model (or function here)
SIR=function(t,state,parameters){
  with(as.list(c(state,parameters)),{
    # rate of change
    dS = -beta*S*I/N;
    dI= beta*S*I/N - gamma*I;
    dR = gamma*I;
    
    # return the rate of change
    list(c(dS, dI, dR))
  }) # end with(as.list...)
}

# Step 2: specify initial conditions/parameters
N=1e5; # population size
I0=10; # initial No. of Infectious people
S0=N-I0;  # initial No. of Susceptible people
R0=0; # initial No. of Recovered People
state=c(S=S0, I=I0, R=R0);  # store the inital conditions I & S together 
parameters=c(beta=.5,gamma=.3);  # store the model parameters, unit: per day

times=seq(0,100,by=1);  # set simulation time steps: 0 to 100 days here

# Step 3: call the ode function to generate the simulation
sim=ode(y=state,times=times,func=SIR,parms=parameters);



## LAB REPORT EXERCISES:
################################################################################
## Q1: What do we find R (# recovered)?
################################################################################
beta=.5; gamma=.3;
parameters=c(beta=beta,gamma=gamma)
times=seq(0,365,by=1);  # run for a year
state=c(S=S0,I=I0, R=R0)
sim=ode(y=state,times=times,func=SIR,parms=parameters);
# what are S, I at each point in time?
# what is R at each point in time?

plot(x = sim[,'time'], y = sim[,'S'], 
     xlab='Time', ylab='Susceptibles', 
     main='Susceptibles Across Time', type='l')

plot(x = sim[,'time'], y = sim[,'I'], 
     xlab='Time', ylab='Infectious', 
     main='Infectious Across Time', type='l')

plot(x = sim[,'time'], y = sim[,'R'], 
     xlab='Time', ylab='Recovered', 
     main='Recovered Across Time', type='l')

R = N - sim[, 'S'] - sim[, 'I']
plot(R)
plot(sim[, 'I'], type = 'l')
tail(R, 1)

################################################################################
## Q2: TEST HOW BETA AND GAMMA (R0) AFFECT THE EPIDEMIC
################################################################################
## CHANGE THE PARAMETERS SPECIFIC IN THE LAB ASSIGNMENT
## RUN THE MODEL AND SEE THE DIFFERENCE
## REPORT YOUR FINDINGS
beta=.5; gamma=.6;
parameters=c(beta=beta,gamma=gamma)
times=seq(0,365,by=1);  # run for a year
state=c(S=S0,I=I0, R=R0)
sim=ode(y=state,times=times,func=SIR,parms=parameters);

plot(x = sim[,'time'], y = sim[,'S'], 
     xlab='Time', ylab='Susceptibles', 
     main='Susceptibles Across Time', type='l')

plot(x = sim[,'time'], y = sim[,'I'], 
     xlab='Time', ylab='Infectious', 
     main='Infectious Across Time', type='l')

plot(x = sim[,'time'], y = sim[,'R'], 
     xlab='Time', ylab='Recovered', 
     main='Recovered Across Time', type='l')

R = N - sim[, 'S'] - sim[, 'I']
plot(R)
plot(sim[, 'I'], type = 'l')
tail(R, 1)


################################################################################
## Qs3&4: TEST EXPONENTIAL PERIOD: the first few weeks
################################################################################
N=1e5; I0=10; S0=N-I0; R0=0;
state=c(S=S0,I=I0, R=R0);
parameters=c(beta=.5,gamma=.3);

times=seq(0,100,by=1);
sim=ode(y=state,times=times,func=SIR,parms=parameters);
s=sim[,'S']/N
i=sim[,'I']/N
r=sim[,'R']/N

WkExp=8; # CHANGE THE NUMBER OF WEEK HERE
Iexp=sim[seq(1,length=WkExp,by=7),'I']; 
# NOTE: THE TIME STEP IN THE SIMULATION IS DAY, BUT WE ARE LOOKING AT WEEK HERE
# SO WE USE 'seq(1,length=WkExp,by=7)' TO EXTRACT THE CORRESPONDING DATE FOR EACH WEEK
lnI=log(Iexp); # TAKE THE LOG
tt=seq(1,length=WkExp,by=7)
fit=lm(lnI~tt) # LINEAR REGRESSION
slope=fit$coeff[2] ## extract the slope for the linear regression

slope <- coef(fit)[2]  # Extract the slope properly
print(slope)  # Display the value of the slope

par(mfrow=c(1,1),cex=1.5)
plot(tt,lnI,xlab='Time', ylab='Ln(I)', main='Natural Log of I Across Time')
lines(tt,fit$coeff[1]+fit$coeff[2]*tt,col='red',lwd=2)

## NOW TRY HOW LONG THE EXPONENTIAL PERIOD CAN LAST BY CHANING WkExp by yourself


################################################################################
## Q5: TEST EPIDEMIC BURNOUT
################################################################################
N=1e5; I0=10; S0=N-I0; R0=0;
beta=0.5; gamma=0.3
times=seq(0,600,by=1);
sim=ode(y=state,times=times,func=SIR,parms=parameters)




