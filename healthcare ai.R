library(healthcareai)
quick_models <- machine_learn(pima_diabetes, patient_id, outcome = diabetes)
str(pima_diabetes)
quick_models
predictions <- predict(quick_models)
predictions
plot(predictions)
#checking Git