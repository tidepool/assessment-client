/*global define */
define [
  'Backbone', 
  './routers/assessments_router'], (Backbone, AssessmentsRouter) ->
  assessmentsRouter = new AssessmentsRouter
  Backbone.history.start()

  assessmentsRouter
