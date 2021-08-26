#getting the library loaded
library(healthcareai)
#analysising the data 
pima_diabetes #inbuit dataframe
dim(pima_diabetes)
summary(pima_diabetes)
str(pima_diabetes)
#Machine learning
#prediction_1
head(pima_diabetes)
names(pima_diabetes)

quick_models <- machine_learn(pima_diabetes, patient_id, outcome = diabetes)
quick_models
predictions <- predict(quick_models)
predictions
plot(predictions)
#prediction_2(diabetic based on plasma_glucose)
a_quick_models <- machine_learn(pima_diabetes, plasma_glucose, outcome = diabetes)
a_quick_models
a_predictions <- predict(quick_models)
a_predictions
plot(a_predictions)
quick_models %>%
  predict(outcome_groups = 2) %>%
  plot()
a_quick_models %>%
  predict(outcome_groups = 2) %>%
  plot()
#data profiling
missingness(pima_diabetes)
missingness(pima_diabetes) %>%
  plot()
#data preparation
prep_data
split_data <- split_train_test(d = pima_diabetes,
                               outcome = diabetes,
                               p = .9,
                               seed = 84105)
prepped_training_data <- prep_data(split_data$train, patient_id, outcome = diabetes,
                                   center = TRUE, scale = TRUE,
                                   collapse_rare_factors = FALSE)
#model training
models <- tune_models(d = prepped_training_data,
                      outcome = diabetes,
                      tune_depth = 25,
                      metric = "PR")
evaluate(models, all_models = TRUE)
models["Random Forest"] %>%
  plot()
#faster model training
untuned_rf <- flash_models(d = prepped_training_data,
                           outcome = diabetes,
                           models = "RF",
                           metric = "PR")
#model interpretation
#interpret
interpret(models) %>%
  plot()
#variable importance
get_variable_importance(models) %>%
  plot()
# exploring
explore(models) %>%
  plot()
#prediction
predict(models)
test_predictions <-
  predict(models,
          split_data$test,
          risk_groups = c(low = 30, moderate = 40, high = 20, extreme = 10)
  )
# > Prepping data based on provided recipe
plot(test_predictions)
#Saving, Moving, and Loading Models
save_models(models, file = "my_models.RDS")
models <- load_models("my_models.RDS")
#regression models
regression_models <- machine_learn(pima_diabetes, patient_id, outcome = age)
summary(regression_models)
a_regression_models <- machine_learn(pima_diabetes, pregnancies, outcome = age)
summary(a_regression_models)
#prediction on a hypothetical new patient 1
new_patient <- data.frame(
  pregnancies = 0,
  plasma_glucose = 80,
  diastolic_bp = 55,
  skinfold = 24,
  insulin = NA,
  weight_class = "???",
  pedigree = .2,
  diabetes = "N")
predict(regression_models, new_patient)
#prediction on a hypothetical new patient 2
new_patient_2 <- data.frame(
  pregnancies = 3,
  plasma_glucose = 130,
  diastolic_bp = 60,
  skinfold = 24,
  insulin = NA,
  weight_class = "???",
  pedigree = .2,
  diabetes = "N")
predict(regression_models, new_patient_2)

