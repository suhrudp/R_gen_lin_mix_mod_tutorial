# GENERALIZED LINEAR MIXED-EFFECTS REGRESSION

## **LOAD LIBRARIES**

```{r}
library(lmerTest)
library(DHARMa)
library(visreg)
library(effects)
library(ggpubr)
library(emmeans)
library(gtsummary)
library(flextable)
library(report)
```

## **ATTACH DATA**

```{r}
df <- HSAUR3::toenail
attach(df)
View(df)
?toenail
df$outcome <- relevel(df$outcome, ref="moderate or severe")
```

## **DESCRIPTIVE ANALYSIS**

```{r}
table1 <- tbl_summary(df, include = c("outcome", "treatment", "time", "visit"))
table1
```

## **IMPORTANT GENERALIZED LINEAR MIXED-EFFECTS REGRESSION ASSUMPTIONS**

1.  Appropriate link function: Typically logit for binomial, log for Poisson, and so on.

2.  Linearity and additivity: The response variable is related to all predictors according to the link function and the effects of the predictors are additive on the linear scale.

3.  Homoscedasticity: The error variance of each predictor is constant across all values of that predictor.

4.  Normality and Dispersion: The residuals of the model are distributed according to the distributional family and are not over- or under-dispersed.

    ```{r}
    DHARMa::testResiduals(fit2)
    ```

## **UNADJUSTED MODEL**

```{r}
fit1 <- glmer(outcome ~ treatment + (1|patientID), family=binomial, data=df, nAGQ=20)
summary(fit1)
report(fit1)
table2 <- tbl_regression(fit1, exponentiate=T)
table2
```

## ADJUSTED MODEL

```{r}
fit2 <- glmer(outcome ~ treatment + visit + treatment*visit + (1|patientID), family=binomial, data=df, nAGQ=20)
summary(fit2)
report(fit2)
AIC(fit1, fit2)
table3 <- tbl_regression(fit2, exponentiate=T)
table4 <- tbl_merge(tbls=list(table2,table3),tab_spanner=c("Unadjusted","Adjusted"))
table4
```

## VISUALIZING THE MODEL

```{r}
visreg(fit2, "visit", by="treatment", overlay=T)
```

## ESTIMATED MARGINAL MEANS

```{r}
emmeans(fit1, pairwise ~ treatment)
```
