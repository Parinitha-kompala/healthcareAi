library(healthcareai)
quick_models <- machine_learn(pima_diabetes, patient_id, outcome = diabetes)
str(pima_diabetes)
quick_models
predictions <- predict(quick_models)
predictions
plot(predictions)
#checking Git
quick_models %>%
  predict(outcome_groups = 2) %>%
  plot()
missingness(pima_diabetes) %>%
  plot()
split_data <- split_train_test(d = pima_diabetes,
                               outcome = diabetes,
                               p = .9,
                               seed = 84105)
prepped_training_data <- prep_data(split_data$train, patient_id, outcome = diabetes,
                                   center = TRUE, scale = TRUE,
                                   collapse_rare_factors = FALSE)
models <- tune_models(d = prepped_training_data,
                      outcome = diabetes,
                      tune_depth = 25,
                      metric = "PR")
evaluate(models, all_models = TRUE)
models["Random Forest"] %>%
  plot()
untuned_rf <- flash_models(d = prepped_training_data,
                           outcome = diabetes,
                           models = "RF",
                           metric = "PR")
interpret(models) %>%
  plot()
get_variable_importance(models) %>%
  plot()
explore(models) %>%
  plot()
predict(models)
test_predictions <-
  predict(models,
          split_data$test,
          risk_groups = c(low = 30, moderate = 40, high = 20, extreme = 10)
  )
# > Prepping data based on provided recipe
plot(test_predictions)

save_models(models, file = "my_models.RDS")
models <- load_models("my_models.RDS")
regression_models <- machine_learn(pima_diabetes, patient_id, outcome = age)
summary(regression_models)
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
