App = require 'app'
debug = require('debug') 'DEBUG router'

App.Router = Em.Router.extend
  enableLogging: true

  doHome: (router, event) -> router.transitionTo 'home'

  gotoEmails: (router, event) -> router.transitionTo 'emails.index'

  doAdd: (router, event) -> router.transitionTo 'emails.create'


  root: Em.Route.extend

    index: Em.Route.extend
      route: '/'
      redirectsTo: 'home'

    home: Em.Route.extend
      route: '/home'
            
      connectOutlets: (router, context) ->
        router.get('applicationController')
          .connectOutlet 'main', 'home'

    emails: Em.Route.extend
      route: '/emails'

      index: Ember.Route.extend
        route: '/'

        showEmail: Ember.Route.transitionTo 'emails.email'

        connectOutlets: (router, context) ->
          router.get('applicationController')
            .connectOutlet 'main', 'emails', emails: App.EmailModel.find()

      email: Em.Route.extend
        route: '/:id'

        destroyItem: (router, event) ->
          email = event.context
          debug 'deleting email', email
          email.deleteRecord()
          App.store.commit()
          router.transitionTo 'emails.index'

        connectOutlets: (router, context) ->
          debug router, context
          email = App.EmailModel.find context.id

          router.get('applicationController')
            .connectOutlet 'main', 'email', email

      create: Em.Route.extend
        route: '/create'

        createItem: (router, event) ->
          email = event.context
          debug 'creating email', email, email.get 'title'
          App.store.commit()    # because already created
          router.transitionTo 'emails.index'

        exit: (router) ->
          router.get('createEmailController').exit()
        
        connectOutlets: (router, context) ->
          debug 'emails create'

          email = App.EmailModel.createRecord title: 'My Title'

          router.get('applicationController')
            .connectOutlet 'main', 'createEmail', email
